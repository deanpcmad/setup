# Ubuntu Install

## WSL

```
wget -q -O - https://raw.githubusercontent.com/deanpcmad/ubuntu/main/wsl.sh | bash
```

After running the above command:

```
chsh dean -s /usr/bin/fish
fish
sudo usermod -aG docker dean
docker compose -f /opt/docker-compose.yml up -d
```


## Ubuntu

```bash
wget -q -O - https://raw.githubusercontent.com/deanpcmad/ubuntu/main/ubuntu.sh | bash
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