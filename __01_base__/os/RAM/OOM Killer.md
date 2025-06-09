# Механизм OOM Killer (Out-of-Memory Killer)
* Механизм освобождения оперативной памяти.
* Можно посмотреть через htop -> oom score

## Критерии выбора
* Важность процесса
* Время работы
* Объём потребляемой памяти.
* Формула: `oom_score = (потребление памяти в %) × oom_score_adj`

## Управление
* /proc/PID/oom_score_adj (-1000 неубиваемый);
* cgroup
  ```shell
  cgcreate -g memory:my_group
  echo "1G" > /sys/fs/cgroup/memory/my_group/memory.limit_in_bytes
  echo <PID> > /sys/fs/cgroup/memory/my_group/cgroup.procs
  ```
* Сервис
  ```editorconfig
  [Service]
  OOMScoreAdjust=-1000
  ```

## Дополнительно
```shell
# Текущий рейтинг
cat /proc/PID/oom_score 
# Полное отключение
echo 1 > /proc/sys/vm/panic_on_oom
# Удаление всей cgroup процессов 
echo 1 > /sys/fs/cgroup/memory/mygroup/memory.oom.group  
```