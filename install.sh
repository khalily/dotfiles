#!/usr/bin/env bash

set -e

system=$(uname -s)
if [ $system = 'Linux' ];then
  repo_path=/tmp/neovim-$(date +%Y-%m-%d-%H-%M)
  git clone https://github.com/neovim/neovim.git $repo_path
  cd $repo_path
  sudo apt-get install -y silversearcher-ag
  sudo apt-get install -y ack-grep
  sudo apt-get install -y cmake
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=~/.nvim"
  make install

  curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
  git clone https://github.com/yyuu/pyenv-virtualenv.git  ~/.pyenv/plugins/pyenv-virtualenv
  cat << "EOF" >> ~/.bashrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:~/.nvim/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF
  source ~/.bashrc
fi

if [ $system = 'Darwin' ];then
  brew install ack
  brew install cmake
  brew install neovim
  brew install pyenv
  brew install pyenv-virtualenv
  brew install the_silver_searcher
  cat << "EOF" >> ~/.zshrc

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF
  source ~/.zshrc
fi

sudo pip install autopep8
sudo pip install flake8
pyenv install 3.6.5
CONFIGURE_OPTS="--enable-shared" pyenv virtualenv 3.6.5 py3neovim
pyenv activate py3neovim
pip install neovim
pyenv deactivate py3neovim

echo "================================"
echo "   \nInstall Successful.\n"
echo "================================"
echo  "\nopen your nvim.\n"


