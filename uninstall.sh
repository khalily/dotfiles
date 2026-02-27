#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

function log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

function log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

function confirm() {
    read -p "$1 (y/N) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

function remove_dir() {
    local dir=$1
    if [ -d "$dir" ]; then
        log_info "Removing $dir..."
        rm -rf "$dir"
    else
        log_warn "$dir does not exist, skipping"
    fi
}

function remove_from_shell_config() {
    local shell_rc
    local system=$(uname -s)

    if [ "$system" = "Darwin" ]; then
        shell_rc=~/.zshrc
    else
        shell_rc=~/.bashrc
    fi

    if [ -f "$shell_rc" ]; then
        log_info "Removing config from $shell_rc..."

        # 创建临时文件
        local temp_file=$(mktemp)

        # 标记是否在配置块内
        local in_block=0

        while IFS= read -r line; do
            if [[ "$line" == *"PYENV_ROOT"* && "$line" == "export PYENV_ROOT"* ]]; then
                in_block=1
                continue
            fi
            if [ $in_block -eq 1 ]; then
                if [[ "$line" == "fi" ]]; then
                    in_block=0
                    continue
                fi
                continue
            fi
            echo "$line" >> "$temp_file"
        done < "$shell_rc"

        # 替换原文件
        mv "$temp_file" "$shell_rc"
        log_info "Shell config removed from $shell_rc"
    fi
}

function main() {
    local system=$(uname -s)

    echo
    echo "================================"
    echo -e "   ${RED}Uninstall Script${NC}"
    echo "================================"
    echo

    log_warn "This will remove:"
    echo "  - ~/.cmake (CMake)"
    echo "  - ~/.nvim (Neovim compiled from source)"
    echo "  - ~/.tmux (Tmux)"
    echo "  - ~/.pyenv (Pyenv)"
    echo "  - Configuration from shell rc file"
    echo

    if ! confirm "Are you sure you want to continue?"; then
        log_info "Uninstall cancelled"
        exit 0
    fi

    echo

    # 移除 CMake
    if confirm "Remove CMake (~/.cmake)?"; then
        remove_dir ~/.cmake
    fi

    # 移除 Neovim
    if confirm "Remove Neovim (~/.nvim)?"; then
        remove_dir ~/.nvim
    fi

    # 移除 Tmux
    if confirm "Remove Tmux (~/.tmux)?"; then
        remove_dir ~/.tmux
    fi

    # 移除 Pyenv
    if confirm "Remove Pyenv (~/.pyenv)?"; then
        remove_dir ~/.pyenv
    fi

    # 移除 Shell 配置
    if confirm "Remove configuration from shell rc file?"; then
        remove_from_shell_config
    fi

    echo
    echo "================================"
    echo -e "   ${GREEN}Uninstall Complete${NC}"
    echo "================================"
    echo
    log_info "Please restart your shell for changes to take effect"
    echo
}

main "$@"
