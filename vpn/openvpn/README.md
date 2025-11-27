
## Установка

```shell
export OPENVPN_VERSION="2.7"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/openvpn-repo-public.asc] https://build.openvpn.net/debian/openvpn/release/${OPENVPN_VERSION:-stable} $(lsb_release -cs) main" > /etc/apt/sources.list.d/openvpn-aptrepo.list

# ovpn-dkms - модуль ядра для ускорения
apt-get update && apt-get -y install openvpn, ovpn-dkms
mkdir -p /etc/openvpn/ccd
cd /etc/openvpn/
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3
./easyrsa init-pki
# Генерация CA
./easyrsa  --use-algo=ed --curve=ed25519 build-ca nopass
# Просмотр CA
openssl x509 -in /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt -noout -text
# Генерация серверных ключей
./easyrsa  --use-algo=ed --curve=ed25519 build-server-full server nopass
# Просмотр серверных ключей
openssl x509 -in /etc/openvpn/easy-rsa/easyrsa3/pki/issued/server.crt -noout -text
openssl pkey -in /etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key -noout -text

# Сессионный ключ tls-crypt для сервера
openvpn --genkey tls-crypt-v2-server /etc/openvpn/server/tls-crypt-v2.key
# Не посмотреть 

nano /etc/openvpn/server.conf

touch /etc/openvpn/create_user.sh && chmod +x /etc/openvpn/create_user.sh
```


#### /etc/openvpn/server.conf
```shell

```
#### /etc/openvpn/create_user.sh
```shell
#!/bin/bash

# Проверка прав root
if [ "$(id -u)" != "0" ]; then
   echo "Этот скрипт должен быть запущен с правами root" 1>&2
   exit 1
fi

# Проверка аргументов
if [ -z "$1" ]; then
    echo "Использование: $0 <имя_клиента>"
    echo "Пример: $0 client1"
    exit 1
fi

CLIENT_NAME=$1
SERVER_DIR="/etc/openvpn"
CLIENT_DIR="/etc/openvpn/client"
EASYRSA_DIR="/etc/openvpn/easy-rsa/easyrsa3"
OUTPUT_FILE="${CLIENT_DIR}/${CLIENT_NAME}.ovpn"

# Создаем директорию для клиентов, если её нет
mkdir -p "$CLIENT_DIR"

# Переходим в директорию easyrsa
cd "$EASYRSA_DIR" || exit

# Генерируем клиентские сертификаты
echo -e "\n\033[1;32mГенерация сертификатов для клиента $CLIENT_NAME...\033[0m"
./easyrsa --use-algo=ed --curve=ed25519 build-client-full "$CLIENT_NAME" nopass

# Генерируем tls-crypt-v2 ключ для клиента
echo -e "\n\033[1;32mГенерация tls-crypt-v2 ключа...\033[0m"
openvpn --tls-crypt-v2 "/etc/openvpn/server/tls-crypt-v2.key" --genkey tls-crypt-v2-client "${SERVER_DIR}/${CLIENT_NAME}-tls-crypt-v2.key"

# Создаем .ovpn файл
echo -e "\n\033[1;32mСоздание конфигурационного файла $OUTPUT_FILE...\033[0m"

# Базовый конфиг
cat > "$OUTPUT_FILE" <<EOF
client
dev tun
proto udp
remote your.server.com 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
auth SHA256
verb 3
EOF

# Добавляем CA сертификат
echo "<ca>" >> "$OUTPUT_FILE"
cat "$EASYRSA_DIR/pki/ca.crt" >> "$OUTPUT_FILE"
echo "</ca>" >> "$OUTPUT_FILE"

# Добавляем клиентский сертификат
echo "<cert>" >> "$OUTPUT_FILE"
cat "$EASYRSA_DIR/pki/issued/${CLIENT_NAME}.crt" >> "$OUTPUT_FILE"
echo "</cert>" >> "$OUTPUT_FILE"

# Добавляем клиентский ключ
echo "<key>" >> "$OUTPUT_FILE"
cat "$EASYRSA_DIR/pki/private/${CLIENT_NAME}.key" >> "$OUTPUT_FILE"
echo "</key>" >> "$OUTPUT_FILE"

# Добавляем tls-crypt-v2 ключ
echo "<tls-crypt-v2>" >> "$OUTPUT_FILE"
cat "${SERVER_DIR}/${CLIENT_NAME}-tls-crypt-v2.key" >> "$OUTPUT_FILE"
echo "</tls-crypt-v2>" >> "$OUTPUT_FILE"

# Устанавливаем правильные права на файл
chmod 600 "$OUTPUT_FILE"

echo -e "\n\033[1;32mГотово! Конфигурационный файл создан: $OUTPUT_FILE\033[0m"

# Выводим содержимое файла с подсветкой
echo -e "\n\033[1;36m=== Содержимое файла $OUTPUT_FILE ===\033[0m"
echo -e "\033[1;33m"
cat "$OUTPUT_FILE"
echo -e "\033[0m"
echo -e "\033[1;36m=== Конец файла ===\033[0m"

# Инструкция для копирования
echo -e "\n\033[1;35mЧтобы скопировать файл на клиентское устройство, выполните:\033[0m"
echo -e "\033[1;37msudo cp $OUTPUT_FILE ~/ && sudo chown $(id -u -n): ~/${CLIENT_NAME}.ovpn\033[0m"
echo -e "\033[1;35mИли используйте scp для передачи на удаленный компьютер:\033[0m"
echo -e "\033[1;37mscp $OUTPUT_FILE user@remote_host:/path/to/save/\033[0m"
```

#### /etc/openvpn/create_user.sh


ecdh-curve prime256v1







## Дебаг OpenVPN

### Хост сервера

```shell
# Мониторинг пакетов до 
watch sudo iptables -L -n -v -Z --line-numbers

```
