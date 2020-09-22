#!/usr/bin/env bash

function install_package() {
  local package=$1
  local system=$(uname -s)
  case $system in
    'Darwin' )
      brew info $package | grep --quiet 'Not installed' && brew install $package
      ;;
    'Linux' )
      apt-get install -y $package
      ;;
    * )
      printf "Unspport system %s" $system
      exit 1
      ;;
  esac
}

system=$(uname -s)
if [ $system = 'Linux' ];then
  repo_path=/tmp/neovim-$(date +%Y-%m-%d-%H-%M)
  git clone https://github.com/neovim/neovim.git $repo_path
  cd $repo_path
  sudo apt-get install -y libboost-dev libboost-program-options-dev libpython3-all-dev
  sudo apt-get install -y silversearcher-ag
  sudo apt-get install -y ack-grep
  sudo apt-get install -y cmake
  sudo apt-get install -y pkgconf libtool libtool-bin automake gettext libevent-dev libncurses5-dev
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev libssl1.0-dev
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=~/.nvim"
  make install

  git clone https://github.com/tmux/tmux.git /tmp/tmux
  cd /tmp/tmux
  sh autogen.sh
  ./configure --prefix="$HOME/.tmux" && make -j12
  make install

  curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
  git clone https://github.com/yyuu/pyenv-virtualenv.git  ~/.pyenv/plugins/pyenv-virtualenv
  cat << "EOF" >> ~/.bashrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:~/.nvim/bin:$PATH"
export PATH="~/.tmux/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF
  source ~/.bashrc
fi

if [ $system = 'Darwin' ];then
  install_package ack
  install_package cmake
  install_package neovim
  install_package pyenv
  install_package pyenv-virtualenv
  install_package the_silver_searcher
  install_package tmux
  if ! $(grep PYENV_ROOT ~/.zshrc); then
  cat << "EOF" >> ~/.zshrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF
  fi
  source ~/.zshrc
fi

pyenv install -s 3.6.5
CONFIGURE_OPTS="--enable-shared" pyenv virtualenv 3.6.5 py3neovim
pyenv activate py3neovim
pip install neovim
pyenv deactivate py3neovim

pyenv install -s 2.7.18
CONFIGURE_OPTS="--enable-shared" pyenv virtualenv 2.7.18 py2neovim
pyenv activate py2neovim
pip install neovim
pyenv deactivate py2neovim

pyenv global 3.6.5
pip install autopep8
pip install flake8


echo -e "================================"
echo -e "   \nInstall Successful.\n"
echo -e "   \nsource your ~/.bashrc or ~/.zshrc"
echo -e "================================"
echo -e  "\nopen your nvim.\n"


