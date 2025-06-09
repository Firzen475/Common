# seccomp (secure computing mode)
Это механизм ядра Linux, позволяющий ограничивать системные вызовы (syscalls), доступные процессу. Это повышает безопасность, минимизируя поверхность атаки (например, в контейнерах или изолированных сервисах).

* По сути перехватывает системный вызов и выполняет одно из 3-x действий:
  * `SCMP_ACT_KILL` — убить процесс. 
  * `SCMP_ACT_ERRNO` — вернуть ошибку (без убийства).
  * `SCMP_ACT_LOG` — только логировать нарушение.
  * `SCMP_ACT_ALLOW` — разрешить вызов.

## Проверка 
```shell
# Проверка текущих ограничений:
docker inspect <CONTAINER_ID> | grep -i seccomp
```

## Пример Seccomp-профиль
### Запрет fork
```json
{
  "defaultAction": "SCMP_ACT_ALLOW",
  "syscalls": [
    {
      "names": ["fork", "clone", "vfork"],
      "action": "SCMP_ACT_KILL"
    }
  ]
}
```

### Только чтение файла
```json
{
  "defaultAction": "SCMP_ACT_ERRNO",  // Запретить все вызовы по умолчанию
  "syscalls": [
    {
      "names": ["read", "write"],     // Разрешить read/write
      "action": "SCMP_ACT_ALLOW"
    },
    {
      "names": ["exit", "exit_group"], // Обязательно для корректного завершения
      "action": "SCMP_ACT_ALLOW"
    },
    {
      "names": ["fstat", "mmap", "mprotect", "munmap", "brk"], // Минимальные для работы libc
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
```

## Подключение профиля

```shell
docker run --security-opt seccomp=no-fork-profile.json my_image
```

```yaml
version: '3.8'
services:
  restricted_app:
    image: alpine
    command: tail -f /dev/null  # Просто чтобы контейнер не завершался
    security_opt:
      - seccomp:./only-read-write.json  # Путь к файлу профиля

```

