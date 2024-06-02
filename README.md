# PC Setup

## Windows

### Chris Titus Windows Util:

```
iwr -useb https://christitus.com/win | iex
```

Apps to select:

- Chrome
- Firefox
- Discord
- VS Code
- Obsidian
- Epic Games
- Steam
- PowerToys
- ShareX
- 1Password
- NanaZip
- Nextcloud Desktop
- Tailscale

Other apps to install:

- [Mullvad](https://mullvad.net/en/download/vpn/windows)
- [Spotify](https://download.scdn.co/SpotifySetup.exe)
- [Elgato Streamdeck](https://www.elgato.com/us/en/s/downloads)
- [Cyberduck](https://cyberduck.io/download/)
- [Cura](https://ultimaker.com/software/ultimaker-cura/)

### WSL

```
wsl --install -d "Ubuntu-24.04"
```

```
wget -q -O - https://raw.githubusercontent.com/deanpcmad/setup/main/wsl.sh | bash
```

After running the above command:

```
chsh dean -s /usr/bin/fish
fish
sudo usermod -aG docker dean
docker compose -f /opt/docker-compose.yml up -d
```

### GPG

```
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export KEY
git config --global user.signingkey  KEY
git config --global commit.gpgsign true
```


## Ubuntu

```bash
wget -q -O - https://raw.githubusercontent.com/deanpcmad/setup/main/ubuntu.sh | bash
```

After install:

```bash
chsh dean -s /usr/bin/fish
fish
sudo usermod -aG docker dean
docker compose -f /opt/docker-compose.yml up -d

sudo snap install spotify discord
```

Fix hotkeys in wayland: https://github.com/Ulauncher/Ulauncher/wiki/Hotkey-In-Wayland

Gnome Extensions:

- https://extensions.gnome.org/extension/4548/tactile/
- https://extensions.gnome.org/extension/6242/emoji-copy/

Change default terminal size:

```
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'\n")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ default-size-columns 150
```
