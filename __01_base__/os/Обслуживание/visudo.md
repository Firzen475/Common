# visudo
* Утилита управления правами пользователя
* Открывает редактор
* Настройки хранятся в /etc/sudoers


### Примеры

```shell
# пользователь хост=(пользователь:группа) команды
# %группа хост=(пользователь:группа) команды
user1 ALL=(ALL:ALL) ALL
%admin ALL=(ALL) ALL

user2 ALL=(ALL) NOPASSWD: ALL  # user2 может делать sudo без пароля
%wheel ALL=(ALL) NOPASSWD: /usr/bin/apt  # группа wheel может запускать apt без пароля

user3 ALL=(ALL) PASSWD: /usr/bin/apt, NOPASSWD: /usr/bin/systemctl
# для apt нужен пароль, для systemctl — нет
```
