

```shell
# Запаковка
tar -c[z/j/J]vf "/dest/source$(date '+%Y-%m-%d_%H-%M').tar[.gz/.bz2/.xz]" -C /source/ . # архивация содержимого папки [сжатие]

# Распаковка
newest=$(ls -t /source/* | head -1)
tar -x[z/j/J]vf source.tar[.gz/.bz2/.xz] -C /source/ # распаковка в папку [сжатие]
## конкретного файла
tar -x[z/j/J]vf source.tar[.gz/.bz2/.xz] dir/test.txt -C /source/
tar -x[z/j/J]vf source.tar[.gz/.bz2/.xz] --wildcards '*.jpg' -C /source/

# Добавление (нельзя добавлять в сжатые архивы)
tar -rvf source.tar newfile.txt

# Обновление (обновит только если файл новее)
tar -rvf source.tar updated.txt

# Просмотр 
tar -t[z/j/J]vf archive.tar[.gz/.bz2/.xz]


```