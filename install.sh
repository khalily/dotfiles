#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Neovim 版本 - 使用 master 分支最新代码
# 可以通过环境变量 NVIM_VERSION 覆盖，例如: export NVIM_VERSION="v0.9.5"
NVIM_VERSION="${NVIM_VERSION:-master}"

# Neovim 下载镜像源
GITHUB_URL="https://github.com/neovim/neovim/releases/download"
# 可以通过环境变量 NVIM_MIRROR 使用镜像源，例如:
# export NVIM_MIRROR="https://ghproxy.com/https://github.com/neovim/neovim/releases/download"

function log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

function log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

function log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

function get_nproc() {
    if command_exists nproc; then
        nproc
    elif command_exists sysctl; then
        sysctl -n hw.ncpu
    else
        echo 4
    fi
}

# =============================================================================
# Common Utility Functions
# =============================================================================

function cleanup_tmp_dir() {
    if [ -n "${1:-}" ] && [ -d "$1" ]; then
        rm -rf "$1"
    fi
}

# =============================================================================
# macOS Helper Functions
# =============================================================================

function check_xcode_command_line_tools() {
    if [ "$(uname -s)" != "Darwin" ]; then
        return
    fi

    log_info "Checking Xcode Command Line Tools..."
    if xcode-select -p >/dev/null 2>&1; then
        log_info "Xcode Command Line Tools are installed"
        return
    fi

    log_warn "Xcode Command Line Tools not found"
    log_info "Please install them by running:"
    log_info "  xcode-select --install"
    log_info ""
    log_info "Then re-run this script after installation is complete."
    log_info ""
    log_info "Alternatively, you can install full Xcode from the App Store."

    # 尝试自动安装（会弹出提示）
    if ! command_exists gcc; then
        log_info "Attempting to trigger Xcode Command Line Tools installation..."
        xcode-select --install 2>/dev/null || true
    fi

    # 仅在交互式终端中等待用户输入
    if [ -t 0 ]; then
        read -p "Press Enter once you have installed Xcode Command Line Tools, or Ctrl+C to exit..."
    else
        log_error "Xcode Command Line Tools are required in non-interactive mode"
        exit 1
    fi
}

function install_homebrew_if_needed() {
    if [ "$(uname -s)" != "Darwin" ]; then
        return
    fi

    if command_exists brew; then
        log_info "Homebrew is already installed"
        return
    fi

    log_warn "Homebrew not found"
    log_info "Installing Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 添加 Homebrew 到 PATH（对于新安装）
    if [ -d "/opt/homebrew/bin" ]; then
        export PATH="/opt/homebrew/bin:$PATH"
    elif [ -d "/usr/local/bin" ]; then
        export PATH="/usr/local/bin:$PATH"
    fi

    if command_exists brew; then
        log_info "Homebrew installed successfully!"
    else
        log_error "Failed to install Homebrew"
        exit 1
    fi
}

function brew_install_with_version_check() {
    local package=$1
    local min_version=${2:-}
    local version_extract_field=${3:-"NF"}  # 默认取最后一个字段

    if ! command_exists brew; then
        return 1
    fi

    log_info "Checking $package via Homebrew..."

    # 检查是否已安装
    if ! brew list "$package" &>/dev/null; then
        log_info "Installing $package via Homebrew..."
        brew install "$package"
    else
        log_info "$package is already installed via Homebrew"
    fi

    # 如果不需要版本检查，直接返回
    if [ -z "$min_version" ]; then
        return 0
    fi

    # 检查版本
    if command_exists "$package"; then
        local current_ver=""
        if [ "$package" = "cmake" ]; then
            current_ver=$(cmake --version 2>/dev/null | head -1 | awk '{print $3}')
        elif [ "$package" = "tmux" ]; then
            current_ver=$(tmux -V 2>/dev/null | head -1 | awk '{print $2}')
        else
            # 通用回退：尝试 --version 并取最后一个字段
            current_ver=$("$package" --version 2>/dev/null | head -1 | awk "{print \$$version_extract_field}")
        fi

        if [ -n "$current_ver" ]; then
            if version_ge "$current_ver" "$min_version"; then
                log_info "$package version $current_ver meets requirement (>= $min_version)"
                return 0
            else
                log_warn "$package version $current_ver is too old (needs >= $min_version)"
                return 1
            fi
        fi
    fi

    return 1
}

