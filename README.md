# KMS
  ## Общее
  ### Порядок загрузки ОС
BIOS/UEFI  
POST  
MBR/GPT/PXE  
SYSLINUX/GRUB  
kernel  
init/systemd  

  ### omm killer
Очистка оперативной памяти при нехватке. 
  ## Сеть
  ### Протоколы
ICMP (ping) - протокол ошибок в сети без подтверждения получения.
  ### Модель OSI
| nn | Уровень                      | Тип данных | Функции                                   | Пример                    |
|----|:-----------------------------|:-----------|-------------------------------------------|---------------------------|
| 7  | Прикладной (application)     | Данные     | Службы                                    | HTTP, FTP, SSH, WebSocket | 
| 6  | Представления (presentation) | Данные     | Шифрование                                | SSL, gzip                 |
| 5  | Сеансовый (session)          | Данные     | Управление сеансом                        | PAP, L2TP                 |
| 4  | Транспортный (transport)     | Сегменты   | Прямая связь                              | TCP, UDP                  |
| 3  | Сетевой (network)            | Пакеты     | Маршрутизация и логическая адресация (IP) | IPv4, IPv6, ICMP          |
| 2  | Канальный (data link)        | Кадры      | Физическая адресация (MAC)                | 802.22, Ethernet          |
| 1  | Физический (physical)        | Биты       | Сигнал                                    | RG45                      |
  ### Ошибки http

| код | Описание                                                                                                                                                                                                                                                                       |
|:---:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1XX | информационные коды. Они отвечают за процесс передачи данных. Это временные коды, они информируют о том, что запрос принят и обработка будет продолжаться.                                                                                                                     |
| 2XX | успешная обработка. Запрос был получен и успешно обработан сервером.                                                                                                                                                                                                           |
| 3XX | перенаправление (редирект). Эти ответы сервера гласят, что нужно предпринять дальнейшие действия для выполнения запроса. Например, сделать запрос по другому адресу.                                                                                                           |
| 4XX | ошибка пользователя. Это значит, что запрос не может быть выполнен по его вине.                                                                                                                                                                                                |
| 5XX | ошибка сервера. Эти коды возникают из-за ошибок на стороне сервера. В данном случае пользователь всё сделал правильно, но сервер не может выполнить запрос. Для кодов этого класса сервер обязательно показывает сообщение, что не может обработать запрос и по какой причине. |

  ### Файловый дескриптор

  ## Отладка системы
  ### Ядро и процессы
```shell
# свободная оперативка
free
# strace список системных вызовов (ls это команда)
strace -c ls
# iostat загрузка диска
iostat -xtc
# ps - информация о процессах
ps aux # Все процессы с pid и пользователями
ps auxf # Все процессы деревом
# kill - передает сигналы процессу
kill -9 pid # SIGKILL
kill -15 pid # SIGTERM
systemctl status # Просмотр состояния сервисов.

```
  ### Сеть
```shell
# мониторинг потерянных пакетов
ifconfig 
# ss (netstat)
## показать порты | tcp | udp | all | process
ss -ntuap
# watch просмотр в реальном времени.
watch ss -ntuap
# nc сканер портов
## без отправки данных | verbose | UDP (без ключа tcp)
nc -z -v -u 192.168.2.1 1-80 2>&1>/dev/null | grep succeeded
# telnet старый протокол соединения (проверка портов)
## DNS имя или IP | PORT
telnet host 22
# arp список известных MAC
## -n без dns имён
arp -n
# resolvectl flush-caches сброс кэша DNS
resolvectl flush-caches
# tcpdump мониторинг трафика (wireshark)
## весь трафик | с хоста 
tcpdump host 192.168.2.1
## не преобразовывать в dns-имя | интерфейс | исходящий трафик с ip | исключить 22 порт
tcpdump -nn -i eth0 src 192.168.2.1 and not port 22
## 10 пакетов | интерфейс | ip:port | содержимое пакета | порт
tcpdump -c10 -i eth0 -nn -A port 22
## verbose | не преобразовывать в dns-имя | интерфейс | протокол
tcpdump -vvv -ni eth0 vrrp
```

  ### WEB
