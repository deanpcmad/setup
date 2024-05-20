#!/bin/bash

# Update sources to use GB mirror
sudo sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/gb.archive.ubuntu.com\/ubuntu/g' /etc/apt/sources.list
sudo sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/gb.archive.ubuntu.com\/ubuntu/g' /etc/apt/sources.list.d/ubuntu.sources

# Update & Upgrade
sudo apt update -y
sudo apt upgrade -y

# Install packages
sudo apt install -y \
	git curl wget gpg htop btop unzip \
	build-essential pkg-config autoconf bison rustc cargo clang \
	libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
	libvips imagemagick libmagickwand-dev fish \
	redis-tools sqlite3 libsqlite3-0 mysql-client libmysqlclient-dev

# Atuin
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)

# Docker
if ! command -v docker &> /dev/null
then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update && sudo apt install -y docker-ce docker-ce-cli docker-compose-plugin containerd.io
fi

if [ -f /opt/docker-compose.yml ]
else
  sudo chown dean:dean /opt
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/docker-compose.yml -O /opt/docker-compose.yml
fi

# asdf install
if [ ! -d ~/.asdf ]
then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

  ~/.asdf/bin/asdf plugin add ruby
  ~/.asdf/bin/asdf plugin add nodejs

  ~/.asdf/bin/asdf install ruby 3.3.1
  ~/.asdf/bin/asdf install nodejs 20.11.1

  ~/.asdf/bin/asdf global ruby 3.3.1
  ~/.asdf/bin/asdf global nodejs 20.11.1
fi

# Fish
if [ -f ~/.config/fish/config.fish ]
then
  echo "Fish config already exists"
else
  mkdir -p ~/.config/fish
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/config.fish -O ~/.config/fish/config.fish
  mkdir -p ~/.config/fish/completions
  ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
fi

if [ -f ~/.gitconfig ]
else
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/gitconfig -O ~/.gitconfig
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/gitignore -O ~/.gitignore
fi

if [ -f ~/.gemrc ]
else
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/gemrc -O ~/.gemrc
fi

# AWS CLI
if ! command -v aws &> /dev/null
then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

# 1Password & 1Password CLI
if ! command -v 1password &> /dev/null
then
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list

  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

  sudo apt update && sudo apt install -y 1password 1password-cli
fi

# GitHub CLI
if ! command -v gh &> /dev/null
then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update && sudo apt install -y gh 
fi

# Ulauncher
if ! command -v ulauncher &> /dev/null
then
  sudo add-apt-repository universe -y
  sudo add-apt-repository ppa:agornostal/ulauncher -y
  sudo apt update && sudo apt install -y ulauncher
fi

# Chrome
if ! command -v chrome &> /dev/null
then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
fi

# VSCode
if ! command -v code &> /dev/null
then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update && sudo apt install -y code
fi

# Obsidian
if ! command -v obsidian &> /dev/null
then
  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.12/obsidian_1.5.12_amd64.deb
  sudo apt install -y ./obsidian_1.5.12_amd64.deb
fi

# Kopia
if ! command -v kopia &> /dev/null
then
  curl -s https://kopia.io/signing-key | sudo gpg --dearmor -o /etc/apt/keyrings/kopia-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/kopia-keyring.gpg] http://packages.kopia.io/apt/ stable main" | sudo tee /etc/apt/sources.list.d/kopia.list
  sudo apt update && sudo apt install -y kopia kopia-ui
fi

# Nextcloud Client
if ! command -v nextcloud &> /dev/null
then
  sudo add-apt-repository ppa:nextcloud-devs/client -y
  sudo apt update && sudo apt install -y nextcloud-desktop
fi