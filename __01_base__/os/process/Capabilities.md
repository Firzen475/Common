# Capabilities
Это механизм разграничения привилегий, который позволяет предоставлять процессам только необходимые права вместо полномочий.

* Если процесс запущен от имени пользователя, но не должен использовать часть привилегий, их можно отключить.
* Изменить Capabilities запущенного процесса нельзя

# Основные инструменты и параметры
### setcap\getcap 
Изменяет атрибуты Capabilities файл навсегда
### capsh
Запускает процесс с заданными Capabilities
### Параметры
* `CAP_NET_ADMIN` — управление сетевыми настройками.
* `CAP_SYS_ADMIN` — широкие административные права (аналог многих операций root).
* `CAP_DAC_OVERRIDE` — игнорирование прав доступа к файлам.
* `CAP_KILL` — отправка сигналов любым процессам.
* `CAP_SYS_TIME` — изменение системного времени.
```shell
# Полный список
man capabilities
```
# Просмотр
```shell
# Получение(декодирование из HEX 000001ffffffffff) списка текущих 
capsh --decode=$(cat /proc/<PID>/status | grep CapEff | awk '{print $2}')
# Текущие атрибуты бинарника
getcap [бинарник]
```
# Изменение
### Навсегда
```shell
# Дать nginx право биндить порты <1024 без root:
sudo setcap CAP_NET_BIND_SERVICE+ep /usr/sbin/nginx
# Проверить capabilities файла:
getcap /usr/sbin/nginx
# Output: /usr/sbin/nginx = cap_net_bind_service+ep
# Удалить capabilities:
sudo setcap -r /usr/sbin/nginx
```
### Временно
```shell
# Запустить /bin/bash с CAP_NET_ADMIN, но без других прав:
sudo capsh --caps="cap_net_admin+eip" --keep=1 --user=nobody --addamb=cap_net_admin -- -c "/bin/bash"
# Проверить capabilities текущего shell'а:
capsh --print
# Output: Current: = cap_net_admin+eip
```

# Docker
#### shell
```shell
docker run --rm -it \
  --cap-add=NET_RAW \
  --cap-add=NET_ADMIN \
  nicolaka/netshoot \
  tcpdump -i eth0

```
#### docker-compose
```yaml
version: '3.8'

services:
  my_service:
    image: alpine:latest
    cap_add:
      - CAP_NET_ADMIN       # Добавить capability
      - CAP_SYS_TIME
    cap_drop:
      - CAP_CHOWN           # Удалить capability
      - CAP_KILL
```