```shell
# curl проверка удаленного web сервера
# скачать файл
## verbose | визуальная загрузка | возобновить при разрыве | игнор сертификатов | редирект | сохранение в текущую директорию 
curl -vvv -# -C 999 -k -L -O https://192.168.2.1/pxe/user-data
# сохранить страницу в файл
curl -v -k -L -o ./test_curl.txt  https://google.com



```

  ## bash

```
Comparisons:  
-eq   equal to  
-ne   not equal to  
-lt   less than  
-le   less than or equal to  
-gt   greater than  
-ge   greater than or equal to  

File Operations:
-s    file exists and is not empty
-f    file exists and is not a directory
-d    directory exists
-x    file is executable
-w    file is writable
-r    file is readable
```

```shell
# !/bin/sh интерпретатор по умолчанию, или указать путь к нужному
# /usr/local/bin помещение в эту директорию делает файл доступным из командной строки для всех
# $# количество аргументов; $0 ссылка на файл; $1..$n аргументы командной строки
# $*, $@ параметры командной строки; $? хранит код завершения ПОСЛЕДНЕЙ команды; 
# $$ PID текущей консоли. $! PID последнего фонового процесса.
# : пустая команда, возвращает true. Может использоваться как заглушка. 
# (a=123;echo $a) группа изолированных команд со своими переменными (скрипт в скрипте)
# (()) оператор вычисления; [] тест, элемент массива, диапазон символов в regex; [[]] расширенный тест

# &> 1> 2> перенаправление вывод. & оба, 1 stdout, 2 stderr
./test.sh 2>&1>/dev/null #выводит только ошибки

help test || man bash #все операторы сравнения для if 

read var1 && echo "$var1" #ожидание ввода
#
while read line #построчное чтение из файла.
do
  echo $line
done < input.txt
#
echo "text" >> file.txt && echo "text" > file.txt #добавить строку && переписать файл
#
a=5; true | { true && a=10; echo $a; } #Каждая команда конвейера выполняется в отдельной оболочке.
10
echo $a
5

if [[ "$aaa" == "bbb" ]]; then
   echo "bbb"
elif [[ "$aaa" == "ccc" ]]; then
   echo "ccc"
else
   echo "something else"
fi
```

  ## Утилиты
  ### man
ГЛАВНАЯ КОМАНДА! МАНУАЛ!
  ### Информация о системе 
`cpuinfo/lscpu` процессор
`dmidecode --type memory` оперативка
`sensors/ipmicfg -pminfo` датчики
`lspci | grep net` pci устройства (сетевые адаптеры)
`iostat -xtc` загрузка диска
`top`
`ps`
`/proc/[PID]` информация о процессах
`df`
`free`
`mkfs -t ext4 /dev/sdb1`
  ### stat file
Информация о файле.
  ### strace
```shell
strace -c ls #Список системных вызовов при выполнении команды ls.
apt install manpages-dev manpages-posix-dev && man 2 <syscall> #Мануал по системным вызовам
```
  ### top
