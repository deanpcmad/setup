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
	libvips imagemagick libmagickwand-dev fish vlc gnome-browser-connector \
	redis-tools sqlite3 libsqlite3-0 mysql-client libmysqlclient-dev 

# Google Chrome
if ! command -v google-chrome &> /dev/null
then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo dpkg -i google-chrome-stable_current_amd64.deb
  rm -rf google-chrome-stable_current_amd64.deb
fi

# Remove Firefox Snap and install from Mozilla
sudo apt remove -y firefox
sudo snap remove firefox
if [ -f /etc/apt/preferences.d/mozilla ]
then
  echo "mozilla preferences exists"
else
  sudo install -d -m 0755 /etc/apt/keyrings
  wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
  gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
  echo "Package: *
  Pin: origin packages.mozilla.org
  Pin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla
  sudo apt-get update && sudo apt-get install firefox
fi


# Atuin
if ! command -v atuin &> /dev/null
then
  bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
fi

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
then
  echo "docker-compose.yml exists"
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

  echo ">> Installing Ruby 3.1.1"
  ~/.asdf/bin/asdf install ruby 3.3.1
  ~/.asdf/bin/asdf global ruby 3.3.1

  echo ">> Installing NodeJS 20.11.1"
  ~/.asdf/bin/asdf install nodejs 20.11.1
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
then
  echo "gitconfig exists"
else
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/gitconfig -O ~/.gitconfig
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/gitignore -O ~/.gitignore
fi

if [ -f ~/.gemrc ]
then
  echo "gemrc exists"
else
  wget https://github.com/deanpcmad/ubuntu/raw/main/dotfiles/gemrc -O ~/.gemrc
fi

# AWS CLI
if ! command -v aws &> /dev/null
then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
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

# VSCode
if ! command -v code &> /dev/null
then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt update && sudo apt install -y code
fi

# Lazygit
if ! command -v lazygit &> /dev/null
then
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
fi

# Obsidian
if ! command -v obsidian &> /dev/null
then
  OBSIDIAN_VERSION=$(curl -s "https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  wget https://github.com/obsidianmd/obsidian-releases/releases/download/v${OBSIDIAN_VERSION}/obsidian_${OBSIDIAN_VERSION}_amd64.deb
  sudo apt install -y ./obsidian_${OBSIDIAN_VERSION}_amd64.deb
  rm -rf obsidian_${OBSIDIAN_VERSION}_amd64.deb
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