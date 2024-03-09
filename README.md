# KMS
  Общее
  
`echo -e "${VAR1}\n${VAR1}" > /test.txt #Вставка переменных и переноса строк в вывод`


  docker

- Установка [docker](https://docs.docker.com/engine/install/ubuntu/)

- Установка [docker-compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04-ru)

`docker image rm $(docker image  ls -aq) -f #Удалить все image`

`docker container prune #Удалить все контейнеры`

`docker exec -it <container name> /bin/bash`

`docker-compose down && docker-compose build --force-rm && docker-compose up -d #Сборка и запуск контейнеров`

`docker image ls #Список образов`

`docker container ls #Список контейнеров`

  github

`git clone --branch master --single-branch https://github.com/user/repo.git /TVAPI #Загрузка проекта в конкретную папку`

`git add . #Добавление всех файлов в кэш (кроме игнорируемых)`

`git commit -m "test" #commit добавленного кода`

`git status #Список изменений в кэше`

`git push origin main #Отправка commit на git`

`git rm -rf --cached . #Удаление всего commit из кеша проекта`

[Инструкция по SSH подключению](https://habr.com/ru/articles/755036/)  

  mysql  

`mysqldump -u root test > /backup_file.sql #Создание полного бекапа базы test`

`mysql -u root test < backup_file.sql #Восстановление базы из бекапа`

`mysql -u $user -D $dbname -p $password -e "select Col1 from Table1 where Condition;"`
  
- Загрузка этого проекта

`sudo apt install git`

`git clone --branch master --single-branch https://github.com/Firzen475/KMS.git`

`cd ./KMS`

- Настройка файла переменных
 
`nano ./.env`

- Настройка kerberos

Заменить EXAMPLE.LOCAL и DC1 на имя домена и имя контроллера домена соответственно

`nano ./ansible_kms/krb5.conf`

- настройки ansible

В смонтированной папке /root должен быть файл run.sh который запускается по расписанию. 

Пример:

`cat ./root/run.sh`

Файл inventory с настройками доступа и список WS. Нужно заменить пользователя и пароль локального администратора (Пояснение в разделе "Доступ к WS").

Также нужно указать ip и порт сервера, на котором будут развёрнуты контейнеры docker.

И наконец усановить ключи KMS. Они гуглятся по последним 5-ти симолам. 

Пример:

`cat ./root/inventory`

Файл install_lic.yml - ansible playbook

Пример:

`cat ./root/install_lic.yml`

- Доступ к WS

Для успешного выполнения скриптов нужно выполнить 3 условия

 - Пользователь в файле inventory должен быть локальным администратором [link](https://winitpro.ru/index.php/2019/11/27/gpo-dobavit-v-gruppu-lok-admins/)

 - На всех WS установлен PowerShell 5.0+

 - На всех WS включен WinRM [link](https://winitpro.ru/index.php/2012/01/31/kak-aktivirovat-windows-remote-management-s-pomoshhyu-gruppovoj-politiki/)


  II. Сборка 
- Установка [docker](https://docs.docker.com/engine/install/)

- Установка [docker-compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04-ru)

- Полезные команды

`docker image rm $(docker image  ls -aq) -f #Удалить все image`

`docker exec -it <container name> /bin/bash`

`docker container prune #Удалить все контейнеры`

`docker-compose down && docker-compose build --force-rm && docker-compose up -d #Сборка и запуск контейнеров`

`docker image ls #Список образов`

`docker container ls #Список контейнеров`

  III. Проверка

- Проверка статуса контейнеров

`docker container ls` 

- Проверка порта kms

`netstat -ntulp`

- Проверка логов ansible

`tail -f [PATH_ROOT]/install_lic.log`

