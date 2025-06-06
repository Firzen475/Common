# systemd
* Система инициализации и управления процессами.
* target как зависимость для поздних процессов, гарантирующая загрузку ранних.
  * `[файловая система] => [sysinit.target] => [basic.target] => [default.target] => [multi-user] => [my_service]`
* Основные target (`systemctl list-dependencies`):
  * initrd.target - юниты initramfs.
  * sysinit.target - базовая инициализация (fs,net)
    * basic.target - минимальная готовая система
      * multi-user.target - пользовательские демоны
        * default.target - главная точка входа.
* Основные типы (`systemctl show [name.type]`):
  * .target - узел загружен когда загружены все его зависимости.
  * .service - демоны.
  * .timer - задачи по расписанию.
  * .socket - отложенный запуск при обращении к сокету.
  * .path - отложенный запуск при изменении файлов в директории.
  * .mount\.automount - Монтирование (по запросу).
  * .swap - Управление swap-разделами.
  * .slice - Группировка процессов для cgroup. 
* Основные конфиги юнитов (`systemctl cat [name.type]`):
  * .service
    * [Unit] - общие метаданные и зависимости
      * Description=
      * Documentation=
      * Requires= - Жёсткие зависимости (если зависимый юнит падает, текущий тоже остановится)
      * Wants= - Мягкие зависимости (не блокирует запуск, если зависимость недоступна)
      * After= - /Before= Порядок запуска относительно других **юнитов**
      * Conflicts= - Запрещает совместный запуск с указанными юнитами
      * ConditionPathExists= - Условие запуска (проверка существования файла)
    * [Service] - параметры управления процессом
      * Type= - Тип службы
        * simple - Процесс остаётся в foreground (systemd следит за ним напрямую)
        * forking - Демон форкается (systemd ждёт, пока родительский процесс завершится)
        * oneshot	Служба запускается один раз и завершается (для скриптов)
        * notify	Служба отправляет сигнал готовности через sd_notify()
      * ExecStart\ExecStop\ExecReload - команды
      * Restart - Политика перезапуска
        * no
        * on-success
        * on-failure
        * always
      * RestartSec= - Задержка перед перезапуском (по умолчанию 100ms)
      * User=/Group= - От имени какого пользователя/группы запускать
      * WorkingDirectory= - Рабочая директория
      * Environment\EnvironmentFile - Переменные окружения.
      * StandardOutput\StandardError - Куда перенаправлять stdout\stderr
    * [Install] - правила для systemctl enable
      * WantedBy\RequiredBy - В какой target добавить службу при systemctl enable
      * Alias= - Дополнительные имена для активации

### Основные команды управления службами systemd

| Команда                                     | Описание                                       |
|---------------------------------------------|------------------------------------------------|
| `systemctl list-units --type=service --all` | Список всех сервисов                           |
| Сервисы                                     |                                                |
| `systemctl daemon-reload`                   | **Изменился systemd или добавлен новый юнит.** |
| `systemctl start <service>`                 | Запуск службы                                  |
| `systemctl stop <service>`                  | Остановка службы                               | 
| `systemctl restart <service>`               | Перезапуск службы                              | 
| `systemctl reload <service>`                | Перезагрузка конфигурации                      | 
| `systemctl enable <service>`                | Включение автозапуска                          | 
| `systemctl disable <service>`               | Отключение автозапуска                         | 
| `systemctl status <service>`                | Проверка состояния                             |
| Система                                     |                                                |
| `systemctl reboot`                          | Перезагрузка системы                           | 
| `systemctl poweroff`                        | Выключение системы                             | 
| `systemctl suspend`                         | Режим сна                                      | 
| `systemctl hibernate`                       | Гибернация                                     | 
| `systemctl rescue`                          | Аварийный режим                                | 
| Логи                                        |                                                |
| `systemd-analyze`                           | Анализ времени загрузки                        | 
| `systemd-analyze blame`                     | Анализ медленных служб                         | 
| `journalctl -u <service>`                   | Логи службы                                    | 
| `journalctl -f`                             | Режим слежения                                 | 
| `journalctl -b`                             | Логи текущей загрузки                          | 
| Таймер (как cron)                           |                                                |
| `systemctl list-timers`                     | Список таймеров                                | 
| `systemctl start <timer>`                   | Запуск таймера                                 | 
| `systemctl enable <timer>`                  | Включение таймера                              | 
| top                                         |                                                |
| `systemd-cgtop`                             | Мониторинг ресурсов (аналог top для cgroups)   |
# Создание пользовательского сервиса в systemd

## 1. Создание файла сервиса

Расположение файлов:
- Системные сервисы: `/etc/systemd/system/`
- Пользовательские сервисы: `~/.config/systemd/user/`

Пример (`/etc/systemd/system/my-service.service`):
```ini
[Unit]
Description=Node.js Web Application
After=network.target

[Service]
Type=simple
User=nodeuser
WorkingDirectory=/var/www/myapp
ExecStart=/usr/bin/node /var/www/myapp/server.js
Restart=always
Environment=NODE_ENV=production
MemoryMax=500M
CPUQuota=75%

[Install]
WantedBy=multi-user.target
```

## 2. Основные параметры сервиса
#### Секция [Unit]:
* `Description` - описание сервиса
* `After` - указывает, какие сервисы должны быть запущены до этого
* `Requires` - жесткие зависимости
* `Wants` - мягкие зависимости
#### Секция [Service]:
* `Type` - тип сервиса (simple, forking, oneshot, notify)
* `ExecStart` - команда для запуска
* `ExecStop` - команда для остановки (опционально)
* `Restart` - политика перезапуска (no, on-success, on-failure, always)
* `User/Group` - от чьего имени запускать
* `MemoryMax=` - Лимит оперативной памяти
* `CPUQuota=` - Ограничение CPU (например, `CPUQuota=50%`)
* `IOWeight=` - Приоритет ввода-вывода 
#### Секция [Install]:
* `WantedBy` - указывает, когда сервис должен запускаться















