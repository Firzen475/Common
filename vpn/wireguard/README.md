
## На VPS

```shell
curl -sSL https://get.docker.com | sh
nano ./docker-compose.yml
sudo docker compose up -d
```

## На роутере
```shell
nano /etc/config/network

/etc/init.d/network restart
service dnsmasq restart
```
