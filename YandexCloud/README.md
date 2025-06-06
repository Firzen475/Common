Задачи:
- Подключиться к YC через cli v

- Создать сервисный аккаунт для terraform

- Создать манифест для YC и развернуть ubuntu

- Создать vpn и соединиться с роутером

- Развернуть node kubernetes

- Создать статический конфиг kubernetes

- Создать pipline с кешем конфига kubernetes и манифестом terraform

- Изменить development-tool:
  - Добавить jq
  - переместить сертификаты в tmp
  - pem в /etc/ssl/certs/ как отдельный серт из tls
  - установка ca-certificates по дефолту
  - увеличить ожидание при деплое demonset на 5 мин

## Подключение через cli
#### Требования
* `apk add --no-cache ca-certificates` - Сертификаты для установки `yc`

#### Установка

<details>
<summary><strong>Модификация install.sh для alpine</strong></summary>

```shell
CURL_OPTIONS="-fSk"
function curl_has_option {
    echo "${CURL_HELP}" | grep -e "$@" > /dev/null
}

if curl_has_option "--retry"; then
    # Added in curl 7.12.3
    CURL_OPTIONS="$CURL_OPTIONS --retry 5 --retry-delay 0 --retry-max-time 120"
fi

if curl_has_option "--connect-timeout"; then
    # Added in curl 7.32.0.
    CURL_OPTIONS="$CURL_OPTIONS --connect-timeout 5 --max-time 300"
fi

if curl_has_option "--retry-connrefused"; then
    # Added in curl 7.52.0.
    CURL_OPTIONS="$CURL_OPTIONS --retry-connrefused"
fi

function curl_with_retry {
    eval curl $CURL_OPTIONS "$@"
}
```
</details>

```shell
curl -kL https://storage.yandexcloud.net/yandexcloud-yc/install.sh -o ./install.sh
chmod +x ./install.sh
./install.sh

export PATH="/source/yandex-cloud/bin:$PATH"

yc init --debug

yc config list

cat ./.config/yandex-cloud/config.yaml

current: default
profiles:
  default:
    token: [Жив 24 часа по умолчанию]
    cloud-id: []
    folder-id: []
    compute-default-zone: ru-central1-a

```

## Создание service account
#### Единовременная настройка
```shell
SA_NAME="terraform-sa"
FOLDER_NAME="default"

yc iam service-account create --name "$SA_NAME"

# Получаем folder_id по имени "$FOLDER_NAME"
FOLDER_ID=$(yc resource-manager folder list --format=json | jq -r '.[] | select(.name = "$FOLDER_NAME") | .id')

# Получаем cloud_id по имени "$FOLDER_NAME"
CLOUD_ID=$(yc resource-manager folder list --format=json | jq -r '.[] | select(.name = "$FOLDER_NAME") | .cloud_id')

# Получаем service_account_id по имени "$SA_NAME"
SERVICE_ACCOUNT_ID=$(yc iam service-account list --format=json | jq -r '.[] | select(.name = "$SA_NAME") | .id')


yc resource-manager folder add-access-binding "$FOLDER_ID" --role editor --subject serviceAccount:"$SERVICE_ACCOUNT_ID"

yc iam key create --service-account-id "$SERVICE_ACCOUNT_ID" --folder-id "$FOLDER_ID" --output key.json

cat ./key.json

yc config profile create "$SA_NAME"

yc config set service-account-key key.json
yc config set cloud-id "$CLOUD_ID"
yc config set folder-id "$FOLDER_ID"

# Профиль поместить в секреты (убрать default)
cat ./.config/yandex-cloud/config.yaml
```









#### Настройка в pipline
```shell
curl -kL https://storage.yandexcloud.net/yandexcloud-yc/install.sh -o ./install.sh
chmod +x ./install.sh
./install.sh

yc config list

# yc config profile activate "$SA_NAME" # Задаётся в config.yaml

# Переменные среды для terrafirm
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

# Список образов
yc compute image list --folder-id standard-images



```

































