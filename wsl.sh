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

# Docker Hoster
if [ -f /opt/docker-compose.yml ]
then
  echo "Docker Hoster already installed"
else
  sudo chown dean:dean /opt
  wget https://github.com/deanpcmad/ubuntu/raw/main/docker-compose.yml -O /opt/docker-compose.yml
fi

# asdf install
if [ ! -d ~/.asdf ]
then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
fi

# Fish
if [ -f ~/.config/fish/config.fish ]
then
  echo "Fish config already exists"
else
  mkdir -p ~/.config/fish
  wget https://github.com/deanpcmad/ubuntu/raw/main/config.fish -O ~/.config/fish/config.fish
  mkdir -p ~/.config/fish/completions
  ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
fi

if command -v asdf &> /dev/null
then
  ~/.asdf/bin/asdf plugin add ruby
  ~/.asdf/bin/asdf plugin add nodejs
fi

# AWS CLI
if ! command -v aws &> /dev/null
then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
fi

# GitHub CLI
if ! command -v gh &> /dev/null
then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh -y
fi
