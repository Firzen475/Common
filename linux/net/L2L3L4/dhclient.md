**DHCP (Dynamic Host Configuration Protocol)** — это сетевой протокол, который автоматически назначает IP-адреса и другие параметры сети устройствам, подключающимся к сети.

## Проверка аренды DHCP (файлы аренды)
```shell
cat /var/lib/dhcp/dhclient.leases  # Ubuntu/Debian
cat /var/lib/NetworkManager/dhclient-*.lease  # Если используется NetworkManager
```
* Выданный IP (`fixed-address`)
* Время аренды (`lease`)
* DNS-серверы (`domain-name-servers`)
* Шлюз (`routers`)
## 

## Управление 
#### Освобождение и запрос нового IP
```shell
sudo dhclient -r eth0  # Освобождаем текущий lease (release)
sudo dhclient -v eth0  # Запрашиваем новый IP (verbose-режим)
```
#### Запуск DHCP в debug-режиме
```shell
sudo dhclient -d eth0  # Не демонизировать, выводить логи в консоль
```
#### Мониторинг DHCP-трафика (tcpdump)
```shell
sudo tcpdump -i eth0 port 67 or port 68 -vv
```
* `DHCP Discover` – клиент ищет сервер.
* `DHCP Offer` – сервер предлагает IP.
* `DHCP Request` – клиент запрашивает адрес.
* `DHCP ACK/NACK` – подтверждение или отказ.
