#!/bin/bash

# Update sources to use GB mirror
sudo sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu/http:\/\/gb.archive.ubuntu.com\/ubuntu/g' /etc/apt/sources.list

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

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Atuin
#bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)

# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker dean

# Docker Hoster
sudo chown dean:dean /opt
cat << EOF >> /opt/docker-compose.yml
services:
  hoster:
    image: dvdarias/docker-hoster
    container_name: hoster
    restart: always
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock
      - /etc/hosts:/tmp/hosts
EOF
docker compose -f /opt/docker-compose.yml up -d

# asdf install
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# Fish
chsh dean -s /usr/bin/fish
mkdir -p ~/.config/fish
wget https://github.com/deanpcmad/ubuntu/raw/main/config.fish -O ~/.config/fish/config.fish
mkdir -p ~/.config/fish/completions
ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
fish

# Ruby
asdf plugin add ruby
asdf install ruby 3.3.1
asdf global ruby 3.3.1

# Node
asdf plugin add nodejs
asdf install nodejs 20.11.1
asdf global nodejs 20.11.1

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y \
