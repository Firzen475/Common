


```shell
nano /etc/dnsmasq.conf
```
```ini
# ===== Общие настройки =====
# Прослушивать на локальном интерфейсе и LAN
listen-address=127.0.0.1,192.168.1.1

# Запретить прослушивание на WAN (безопасность)
no-dhcp-interface=eth1

# Логирование
log-queries
log-dhcp
log-facility=/var/log/dnsmasq.log

# Размер кэша (записей)
cache-size=10000

# Минимальный TTL для кэша (в секундах)
min-cache-ttl=300

# Игнорировать запросы к несуществующим доменам из /etc/hosts
stop-dns-rebind

# Блокировать reverse-DNS запросы для приватных IP
bogus-priv

# ===== Внешние DNS-серверы =====
# Google DNS и Cloudflare как резервные
server=8.8.8.8
server=1.1.1.1
server=208.67.222.222  # OpenDNS

# Использовать DoT (DNS-over-TLS) для безопасных запросов
proxy-dnssec
server=8.8.8.8@853#dns.google
server=1.1.1.1@853#cloudflare-dns.com

# ===== Локальные домены и hosts =====
# Читать /etc/hosts
addn-hosts=/etc/hosts.dnsmasq

# Локальный домен для LAN
local=/lan/
domain=lan

# Динамические хосты из DHCP
dhcp-host=aa:bb:cc:dd:ee:ff,192.168.1.50,printer.lan
dhcp-host=00:11:22:33:44:55,192.168.1.100,server.lan

# ===== Настройки DHCP =====
# Диапазон IP и маска подсети
dhcp-range=192.168.1.100,192.168.1.200,255.255.255.0,24h

# Шлюз и DNS-сервер для клиентов
dhcp-option=3,192.168.1.1  # Gateway
dhcp-option=6,192.168.1.1  # DNS (этот же сервер)

# NTP-сервер для клиентов
dhcp-option=42,192.168.1.1

# ===== Блокировка рекламы и трекеров =====
# Файл с блокируемыми доменами
conf-file=/etc/dnsmasq.adblock

# Ручная блокировка
address=/ads.example.com/0.0.0.0
address=/tracking.example.com/0.0.0.0

# ===== Перенаправления =====
# Все запросы к example.com → 192.168.1.10
address=/example.com/192.168.1.10

# Wildcard-перенаправление (*.dev → 127.0.0.1)
address=/dev/127.0.0.1

# ===== Безопасность =====
# Не отвечать на запросы из WAN
no-resolv

# Блокировать DNS-rebind атаки
stop-dns-rebind

# Фильтровать подозрительные домены
bogus-nxdomain=64.94.110.11
```
