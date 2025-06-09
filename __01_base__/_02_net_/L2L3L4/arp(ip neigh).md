**ARP (Address Resolution Protocol)** — это протокол, используемый в компьютерных сетях для определения **MAC-адреса** устройства по его **IP-адресу** в локальной сети (LAN).

## Просмотр
```shell
$ arp -n
Address        HWtype  HWaddress           Flags Mask    Iface
192.168.1.1    ether   aa:bb:cc:dd:ee:ff   C            eth0
192.168.1.2    ether   00:11:22:33:44:55   C            wlan0

$ ip neigh
192.168.1.1 dev eth0 lladdr aa:bb:cc:dd:ee:ff REACHABLE
192.168.1.2 dev wlan0 lladdr 00:11:22:33:44:55 STALE
```
**Флаги в `ip neigh`**:
* REACHABLE — запись актуальна.
* STALE — запись устарела, но ещё не удалена.
* DELAY — ожидается подтверждение.
* FAILED — адрес недоступен.

## Управление 
#### Очистка ARP-кеша:
```shell
ip neigh flush all
```
#### Настройка ARP-параметров ядра
```shell
# Увеличение времени жизни ARP-записей (в секундах)
echo 300 | sudo tee /proc/sys/net/ipv4/neigh/eth0/gc_stale_time
# Включение логирования ARP-событий
echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/log_martians
```

## Мониторинг
```shell
tcpdump -i eth0 arp -n
14:20:00.123456 ARP, Request who-has 192.168.1.2 tell 192.168.1.1, length 28
14:20:00.123789 ARP, Reply 192.168.1.2 is-at 00:11:22:33:44:55, length 28
```
* `who-has` — ARP-запрос.
* `is-at` — ARP-ответ