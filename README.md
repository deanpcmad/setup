# Ubuntu Install

### CLI

```
sudo apt update -y
sudo apt install -y \
	git curl wget htop btop \
	build-essential pkg-config autoconf bison rustc cargo clang \
	libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2 \
	libvips imagemagick libmagickwand-dev \
	redis-tools sqlite3 libsqlite3-0 mysql-client libmysqlclient-dev
```

### Atuin

```
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
mkdir -p ~/.config/atuin
echo 'sync_address = "https://atuin.d34n.uk"' >> ~/.config/atuin/config.toml
```

### Docker

```
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker dean
```

### rbenv

```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
echo 'bundler' >> ~/.default-gems
```

### Fish

```
sudo apt install -y fish
chsh dean -s /usr/bin/fish
mkdir -p ~/.config/fish
wget https://github.com/deanpcmad/ubuntu/raw/main/config.fish -O ~/.config/fish/config.fish
fish
```

### Apps 

```
sudo snap install 1password spotify vlc discord
```

### debs

```
cd ~/Downloads
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/e170252f762678dec6ca2cc69aba1570769a5d39/code_1.88.1-1712771838_amd64.deb
sudo apt install ./code_1.88.1-1712771838_amd64.deb

cd -
```

### Ruby

```
rbenv install 3.3.0
rbenv global 3.3.0
```

### Setup GitHub CLI

```
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
gh auth login
```

### Setup GitHub Desktop

```
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
sudo apt update && sudo apt install github-desktop
```