| Параметр                      | Описание                                                                                                                                                                                                                                                 |
|:------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| us (user)                     | Использование процессора пользовательским процессами                                                                                                                                                                                                     |
| sy (system)                   | Использование процессора системным процессами                                                                                                                                                                                                            |
| ni (nice)                     | Использование процессора процессами с измененным приоритетом с помощью команды nice                                                                                                                                                                      |
| id (idle)                     | Простой процессора. Можно сказать, что это свободные ресурсы                                                                                                                                                                                             |
| wa (IO-wait)                  | Время на простой, то есть ожидания переферийных устройств ввода вывода                                                                                                                                                                                   |
| hi (hardware interrupts)      | Показывает сколько процессорного времени было потрачено на обслуживание аппаратного прерывания. (Аппаратные прерывания генерируются аппаратными устройствами. Сетевыми картами, клавиуатурами, датчиками, когда им нужно о чем-то просигнализировать цп. |
| si (software interrupts)      | Показывает сколько процессорного времени было потрачено на обслуживание софтверного прерывания. Фрагмент кода, вызывающий процедуру прерывания                                                                                                           |
| st (stolen by the hypervisor) | Показывает сколько процессорного времени было «украдено» гипервизором. Для запуска виртуальной машины, или для иных нужд                                                                                                                                 |
Статусы процессов:  

| Статус    | Описание                                                                                                                                                                                                                                                                                                                    |
|:----------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| R         | процесс исполняется, или ждет своей очереди на исполнение                                                                                                                                                                                                                                                                   |
| S         | прерываемый сон - процесс ожидает определенного события или сигнала.Нужен, когда процесс нельзя завершить (чтение из файла), ядро переводит на ожидание. Ожидать данные от сетевого соединения                                                                                                                              |
| D         | непрерывное ожидание, сон. Ждем сигнал от аппаратной части.                                                                                                                                                                                                                                                                 |
| T         | остановка процесса, посылаем сигнал STOP. В этом состоянии процессу запрещено выполняться. Чтобы вернуть к жизни нужно послать CONT. При завершении процесса он становится зомби                                                                                                                                            |
| Z(zombie) | зомби это процесс, который закончил выполнение, но не передал родительскому процессу свой код возвращения. Процесс в этом состоянии игнорирует kill. Родитель получает код, и освобождает структуру ядра, которое относится к процессу. Бывает еще когда родительский умирает раньше дочернего. Процесс становится сиротой. |

  ### kill
| Сигнал                                        | Код | Важность | Описание                                                                                                         |
|:----------------------------------------------|:---:|:--------:|:-----------------------------------------------------------------------------------------------------------------|
| SIGHUP                                        |  1  |    2     | Потеря соединения с управляющим терминалом (прерывание связанных программ); <br/> Для демонов переинициализация; |
| SIGINT                                        |  2  |    1     | Прерывание из терминала (Ctrl + C).                                                                              |
| SIGQUIT                                       |     |    3     | Остановка с сохранением дампа.                                                                                   |
| SIGILL                                        |  4  |    3     | Недопустимая инструкция.                                                                                         |
| SIGTRAP                                       |  5  |    2     | Остановка выполнения для трассировки кода.                                                                       |
| SIGABRT                                       |  6  |    1     | Принудительное прерывание работы с безопасным закрытием потоков.                                                 |
| SIGBUS                                        |     |    3     | Ошибка шины, при обращении к физической памяти.                                                                  |
| SIGFPE                                        |  8  |    3     | Ошибка математического вычисления.                                                                               |
| SIGKILL                                       |  9  |    1     | Безусловное завершение процесса. (кроме зомби и init).                                                           |
| SIGUSR1<br/>SIGUSR2<br/>SIGRTMIN<br/>SIGRTMAX |     |    3     | Пользовательские сигналы для взаимодействия (например потоков).                                                  |
| SIGSEGV                                       | 11  |    3     | Cтраница памяти потеряна и ОС посылает сигнал процессу, останавливая выполнение.                                 |
| SIGPIPE                                       | 13  |    3     | Потеряно прямое соединение между программами.                                                                    |
| SIGALRM<br/>SIGVTALRM<br/>SIGPROF             | 14  |    3     | Сообщения об истечении времени (alarm()).                                                                        |
| SIGTERM                                       | 15  |    1     | Запрос на завершение программы (kill посылает по умолчанию).                                                     |
| SIGCHLD                                       |     |    1     | Изменение статуса дочернего процесса (завершён, приостановлен или возобновлен).                                  |
| SIGCONT                                       |     |    2     | Посылается для возобновления процесса после SIGTSTP, SIGTTIN, SIGTTOU.                                           |
| SIGSTOP                                       |     |    2     | Безусловная пауза процесса.                                                                                      |
| SIGTSTP                                       |     |    2     | Пауза из терминала (Ctrl-Z).                                                                                     |
| SIGTTIN<br/>SIGTTOU                           |     |    3     | Терминал отправляет при попытке ввода/вывода.                                                                    |
| SIGURG                                        |     |    3     | Сигнал о срочных данных на сокете.                                                                               |
| SIGXCPU                                       |     |    3     | Превышение процессорного времени.                                                                                |
| SIGXFSZ                                       |     |    3     | Превышение размера открытого файла.                                                                              |
| SIGWINCH                                      |     |    3     | Изменение размеров экрана.                                                                                       |
| SIGIO                                         |     |    3     | Обычные данные на сокете.                                                                                        |
| SIGPWR                                        |     |    2     | Ожидание выключения питание или переход на ИБП.                                                                  |
| SIGSYS                                        |     |    2     | Неправильный аргумент в системном вызове.                                                                        |

`kill -KILL $$`

  ### chmod
`+x` #выполнение любым пользователем  
`+r` #чтение любым пользователем  
`+w` #запись любым пользователем  
`u+rwx` #права только владельцу  

  ### ps 
Список процессов.  
`-A/e(-a)` #все процессы(все кроме фоновых).  
`-f/F` #полная информация.  
`-H --forest` #вывод в виде дерева.  
`--format="uid uname cmd"` #пример формата вывода таблицы.  
`--sort uid` #сортировка.  
`-N` #все кроме.  
`-C` #поиск по полному имени.  
`--ppid` #поиск по pid родителя.  
  ### pwd
Текущая директория  
  ### ls

  ### touch
Изменяет время доступа к файлу и может создать файл.
  ### history
История команд.
  ### sed
```shell

if [ "" $string1 == $string2 "" ]

# изменять файл | s - тип разделителя | 1,2,g - первое, второе, все вхождения
sed -i "s:text1:text2:g" /test.txt

sed -n "s:text1:text2:p" /test.txt # тест замены без внесения изменений

```
  ### jq
```json
{
  "control": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string"
      ]
    ],
    "value": [
      "control02"
    ]
  },
  "control_main": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string"
      ]
    ],
    "value": [
      "control01",
      "control03",
      "control04"
    ]
  }
}
```
```shell
# .[] - обход элементов первого уровня; del(.[]|."sensitive") - удаление элемента sensitive второго уровня;
# walk(if type == "object" then - обход всех элементов {key:value} ; 
# with_entries( if .key == "value" then - получает доступ к key и value, далее проверяет;
# | .value = (.value | map({(.) : null} )  | add) - формирует из списка в value объект {value[n]:null}, 
# add добавляет в виртуальный объект ; потом всё присваивается к .value
jq -r 'del(.[]|."sensitive") | del(.[]|."type") | walk(if type == "object" then with_entries( if .key == "value" then .key = "hosts" | .value = (.value | map({(.) : null} )  | add) else . end ) else . end) '
```
```json
{
  "control": {
    "hosts": {
      "control02": null
    }
  },
  "control_main": {
    "hosts": {
      "control01": null,
      "control03": null,
      "control04": null
    }
  }
}
``` 
  ### awk
```shell
# Вывод текста от и до
awk '/from/,/to/ {print }'

```


`echo -e "${VAR1}\n${VAR1}" > /test.txt #Вставка переменных и переноса строк в вывод`

  ## ansible
Роли позволяют создавать повторяемые шаблоны с подстановкой переменных. Структура:  
/roles/[Название роли]/[Директория таблицы]/main.yaml  

| директория | Описание                                                    |
|:-----------|-------------------------------------------------------------|
| files      | Файлы для копирования.                                      |
| handlers   | Действия после выполнения.                                  |
| meta       | Описание ролей, которые должны быть выполнены до этой роли. |
| templates  | Шаблоны файлов с переменными                                |
| tasks      | Сами задачи.                                                |
| vars       | Переменные (лучше хранить отдельно)                         |
Пример:  
/tasks/main.yaml
```yaml
---
- name: Update atp
  atp: update_cache=yes
- name: Install Apache
  atp: name=apache2 state=latest
- name: Create custom document root
  file: path={{ dock_root }} state=directory owner=www-data group=www-data
- name: Set up HTML file
  copy: src=index.html dest={{ dock_root }}/index.html owner=www-data group=www-data
- name: Set up Apache virtual host file
  template: src=vhost.tpl dest=/etc/apache2/site-available/000-default.conf
  notify: restart apache
```
/handlers/main.yaml
```yaml
---
- name: restart apache
  service: name=apache2 state=restart
```
/files/index.html
```html
<html lang="ru">
<head><title>Configuration Management Hands On</title></head>
<h1>This server was provisioned using <strong>Ansible</strong></h1>
</html>
```
/templates/vhost.tpl
```html
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  DocumentRoot {{ doc_root }}
  
  <Directory {{ docroot }}>
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
```
/playbook.yaml
```yaml
---
- hosts: all
  become: true
  roles:
    - apache
  vars:
    - dock_root: /var/www/example
```
```shell
ansible server_group -a "/sbin/reboot" # ad hoc Перезагрузка всех серверов группы
```

  ## Python
  ### Хэш-таблицы (dict)
```
dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}
del dict['Name']; # remove entry with key 'Name'
dict.clear();     # remove all entries in dict
del dict ;        # delete entire dictionary
```
  ### Класс итератор **НУЖНО ЗАТЕСТИТЬ**
```
class ProgrammingLanguages:
    _name = ("Python", "Golang", "C#", "C", "C++", "Java", "SQL", "JS")
    def __init__(self, first=None):
        self.index = (-1 if first is None else
                      ProgrammingLanguages._name.index(first) - 1)

    def __next__(self): // обязательнный шаг
        self.index += 1
        if self.index < len(ProgrammingLanguages._name):
            return ProgrammingLanguages._name[self.index]
        return result

    def __call__(self): // Хэндлер окончания итерации, можно подставить значение прерывания
        self.index += 1
        if self.index < len(ProgrammingLanguages._name):
            return ProgrammingLanguages._name[self.index]
        raise StopIteration

    def __iter__(self): // обязательнный вызов
        return self
        
for lang in iter(ProgrammingLanguages("C#"), None): // Вызов не с начала
    print(lang)
pl = ProgrammingLanguages()
for lang in iter(pl, "C"): // используется __call__ при достижении 2-го параметра
    print(lang)
```
  ### Класс генератор
В целом является итератором.  
При каждом вызове next выполнение в функции начинается с того места где было завершено в последний раз и 
продолжается до следующего yield
```
def gen_fun():
    
    print('block 1')
    yield 1
    print('block 2')
    yield 2
    print('end')

for i in gen_fun():
    print(i)
    print("/////")

# block 1
# 1
# /////
# block 2
# 2
# /////
# end

```

  ## docker

- Установка [docker](https://docs.docker.com/engine/install/ubuntu/)

- Установка [docker-compose](https://github.com/docker/compose/releases)
```shell
sudo curl -L "https://github.com/docker/compose/releases/download/v[version]/docker-compose-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose && docker-compose --version

docker image rm $(docker image  ls -aq) -f #Удалить все image.

docker container prune #Удалить все контейнеры.

docker system prune -a # Удалить хэш.

docker image ls #Список образов.

docker container ls #Список контейнеров.

docker logs <container name> # Логи запущенного контейнера

docker inspect <container name> # Подробная информация о контейнере.

docker exec -it <container name> /bin/bash`

docker-compose down && docker-compose build --force-rm && docker-compose up -d #Сборка и запуск контейнеров`


```






  ## github
- Создание нового репозитория из консоли

  - Создать новый репозиторий вручную и скопировать SSH ссылку, далее из папки:  

`git config --global user.email "Firzen475gmail.com" && git config --global user.name "Firzen475" && git init && git add .gitignore && git add . && git commit -m "first upload" && git remote add origin git@github.com:Firzen475/new_project.git && git push -u origin main`

***

`git clone --branch main --single-branch https://github.com/user/repo.git /TVAPI #Загрузка проекта в конкретную папку`

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

И наконец усановить ключи KMS. Они гуглятся по последним пяти символам. 

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


  Разное

Коммит сайта визитки
`git init
git add .
git commit -am "commit"
git remote add origin https://github.com/Firzen475/BusinessCardSite.git
git branch -vv
git branch -m master main
git push -f origin main
`

