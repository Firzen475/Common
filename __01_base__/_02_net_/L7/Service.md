
## DHCPd

[Оглавление](../../../__00_Собес__/README.md#оглавление) => [Сеть](../../../__00_Собес__/01_Сеть/README.md#схема)

port 67 — сервер.  
port 68 — клиент.

[dnsmasq config](./dnsmasq.md)

### Debug server

```shell
# Проверка конфигурации
sudo dhcpd -t -cf /etc/dhcp/dhcpd.conf
# Запуск в режиме debug (-f — работа в foreground)
sudo dhcpd -d -f -cf /etc/dhcp/dhcpd.conf eth0
# Анализ трафика
sudo tcpdump -i eth0 -n port 67 or port 68 -vv
```
* `DHCP Discover` – клиент ищет сервер.
* `DHCP Offer` – сервер предлагает IP.
* `DHCP Request` – клиент запрашивает адрес.
* `DHCP ACK/NACK` – подтверждение или отказ.

### Debug client
```shell
# Проверка аренды DHCP (файлы аренды)
cat /var/lib/dhcp/dhclient.leases  # Ubuntu/Debian
cat /var/lib/NetworkManager/dhclient-*.lease  # Если используется NetworkManager

sudo dhclient -r eth0  # Освобождаем текущий lease (release)
sudo dhclient -v eth0  # Запрашиваем новый IP (verbose-режим)

sudo dhclient -d eth0  # Не демонизировать, выводить логи в консоль
```

### Options

| Код  | Название опции           | Описание                                       | Пример значения                 |
|------|--------------------------|------------------------------------------------|---------------------------------|
| 1*   | `subnet-mask`            | Маска подсети                                  | `255.255.255.0`                 |
| 2	   | `time-offset`	           | Смещение времени от UTC                        |                                 |
| 3*   | `routers`                | Основной шлюз (роутер)                         | `192.168.1.1`                   |
| 6*   | `domain-name-servers`    | DNS-серверы                                    | `8.8.8.8, 8.8.4.4`              |
| 7	   | `log-servers`	           | Серверы syslog                                 |                                 |
| 15*  | `domain-name`            | Доменное имя сети                              | `example.local`                 |
| 42   | `ntp-servers`            | NTP-серверы для синхронизации времени          | `192.168.1.10`                  |
| 44	  | `netbios-name-servers`	  | WINS-серверы (для NetBIOS)                     |                                 |
| 51   | `lease-time`             | Время аренды IP (секунды)                      | `86400` (1 день)                |
| 54   | `dhcp-server-identifier` | IP DHCP-сервера                                | `192.168.1.2`                   |
| 66** | `tftp-server-name`       | Адрес TFTP-сервера (PXE)                       | `192.168.1.100`                 |
| 67** | `bootfile-name`          | Имя загрузочного файла (PXE)                   | `pxelinux.0`                    |
| 119  | `domain-search`          | Домены для поиска (DNS search domain)          | `example.local, lab.local`      |
| 120	 | `sip-servers`	           | SIP-серверы для VoIP                           |                                 |
| 150  | `tftp-server-address`    | Альтернативный адрес TFTP (VoIP, камеры)       | `192.168.1.100`                 |
| 252  | `proxy-autodiscovery`    | URL для автоматической настройки прокси (WPAD) | `http://proxy.example/wpad.dat` |

## DNS
[Оглавление](../../../__00_Собес__/README.md#оглавление) => [Сеть](../../../__00_Собес__/01_Сеть/README.md#схема)

Локальный dns `/etc/hosts`
port 53 — сервер.

[dnsmasq config](./dnsmasq.md)

### Debug server
```shell
sudo dnsmasq --test --conf-file=/etc/dnsmasq.conf
sudo journalctl -u named -f # BIND (named)
sudo journalctl -u dnsmasq -f # dnsmasq

# Дамп кэша в лог
sudo kill -SIGUSR1 $(pgrep dnsmasq)
grep "cached" /var/log/dnsmasq.log
```
### Debug client

#### dig
```shell
dig [+trace, +json, +short] <сервер> <домен> [тип_записи]
```
Где:
- `<сервер>` — DNS сервер.
- `<домен>` — запрашиваемый домен (например, `example.com`).
- `[тип_записи]` — тип DNS-записи (A, MX, NS, TXT и т. д.).
- `[опции]` — дополнительные параметры.
  - +trace - Трассировка для DNS.
  - +json - Формат.
  - +short - краткий вывод.




### Записи
| Тип записи | Назначение                                                                                             | Пример                                                                                   |
|------------|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|
|            | **Основные**                                                                                           |                                                                                          |
| **A**      | Связывает домен с IPv4-адресом.                                                                        | `example.com. A 192.0.2.1`                                                               |
| **AAAA**   | Связывает домен с IPv6-адресом.                                                                        | `example.com. AAAA 2001:db8::1`                                                          |
| **CNAME**  | Создает псевдоним (перенаправление на другой домен).                                                   | `www.example.com. CNAME example.com`                                                     |
| **TXT**    | Содержит произвольный текст (SPF, DKIM, DMARC, верификации).                                           | `example.com. TXT "v=spf1 mx -all"`                                                      |
| **PTR**    | Обратная запись (IP → домен, для reverse DNS).                                                         | `1.2.0.192.in-addr.arpa. PTR example.com`                                                |
|            | **Сервисы**                                                                                            |                                                                                          |
| **MX**     | Указывает почтовые серверы для домена (приоритет + сервер).                                            | `example.com. MX 10 mail.example.com`                                                    |
| **SRV**    | Указывает серверы для сервисов (SIP, XMPP). Формат: `Приоритет Вес Порт`.                              | `_sip._tcp.example.com. SRV 10 60 5060 sip.example.com`                                  |
| **NAPTR*** | Для сложных перенаправлений (VoIP, ENUM).                                                              | `example.com. NAPTR 100 10 "S" "SIP+D2U" "" _sip._udp.example.com.`                      |
|            | **Сертификаты**                                                                                        |                                                                                          |
| **CAA**    | Разрешает выпуск SSL-сертификатов только указанным ЦС.                                                 | `example.com. CAA 0 issue "letsencrypt.org"`                                             |
|            | **Верификация**                                                                                          |                                                                                          |
| **SSHFP**  | Хеш SSH-ключей сервера. (Верификация DNS При подключении по SSH `VerifyHostKeyDNS yes ~/.ssh/config`)  | `example.com. SSHFP 2 1 123456...`                                                       |
| **TLSA**   | Привязка TLS-сертификатов через DNS (Верификация сайта через текущий DNS-сервер **DNSKEY**+**TLSA**).  | `_443._tcp.example.com. TLSA 3 1 1 ABC123...`                                            |
| **DNSKEY** | Публичный ключ для DNSSEC. (Верификация текущего DNS-сервера КЛИЕНТОМ)                                 | `example.com. DNSKEY 256 3 13 ...`                                                       |
| **DS**     | Хеш ключа DNSSEC для проверки дочерних зон. (На родительском DNS для верификации текущего DNS-сервера) | `example.com. DS 12345 8 2 ABCDEF...`                                                    |
|            | **Взаимодействие серверов**                                                                            |                                                                                          |
| **NS**     | Указывает DNS-серверы, ответственные за домен. (Обычно хостинг)                                        | `example.com. NS ns1.example.com`                                                        |
| **SOA***   | Начало зоны (управляющий сервер, тайминги обновления).                                                 | `example.com. SOA ns1.example.com. admin.example.com. 2023061001 7200 3600 1209600 3600` |






