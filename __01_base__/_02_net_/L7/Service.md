
## DHCP

[Оглавление](../../../__00_Собес__/README.md#оглавление) => [Сеть](../../../__00_Собес__/01_Сеть/README.md#схема)

port 67 — сервер.  
port 68 — клиент.

### Debug

```shell
# Проверка конфигурации
sudo dhcpd -t -cf /etc/dhcp/dhcpd.conf
# Запуск в режиме debug (-f — работа в foreground)
sudo dhcpd -d -f -cf /etc/dhcp/dhcpd.conf eth0
# Анализ трафика
sudo tcpdump -i eth0 -n port 67 or port 68 -vv
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