function install_cmake_from_source_macos() {
    local cmake_version="3.28.1"
    log_info "Compiling CMake $cmake_version from source on macOS..."

    local tmp_dir=$(mktemp -d)
    local url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}.tar.gz"

    if ! wget --timeout=60 --tries=3 -O "$tmp_dir/cmake.tar.gz" "$url"; then
        log_error "Failed to download CMake source"
        cleanup_tmp_dir "$tmp_dir"
        return 1
    fi

    tar -xzf "$tmp_dir/cmake.tar.gz" -C "$tmp_dir"
    pushd "$tmp_dir/cmake-${cmake_version}"

    ./bootstrap --prefix="$HOME/.cmake" --parallel="$(get_nproc)"
    make -j"$(get_nproc)"
    make install

    popd
    cleanup_tmp_dir "$tmp_dir"

    if [ -f ~/.cmake/bin/cmake ]; then
        log_info "CMake compiled and installed successfully!"
        ~/.cmake/bin/cmake --version | head -1
        export PATH="$HOME/.cmake/bin:$PATH"
        return 0
    else
        log_error "CMake source installation failed"
        return 1
    fi
}

function install_tmux_from_source_macos() {
    local tmux_version="3.5a"
    local our_tmux=~/.tmux/bin/tmux

    log_info "Compiling tmux $tmux_version from source on macOS..."

    # 确保依赖已安装
    if command_exists brew; then
        for pkg in libevent ncurses; do
            if ! brew list "$pkg" &>/dev/null; then
                log_info "Installing $pkg via Homebrew..."
                brew install "$pkg"
            fi
        done
    fi

    local tmp_dir=$(mktemp -d)
    local url="https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz"

    if ! wget --timeout=30 --tries=3 -O "$tmp_dir/tmux.tar.gz" "$url"; then
        log_error "Failed to download tmux source"
        cleanup_tmp_dir "$tmp_dir"
        return 1
    fi

    tar -xzf "$tmp_dir/tmux.tar.gz" -C "$tmp_dir"
    pushd "$tmp_dir/tmux-${tmux_version}"

    # macOS 特定的 configure 标志
    local configure_flags="--prefix=$HOME/.tmux"

    # 添加 Homebrew 路径 - 注意前面有空格
    if [ -d "/opt/homebrew/opt/libevent" ]; then
        configure_flags="$configure_flags LIBEVENT_CFLAGS=-I/opt/homebrew/opt/libevent/include"
        configure_flags="$configure_flags LIBEVENT_LIBS=-L/opt/homebrew/opt/libevent/lib"
    elif [ -d "/usr/local/opt/libevent" ]; then
        configure_flags="$configure_flags LIBEVENT_CFLAGS=-I/usr/local/opt/libevent/include"
        configure_flags="$configure_flags LIBEVENT_LIBS=-L/usr/local/opt/libevent/lib"
    fi

    if [ -d "/opt/homebrew/opt/ncurses" ]; then
        configure_flags="$configure_flags --with-ncurses=/opt/homebrew/opt/ncurses"
    elif [ -d "/usr/local/opt/ncurses" ]; then
        configure_flags="$configure_flags --with-ncurses=/usr/local/opt/ncurses"
    fi

    ./configure $configure_flags
    make -j"$(get_nproc)"
    make install

    popd
    cleanup_tmp_dir "$tmp_dir"

    if [ -f "$our_tmux" ]; then
        log_info "tmux compiled and installed successfully!"
        "$our_tmux" -V
        return 0
    else
        log_error "tmux source installation failed"
        return 1
    fi
}

