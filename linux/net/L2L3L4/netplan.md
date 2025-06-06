```shell
netplan apply
```
#### Статика
```yaml
network:
  version: 2
  renderer: networkd  # или NetworkManager
  ethernets:
    ens32:
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
```

#### DHCP
```yaml
network:
    ethernets:
        ens32:
            critical: true
            dhcp-identifier: mac
            dhcp4: true
            nameservers:
                addresses:
                - 192.168.2.1
                search:
                - home.lan
    version: 2
```

#### route
```shell
echo "200 vpn" | sudo tee -a /etc/iproute2/rt_tables
```
```yaml
network:
  version: 2
  ethernets:
    eth0:  # ваш основной интерфейс
      dhcp4: true  # или статический IP
      dhcp-identifier: mac
      routes:
        - to: 0.0.0.0/0  # маршрут по умолчанию
          via: 192.168.1.1  # ваш основной шлюз
          table: main  # (опционально, main - таблица по умолчанию)
  
  # Настройка политик маршрутизации для VPN
  routing-policy:
    - from: 192.168.1.100  # исходный IP
      table: vpn  # используем таблицу "vpn"
#      via: 10.8.0.1 # Вариант без таблиц!
  
  # Настройка таблицы "vpn"
  routes:
    - table: vpn  # имя таблицы из /etc/iproute2/rt_tables
      to: 0.0.0.0/0  # маршрут по умолчанию для таблицы vpn
      via: 10.8.0.1  # шлюз VPN (tun0)
      scope: global
```