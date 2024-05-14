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