function install_neovim_from_source_macos() {
    log_info "Compiling neovim ($NVIM_VERSION branch) from source on macOS..."

    # 检查必要的编译工具
    local missing_deps=()
    for cmd in git make cmake gcc; do
        if ! command_exists "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing build dependencies: ${missing_deps[*]}"
        log_info "Please install them first"
        return 1
    fi

    local tmp_dir=$(mktemp -d)
    local repo_dir="${tmp_dir}/neovim"

    local repo_url="https://github.com/neovim/neovim.git"
    log_info "Cloning from $repo_url..."

    if [ "$NVIM_VERSION" = "master" ]; then
        if ! git clone --depth 1 "$repo_url" "$repo_dir"; then
            log_error "Failed to clone repository"
            cleanup_tmp_dir "$tmp_dir"
            return 1
        fi
    else
        if ! git clone --depth 1 --branch "$NVIM_VERSION" "$repo_url" "$repo_dir"; then
            log_error "Failed to clone repository"
            cleanup_tmp_dir "$tmp_dir"
            return 1
        fi
    fi

    pushd "$repo_dir"

    log_info "Building neovim (this may take a while)..."
    if ! make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.nvim" -j"$(get_nproc)"; then
        log_error "Build failed"
        popd
        cleanup_tmp_dir "$tmp_dir"
        return 1
    fi

    log_info "Installing neovim..."
    if ! make install; then
        log_error "Install failed"
        popd
        cleanup_tmp_dir "$tmp_dir"
        return 1
    fi

    popd
    cleanup_tmp_dir "$tmp_dir"

    if [ -f ~/.nvim/bin/nvim ]; then
        log_info "Neovim compiled and installed successfully!"
        ~/.nvim/bin/nvim --version | head -1
        return 0
    else
        log_error "Neovim source installation failed"
        return 1
    fi
}

# =============================================================================
# Package Installation
# =============================================================================

function install_package() {
    local package=$1
    local system=$(uname -s)
    case $system in
        'Darwin' )
            if ! command_exists brew; then
                log_error "Homebrew not installed. Please install Homebrew first."
                exit 1
            fi
            if ! brew list "$package" &>/dev/null; then
                log_info "Installing $package..."
                brew install "$package"
            else
                log_info "$package is already installed"
            fi
            ;;
        'Linux' )
            if ! dpkg -s "$package" &>/dev/null; then
                log_info "Installing $package..."
                sudo apt-get install -y "$package"
            else
                log_info "$package is already installed"
            fi
            ;;
        * )
            log_error "Unsupported system $system"
            exit 1
            ;;
    esac
}

# =============================================================================
# Version Comparison
# =============================================================================

