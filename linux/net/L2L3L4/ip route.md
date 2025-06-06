
## Принципы работы
* default - маршрутов по умолчанию может быть много, выбирается вариант с минимальной метрикой и пока доступен.
* Одинаковые метрики - маршрут выбирается случайно.
* Для PPPoE/VPN **не нужно** указывать шлюз. 
* Политики маршрутизации
  * Существуют 3 основных таблицы правил:
    * local - Правила для localhost (lo)
    * main - Основные правила
    * default - Правила для default-маршрутов.
    * Пользовательские правила. Пример:
      ```shell
      # Создаем таблицу для VPN
      echo "200 vpn" >> /etc/iproute2/rt_tables
      # Добавляем маршрут через VPN в таблицу 200
      ip route add default via 10.8.0.1 dev tun0 table vpn
      # Правило: если источник — 192.168.1.100, использовать таблицу "vpn"
      ip rule add from 192.168.1.100 lookup vpn
      ```
## show
```shell
ip route show

default via 192.168.1.1 dev eth0 proto static metric 100 
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10 
10.0.0.0/8 via 192.168.1.2 dev eth0 metric 200
```
* `default` - маршрут по умолчанию, ip или подсеть.
* `via` - ip шлюза.
* `dev` - интерфейс.
* `proto` - кто добавил маршрут:
  * `kernel` - Автоматически для локальных сетей `192.168.1.0/24 dev eth0 proto kernel`
  * `static` - Ручные маршруты.
  * `dhcp` - Маршруты, полученные от DHCP-сервера.
  * `boot` - Загрузочные скрипты (Устаревшее, встречается в некоторых дистрибутивах).
  * `ospf\bgp` - Динамическая маршрутизация (Добавляются демонами вроде Bird или FRR).
* `scope` - зона действия:
  * `global` - Маршрут ведет в "глобальную" сеть (например, Интернет).
  * `link` - Целевая сеть доступна напрямую (в том же L2-сегменте).
  * `host` - Маршрут ведет к конкретному IP на этом же хосте (loopback, локальные адреса).
  * `null` - Ядро автоматически определит зону действия маршрута на основе других параметров (например, наличия шлюза или типа сети).
* `src` - Предпочтительный исходный IP для исходящих пакетов.
* `table` - в какой таблице правило.
* `metric` - метрика маршрута.
```shell
# Список таблиц с политиками.
ip rule show
---
0:      from all lookup local
32766:  from all lookup main
32767:  from all lookup default
# маршруты в таблице.
ip route show table local
---
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1
local 172.17.0.1 dev docker0 proto kernel scope host src 172.17.0.1
broadcast 172.17.255.255 dev docker0 proto kernel scope link src 172.17.0.1 linkdown
local 172.18.0.1 dev docker_gwbridge proto kernel scope host src 172.18.0.1
broadcast 172.18.255.255 dev docker_gwbridge proto kernel scope link src 172.18.0.1
local 192.168.2.10 dev eth0 proto kernel scope host src 192.168.2.10
broadcast 192.168.2.255 dev eth0 proto kernel scope link src 192.168.2.10
```
## Управление
#### Обычные правила
```shell
ip route add 192.168.10.0/24 via 10.0.0.1
ip route add 192.168.10.0/24 via 10.0.0.1 dev eth0
ip route add 192.168.10.0/24 via 10.0.0.1 metric 100
```
#### Правила с таблицами
```shell
# Создаем таблицу для VPN
echo "200 vpn" >> /etc/iproute2/rt_tables
# Добавляем маршрут через VPN в таблицу 200
ip route add default via 10.8.0.1 dev tun0 table vpn
# Правило: если источник — 192.168.1.100, использовать таблицу "vpn"
ip rule add from 192.168.1.100 lookup vpn
# Удаление правила.
ip route del default via 10.8.0.1 dev tun0 table vpn
```
#### Правила на основе меток
```shell
bash
# Создаем таблицу для ssh
echo "300 ssh" >> /etc/iproute2/rt_tables
# Помечаем SSH-пакеты меткой 42
iptables -t mangle -A OUTPUT -p tcp --dport 22 -j MARK --set-mark 42
# Правило: если есть метка 42, использовать таблицу "ssh"
ip rule add fwmark 42 lookup ssh
ip route add default via 10.0.0.1 dev tun0 table ssh
```

