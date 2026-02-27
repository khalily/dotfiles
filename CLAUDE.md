# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive Neovim configuration repository that provides a full-featured IDE experience. It includes automated installation scripts, Neovim configuration, and Tmux configuration.

## Key Files

- `init.vim` - Main Neovim configuration (1100+ lines) with plugin setup using Dein.vim
- `install.sh` - Automated installation script for Neovim, Tmux, CMake, and Pyenv
- `uninstall.sh` - Uninstallation script
- `tmux.conf` - Tmux terminal multiplexer configuration

## Common Commands

### Installation & Setup

```bash
# Full installation
./install.sh

# Install specific Neovim version
export NVIM_VERSION="v0.9.5"
./install.sh

# Uninstall
./uninstall.sh
```

### Neovim Usage

- `nvim` - Start Neovim
- `,` (comma) - Leader key for all custom mappings
- `<leader>ev` - Edit init.vim
- `<leader>sv` - Source init.vim
- `<leader>n` - Toggle NERDTree file explorer
- `<leader>t` - Toggle Tagbar function list
- `<F5>` - Toggle Undo Tree
- `<F2>` - Toggle line numbers

### Tmux Usage

- `Ctrl+a` - Prefix key
- `<prefix>c` - Create new window
- `<prefix>-` - Horizontal split
- `<prefix>|` - Vertical split
- `<prefix>r` - Reload tmux.conf

## Code Architecture

### Plugin Management

Uses **Dein.vim** as the plugin manager. Plugins are organized in `init.vim` by category:
- Look & feel (color schemes, airline, etc.)
- Code formatting
- Code manipulation
- Text objects
- Snippets (UltiSnips)
- Navigation (NERDTree, Tagbar, CtrlP, FZF)
- Autocompletion (Deoplete with language-specific sources)
- Git integration (Fugitive, GitGutter)
- Language-specific (Python, Go, Haskell, C/C++, etc.)

### Key Plugins

- **Deoplete** - Async autocompletion engine
- **Jedi-Vim** - Python integration
- **Vim-Go** - Go development
- **ClangComplete** - C/C++ completion
- **ALE** - Linting
- **NERDTree** - File explorer
- **Tagbar** - Symbol browser
- **CtrlP/FZF** - Fuzzy finding

### Installation Script Architecture

The `install.sh` script:
1. Installs build dependencies via apt-get (Linux) or Homebrew (macOS)
2. Installs CMake 3.28.1+ to `~/.cmake`
3. Compiles Neovim from source to `~/.nvim`
4. Compiles Tmux 3.5a+ from source to `~/.tmux`
5. Installs Pyenv via git clone to `~/.pyenv`
6. Sets up Python virtual environments (py3neovim, py2neovim) with pynvim
7. Updates shell config (bashrc/zshrc) with PATH and pyenv integration

### Environment Variables

- `NVIM_VERSION` - Neovim version/branch to install (default: master)
- `NVIM_MIRROR` - Neovim download mirror URL

## Making Changes

- Neovim configuration goes in `init.vim`
- Tmux configuration goes in `tmux.conf`
- Installation logic goes in `install.sh`

## Changelog

### 2026-02-27: macOS Full Support

Added complete macOS (Darwin) support to `install.sh`:

**Key Features:**
- **Homebrew Priority**: macOS uses Homebrew as primary installation method
- **Universal Architecture**: Supports both Apple Silicon (arm64) and Intel (x86_64)
- **Version Enforcement**: Ensures macOS versions meet or exceed Linux versions
- **Source Fallback**: Automatically compiles from source if Homebrew versions are insufficient

**New Functions:**
- `check_xcode_command_line_tools()` - Detects and installs Xcode Command Line Tools
- `install_homebrew_if_needed()` - Automatically installs Homebrew if missing
- `brew_install_with_version_check()` - Homebrew installation with version validation
- `install_cmake_from_source_macos()` - Compiles CMake from source on macOS
- `install_tmux_from_source_macos()` - Compiles Tmux from source on macOS
- `install_neovim_from_source_macos()` - Compiles Neovim from source on macOS
- `get_nproc()` - Cross-platform CPU core count detection
- `cleanup_tmp_dir()` - Utility for safe temporary directory cleanup

**Version Requirements:**
| Tool | Minimum Version | Install Version |
|------|----------------|----------------|
| CMake | >= 3.16.0 | 3.28.1 |
| Tmux | >= 2.9a | 3.5a |
| Neovim | latest | master branch |

**Security & Robustness Improvements:**
- Removed `eval` usage for version extraction to avoid code injection risks
- Added interactive terminal check (`[ -t 0 ]`) to prevent blocking in CI/CD environments
- Proper configure flags spacing for safe command construction
- Unified temporary directory cleanup across all functions

**Backward Compatibility:**
- Linux functionality completely unchanged
- All existing environment variables still work
- Uninstall script already supported macOS