function version_ge() {
    # 比较版本号，返回 0 (true) 如果 $1 >= $2
    local ver1=$(echo "$1" | sed 's/[^0-9.]//g')
    local ver2=$(echo "$2" | sed 's/[^0-9.]//g')

    local IFS=.
    read -ra v1 <<< "$ver1"
    read -ra v2 <<< "$ver2"

    # 补全版本号长度
    while [ ${#v1[@]} -lt ${#v2[@]} ]; do v1+=("0"); done
    while [ ${#v2[@]} -lt ${#v1[@]} ]; do v2+=("0"); done

    for i in "${!v1[@]}"; do
        if [ "${v1[$i]}" -gt "${v2[$i]}" ]; then
            return 0
        elif [ "${v1[$i]}" -lt "${v2[$i]}" ]; then
            return 1
        fi
    done
    return 0
}

# =============================================================================
# CMake Installation
# =============================================================================

function install_cmake() {
    local min_cmake_version="3.16.0"
    local cmake_version="3.28.1"
    local system=$(uname -s)

    # 检查我们自己的 cmake
    if [ -f ~/.cmake/bin/cmake ]; then
        local current_ver=$(~/.cmake/bin/cmake --version | head -1 | awk '{print $3}')
        if version_ge "$current_ver" "$min_cmake_version"; then
            log_info "Our cmake $current_ver is sufficient"
            export PATH="$HOME/.cmake/bin:$PATH"
            return
        fi
    fi

    # 检查系统 cmake
    if command_exists cmake; then
        local current_ver=$(cmake --version | head -1 | awk '{print $3}')
        if version_ge "$current_ver" "$min_cmake_version"; then
            log_info "System cmake $current_ver is sufficient"
            return
        else
            log_warn "System cmake $current_ver is too old, installing our own"
        fi
    fi

    if [ "$system" = "Darwin" ]; then
        # macOS: 先尝试 Homebrew
        if command_exists brew; then
            if brew_install_with_version_check "cmake" "$min_cmake_version"; then
                return
            fi
            log_warn "Homebrew cmake not sufficient, compiling from source..."
        fi

        # 从源码编译
        install_cmake_from_source_macos
    elif [ "$system" = "Linux" ]; then
        # Linux: 现有逻辑 - 下载二进制包
        log_info "Installing cmake $cmake_version..."

        local tmp_dir=$(mktemp -d)
        local url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}-linux-x86_64.tar.gz"

        if wget --timeout=60 --tries=3 -O "$tmp_dir/cmake.tar.gz" "$url"; then
            tar -xzf "$tmp_dir/cmake.tar.gz" -C "$tmp_dir"

            mkdir -p ~/.cmake
            cp -r "$tmp_dir/cmake-${cmake_version}-linux-x86_64"/* ~/.cmake/

            cleanup_tmp_dir "$tmp_dir"

            if [ -f ~/.cmake/bin/cmake ]; then
                log_info "cmake installed successfully!"
                ~/.cmake/bin/cmake --version | head -1
                export PATH="$HOME/.cmake/bin:$PATH"
            else
                log_error "cmake installation failed"
            fi
        else
            cleanup_tmp_dir "$tmp_dir"
            log_error "Failed to download cmake"
        fi
    fi
}

# =============================================================================
# Neovim Installation
# =============================================================================

function install_neovim_binary() {
    if command_exists nvim; then
        log_info "nvim is already installed"
        nvim --version | head -1
        return
    fi

    local system=$(uname -s)
    local arch=$(uname -m)

    if [ "$system" != "Linux" ] || [ "$arch" != "x86_64" ]; then
        log_error "Unsupported system/arch: $system/$arch"
        return 1
    fi

    # 检查必要的编译工具
    local missing_deps=()
    for cmd in git make cmake gcc g++; do
        if ! command_exists "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing build dependencies: ${missing_deps[*]}"
        log_info "Please install them first"
        return 1
    fi

    log_info "Cloning and building neovim ($NVIM_VERSION branch)..."

    local tmp_dir=$(mktemp -d)
    local repo_dir="${tmp_dir}/neovim"

    # Clone 源码
    local repo_url="https://github.com/neovim/neovim.git"
    log_info "Cloning from $repo_url..."

    if [ "$NVIM_VERSION" = "master" ]; then
        # master 分支 --depth 1
        if ! git clone --depth 1 "$repo_url" "$repo_dir"; then
            log_error "Failed to clone repository"
            cleanup_tmp_dir "$tmp_dir"
            return 1
        fi
    else
        # 指定 tag/分支
        if ! git clone --depth 1 --branch "$NVIM_VERSION" "$repo_url" "$repo_dir"; then
            log_error "Failed to clone repository"
            cleanup_tmp_dir "$tmp_dir"
            return 1
        fi
    fi

    pushd "$repo_dir"

    # 编译安装
    log_info "Building neovim (this may take a while)..."
    if ! make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.nvim" -j"$(nproc)"; then
        log_error "Build failed"
        popd
        cleanup_tmp_dir "$tmp_dir"
        return 1
    fi

    log_info "Installing neovim..."
    if ! make install; then
        log_error "Install failed"
        popd
        cleanup_tmp_dir "$tmp_dir"
        return 1
    fi

    popd
    cleanup_tmp_dir "$tmp_dir"

    if [ -f ~/.nvim/bin/nvim ]; then
        log_info "Neovim compiled and installed successfully!"
        ~/.nvim/bin/nvim --version | head -1
        return 0
    else
        log_error "Neovim installation failed"
        return 1
    fi
}

function install_neovim() {
    if command_exists nvim; then
        log_info "nvim is already installed"
        nvim --version | head -1
        return
    fi

    local system=$(uname -s)

    if [ "$system" = "Linux" ]; then
        log_info "Installing neovim from binary (skipping apt)..."
        if install_neovim_binary; then
            return
        fi

        log_error "Neovim binary installation failed"
        log_info "Please install neovim manually: https://neovim.io/"
        exit 1
    elif [ "$system" = "Darwin" ]; then
        # macOS: 先尝试 Homebrew
        if command_exists brew; then
            log_info "Checking neovim via Homebrew..."
            if ! brew list neovim &>/dev/null; then
                log_info "Installing neovim via Homebrew..."
                brew install neovim
            else
                log_info "neovim is already installed via Homebrew"
            fi

            if command_exists nvim; then
                log_info "Neovim installed via Homebrew successfully!"
                nvim --version | head -1
                return
            fi
        fi

        log_warn "Homebrew neovim not available, compiling from source..."
        if ! install_neovim_from_source_macos; then
            log_error "Neovim source installation failed"
            log_info "Please install neovim manually: https://neovim.io/"
        fi
    fi
}

# =============================================================================
# Tmux Installation
# =============================================================================

function install_tmux() {
    local tmux_version="3.5a"
    local min_required="2.9a"
    local our_tmux=~/.tmux/bin/tmux
    local system=$(uname -s)

    # 检查我们自己安装的 tmux
    if [ -f "$our_tmux" ]; then
        local current_ver=$("$our_tmux" -V | awk '{print $2}')
        log_info "Found our tmux: $current_ver"

        if version_ge "$current_ver" "$min_required"; then
            log_info "tmux version $current_ver meets requirement (>= $min_required)"
            return
        else
            log_warn "tmux version $current_ver is too old, reinstalling..."
            rm -rf ~/.tmux
        fi
    # 检查系统 tmux
    elif command_exists tmux; then
        local current_ver=$(tmux -V | awk '{print $2}')
        log_info "Found system tmux: $current_ver"

        if version_ge "$current_ver" "$min_required"; then
            log_info "tmux version $current_ver meets requirement (>= $min_required)"
            return
        else
            log_warn "System tmux $current_ver is too old, installing our own..."
        fi
    fi

    if [ "$system" = "Linux" ]; then
        log_info "Installing tmux $tmux_version from source (skipping apt)..."

        local tmp_dir=$(mktemp -d)
        local url="https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz"

        if wget --timeout=30 --tries=3 -O "$tmp_dir/tmux.tar.gz" "$url"; then
            tar -xzf "$tmp_dir/tmux.tar.gz" -C "$tmp_dir"

            pushd "$tmp_dir/tmux-${tmux_version}"
            ./configure --prefix="$HOME/.tmux"
            make -j"$(nproc)"
            make install
            popd

            cleanup_tmp_dir "$tmp_dir"
            if [ -f "$our_tmux" ]; then
                log_info "tmux installed successfully!"
                "$our_tmux" -V
            else
                log_error "tmux installation failed"
            fi
        else
            cleanup_tmp_dir "$tmp_dir"
            log_warn "Failed to download tmux, skipping tmux installation"
        fi
    elif [ "$system" = "Darwin" ]; then
        # macOS: 先尝试 Homebrew
        if command_exists brew; then
            if brew_install_with_version_check "tmux" "$min_required"; then
                return
            fi
            log_warn "Homebrew tmux not sufficient, compiling from source..."
        fi

        # 从源码编译
        install_tmux_from_source_macos
    fi
}

# =============================================================================
# Pyenv Installation
# =============================================================================

function install_pyenv() {
    if [ -d ~/.pyenv ]; then
        log_info "pyenv is already installed"
        return
    fi

    log_info "Installing pyenv via git clone (skipping apt)..."

    if [ ! -d ~/.pyenv ]; then
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    fi

    if [ ! -d ~/.pyenv/plugins/pyenv-virtualenv ]; then
        git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
    fi

    log_info "pyenv installed successfully"
}

# =============================================================================
# Shell Config
# =============================================================================

function setup_shell_config() {
    local shell_rc
    local system=$(uname -s)

    if [ "$system" = "Darwin" ]; then
        shell_rc=~/.zshrc
    else
        shell_rc=~/.bashrc
    fi

    local config='
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.cmake/bin:$HOME/.nvim/bin:$HOME/.tmux/bin:$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi
'

    if ! grep -q "PYENV_ROOT" "$shell_rc"; then
        log_info "Adding pyenv and PATH config to $shell_rc"
        echo "$config" >> "$shell_rc"
    else
        log_info "Shell config already exists in $shell_rc"
    fi

    # 在当前会话中生效
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$HOME/.cmake/bin:$HOME/.nvim/bin:$HOME/.tmux/bin:$PYENV_ROOT/bin:$PATH"
    if [ -d "$PYENV_ROOT" ] && command -v pyenv &>/dev/null; then
        eval "$("$PYENV_ROOT/bin/pyenv" init - 2>/dev/null || true)"
        eval "$("$PYENV_ROOT/bin/pyenv" virtualenv-init - 2>/dev/null || true)"
    fi
}

# =============================================================================
# Python and Neovim Setup
# =============================================================================

function install_python_and_neovim() {
    if ! command -v pyenv &>/dev/null; then
        log_warn "pyenv not available, skipping Python setup"
        return
    fi

    # 使用更现代的 Python 版本
    local py3_version="3.11.8"
    local py2_version="2.7.18"

    # 检查 Python 3 是否需要安装
    if ! pyenv versions | grep -q "$py3_version" && ! pyenv install --list 2>/dev/null | grep -q "^  $py3_version\$"; then
        log_info "Python $py3_version not available, trying a newer version..."
        py3_version="3.10.13"
    fi

    log_info "Installing Python $py3_version..."
    pyenv install -s "$py3_version"

    log_info "Creating py3neovim virtualenv..."
    CONFIGURE_OPTS="--enable-shared" pyenv virtualenv -f "$py3_version" py3neovim || true
    pyenv activate py3neovim
    pip install -q pynvim
    pyenv deactivate

    # Python 2 是可选的
    if pyenv install --list 2>/dev/null | grep -q "^  $py2_version\$"; then
        log_info "Installing Python $py2_version..."
        pyenv install -s "$py2_version"

        log_info "Creating py2neovim virtualenv..."
        CONFIGURE_OPTS="--enable-shared" pyenv virtualenv -f "$py2_version" py2neovim || true
        pyenv activate py2neovim
        pip install -q pynvim
        pyenv deactivate
    else
        log_warn "Python 2.7 not available, skipping"
    fi

    pyenv global "$py3_version"
    pip install -q autopep8 flake8
}

# =============================================================================
# Main
# =============================================================================

function main() {
    local system=$(uname -s)

    log_info "Starting installation..."
    log_info "Neovim version: $NVIM_VERSION"
    log_info "Note: Skipping package manager installation for nvim/tmux/pyenv"

    if [ "$system" = "Linux" ]; then
        # 仅安装编译依赖，不通过 apt 安装 nvim/tmux/pyenv
        log_info "Checking for essential build tools..."

        local packages=(
            git wget curl make build-essential
            libssl-dev zlib1g-dev libbz2-dev libreadline-dev
            libsqlite3-dev llvm libncurses5-dev libncursesw5-dev
            xz-utils tk-dev libffi-dev liblzma-dev
            libevent-dev pkgconf libtool libtool-bin automake gettext
            cmake libncurses-dev bison
        )

        for pkg in "${packages[@]}"; do
            if ! dpkg -s "$pkg" &>/dev/null; then
                log_info "Installing build dependency: $pkg"
                sudo apt-get install -y "$pkg" 2>/dev/null || log_warn "Failed to install $pkg, skipping..."
            else
                log_info "$pkg is already installed"
            fi
        done

        install_cmake
        install_neovim
        install_tmux
    elif [ "$system" = "Darwin" ]; then
        log_info "macOS detected, setting up..."

        # 检查 Xcode Command Line Tools
        check_xcode_command_line_tools

        # 检查/安装 Homebrew
        install_homebrew_if_needed

        # 安装依赖
        log_info "Installing macOS dependencies via Homebrew..."

        local mac_packages=(
            git wget curl make autoconf automake libtool pkg-config
            openssl@3 readline sqlite3 xz zlib libffi libevent ncurses
            gettext bison m4
        )

        for pkg in "${mac_packages[@]}"; do
            if ! brew list "$pkg" &>/dev/null; then
                log_info "Installing $pkg..."
                brew install "$pkg" 2>/dev/null || log_warn "Failed to install $pkg, skipping..."
            else
                log_info "$pkg is already installed"
            fi
        done

        # 安装核心组件
        install_cmake
        install_neovim
        install_tmux
    fi

    install_pyenv
    setup_shell_config
    install_python_and_neovim

    echo
    echo "================================"
    echo -e "   ${GREEN}Install Complete.${NC}"
    echo
    echo "   Please restart your shell or run:"
    if [ "$system" = "Darwin" ]; then
        echo "   source ~/.zshrc"
    else
        echo "   source ~/.bashrc"
    fi
    echo
    if command_exists nvim; then
        echo "   Then you can run: nvim"
    elif [ -f ~/.nvim/bin/nvim ]; then
        echo "   Then you can run: ~/.nvim/bin/nvim"
    fi
    echo "================================"
    echo
}

main "$@"
