# Transparent Huge Pages (THP)
* Дефрагментация RAM.
* Объединяет страницы в блоки 2МБ или 1ГБ
* Работает в фоновом режиме.

## Просмотр
```shell
# Включено объединение только помеченных страниц
cat /sys/kernel/mm/transparent_hugepage/enabled
always [madvise] never

# Промежутки между сканированием
cat /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs

```

## Изменение
#### Временно
```shell
# Изменение режима THP (до следующей перезагрузки)
echo "madvise" | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
# Отключение THP полностью (рекомендуется для некоторых СУБД)
echo "never" | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo "never" | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
# Частота сканирования
echo 1000 > /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs
```
#### Постоянно
```shell
# Добавить в /etc/default/grub
GRUB_CMDLINE_LINUX="transparent_hugepage=never"
update-grub 
```
