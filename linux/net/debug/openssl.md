# OpenSSL: Основные команды и примеры

## Основные ключи команд OpenSSL

| Ключ | Описание |
|------|----------|
| `genpkey` | Генерация приватного ключа |
| `rsa` | Работа с RSA-ключами (извлечение публичного ключа) |
| `req` | Создание запросов на сертификат (CSR) |
| `x509` | Работа с сертификатами X.509 (просмотр, генерация) |
| `enc` | Шифрование и дешифрование данных |
| `dgst` | Вычисление хэшей и подпись файлов |
| `s_client` | Подключение к серверу с использованием SSL/TLS |
| `rand` | Генерация случайных данных |

## Генерация ключей и работа с сертификатами

```sh
# Генерация приватного ключа (RSA 2048 бит)
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048
# Генерация публичного ключа из приватного
openssl rsa -in private_key.pem -pubout -out public_key.pem
# Создание самоподписанного сертификата
openssl req -x509 -new -nodes -key private_key.pem -sha256 -days 365 -out certificate.pem
# Создание запроса на сертификат (CSR)
openssl req -new -key private_key.pem -out request.csr
# Проверка содержимого сертификата
openssl x509 -in certificate.pem -text -noout
```

## Шифрование и дешифрование файлов

```sh
# Шифрование файла с помощью AES-256
openssl enc -aes-256-cbc -salt -in file.txt -out file.enc -k mypassword
# Дешифрование файла
openssl enc -aes-256-cbc -d -in file.enc -out file_decrypted.txt -k mypassword
```

## Проверка хэшей и подписи

```sh
# Генерация SHA-256 хэша файла
openssl dgst -sha256 file.txt
# Подпись файла приватным ключом
openssl dgst -sha256 -sign private_key.pem -out signature.bin file.txt
# Проверка подписи файла
openssl dgst -sha256 -verify public_key.pem -signature signature.bin file.txt
```

## Работа с SSL/TLS
```sh
# Проверка соединения с сервером
openssl s_client -connect example.com:443
# Получение сертификата сервера
openssl s_client -connect example.com:443 -showcerts
# GET запрос
echo -e "GET / HTTP/1.1\r\nHost: example.com\r\n\r\n" | openssl s_client -connect example.com:443 -quiet
```

## Генерация случайных данных

### Генерация 32 случайных байтов (hex)
```sh
openssl rand -hex 32
```

## Заключение
OpenSSL — мощная утилита для работы с криптографией, сертификатами и безопасностью. В этом руководстве рассмотрены основные команды, но у OpenSSL гораздо больше возможностей.