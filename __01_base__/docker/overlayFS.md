# OverlayFS
Это файловая система, объединяющая несколько директорий в единое виртуальное дерево. Она широко используется в Docker, LiveCD, контейнерах и других сценариях, где требуется наложение слоёв файлов.

* Состоит из 3-х слоёв
  * Lower directory - read only директория.
  * Work Directory - tmp для промежуточных операций (атомарных).
  * Upper directory - rw директория. Новые, модифицированные и удалённые файлы.
* Merged Directory = Lower + Upper
* Механизм работы при изменении (COW):
  * lower -> Work -> Upper
* Механизм работы при удалении файла(был в Lower):
  * в Upper создаётся маркер удаления - файл .wh.<file>
* Механизм работы при удалении файла(только Upper):
  * Просто удаляется
* Механизм работы при удалении директории:
  ```shell
  /changes/         (upperdir)
  └── dir/
      └── removed_dir/
          └── .wh..wh..opaque  # <-- Маркер удаления
  ```

## Мониторинг
```shell
# для контейнера
docker inspect <container-id> | grep -A 5 "GraphDriver"

# для хоста
mount | grep overlay
```

## Пример монтирования
```shell
mount -t overlay overlay -o lowerdir=/base,upperdir=/changes,workdir=/work /merged
```







