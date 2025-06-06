# Control Groups (cgroups)
Это механизм ядра Linux для ограничения, учета и изоляции ресурсов (CPU, память, I/O и т. д.) для групп процессов.
* Подгруппы не могут превышать лимиты родительской группы.
## Просмотр
* Пример иерархии:
```
/sys/fs/cgroup/
└── my_app/                      # Основная группа
    ├── cgroup.procs             # Процессы в этой группе
    ├── cgroup.controllers       # Доступные контроллеры (cpu, memory, io)
    ├── cgroup.subtree_control   # Какие контроллеры делегированы подгруппам
    ├── cpu.max                  # Лимит CPU (например, "50000 100000" = 50%)
    ├── cpu.weight               # Вес CPU (1-10000, по умолчанию 100)
    ├── cpu.pressure             # Статистика нагрузки на CPU
    ├── memory.current           # Текущее использование памяти
    ├── memory.min               # Минимальная гарантированная память
    ├── memory.low               # "Мягкий" минимальный лимит
    ├── memory.high              # Мягкий верхний лимит (ядро старается не превышать)
    ├── memory.max               # Жесткий лимит (OOM при превышении)
    ├── memory.oom.group         # Убивать всю группу при OOM (1/0)
    ├── memory.swap.current      # Текущее использование swap
    ├── memory.swap.max          # Лимит swap (например, "1G")
    ├── io.max                   # Ограничение I/O (например, "8:0 rbps=1048576")
    ├── io.pressure              # Статистика нагрузки на I/O
    ├── pids.current             # Текущее количество процессов
    ├── pids.max                 # Максимальное количество процессов
    └── subgroup/                # Подгруппа
        ├── cgroup.procs         # Процессы в подгруппе
        ├── cpu.weight           # Вес CPU подгруппы (например, 50)
        ├── memory.max           # Лимит памяти подгруппы (например, "500M")
        └── io.max               # Ограничение I/O подгруппы
```
## Текущие значения
```shell
systemd-cgtop

# Память
cat /sys/fs/cgroup/my_app/memory.current
# CPU-нагрузка
cat /sys/fs/cgroup/my_app/cpu.pressure
# I/O-статистика
cat /sys/fs/cgroup/my_app/io.pressure
```
## Управление
```shell
# Создаем основную группу
mkdir my_app
# Добавляем процесс (PID 1234) в основную группу
echo 1234 > /sys/fs/cgroup/my_app/cgroup.procs
# Ограничение CPU: максимум 50%
echo "50000 100000" > /sys/fs/cgroup/my_app/cpu.max
# Жесткий лимит памяти: 1 ГБ
echo "1G" > /sys/fs/cgroup/my_app/memory.max
# Ограничение I/O: 1 МБ/с на чтение для /dev/sda (8:0)
echo "8:0 rbps=1048576" > /sys/fs/cgroup/my_app/io.max

# Удаляем основную группу (должна быть пустой)
rmdir /sys/fs/cgroup/my_app
```








