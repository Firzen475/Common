#!/usr/bin/env bash
set -euo pipefail

# ==============================
# Использование
# ==============================

#chmod +x compare-tls.sh

# TLS_NS="provisioners" TLS_POD="internal-nginx-ingress-nginx-controller-594df6f7b-nfg78" TLS_PATH="/tmp/certs" TLS_SECRET="cm-ingress-tls" TLS_SHELL="bash" ./compare-tls.sh

# ==============================
# Конфигурация
# ==============================
TLS_NS="${TLS_NS:-default}"                # пространство имён
TLS_POD="${TLS_POD:-my-pod}"               # имя пода
TLS_PATH="${TLS_PATH:-/etc/tls}"           # путь в поде, где лежат tls.crt и tls.key
TLS_SECRET="${TLS_SECRET:-my-secret}"      # имя секрета
TLS_SHELL="${TLS_SHELL:-sh}"               # исполняемый бинарь в поде (sh/ash/bash), по умолчанию sh
TLS_TMP="${TLS_TMP:-/tmp/tls-compare}"     # временная папка для сравнения

mkdir -p "$TLS_TMP"

# ==============================
# Шаг 1: выгрузка из пода
# ==============================
echo "[INFO] Забираем tls.crt и tls.key из пода $TLS_POD..."
kubectl exec -n "$TLS_NS" "$TLS_POD" -- "$TLS_SHELL" -c "cat $TLS_PATH/tls.crt" > "$TLS_TMP/pod-tls.crt"
kubectl exec -n "$TLS_NS" "$TLS_POD" -- "$TLS_SHELL" -c "cat $TLS_PATH/tls.key" > "$TLS_TMP/pod-tls.key"

# ==============================
# Шаг 2: выгрузка из секрета
# ==============================
echo "[INFO] Забираем tls.crt и tls.key из секрета $TLS_SECRET..."
kubectl get secret "$TLS_SECRET" -n "$TLS_NS" -o jsonpath='{.data.tls\.crt}' | base64 -d > "$TLS_TMP/secret-tls.crt"
kubectl get secret "$TLS_SECRET" -n "$TLS_NS" -o jsonpath='{.data.tls\.key}' | base64 -d > "$TLS_TMP/secret-tls.key"

# ==============================
# Шаг 3: печать содержимого сертификатов
# ==============================
echo "===== Сертификат из пода ====="
openssl x509 -in "$TLS_TMP/pod-tls.crt" -text -noout || echo "Ошибка чтения pod-tls.crt"

echo "===== Сертификат из секрета ====="
openssl x509 -in "$TLS_TMP/secret-tls.crt" -text -noout || echo "Ошибка чтения secret-tls.crt"

# ==============================
# Шаг 4: проверка ключей
# ==============================
echo "===== Проверка pod-tls.key ====="
openssl rsa -in "$TLS_TMP/pod-tls.key" -check -noout || echo "Ошибка чтения pod-tls.key"

echo "===== Проверка secret-tls.key ====="
openssl rsa -in "$TLS_TMP/secret-tls.key" -check -noout || echo "Ошибка чтения secret-tls.key"

# ==============================
# Шаг 5: проверка соответствия ключ ↔ сертификат
# ==============================
echo "===== Проверка, что ключи соответствуют сертификатам ====="
pod_cert_mod=$(openssl x509 -noout -modulus -in "$TLS_TMP/pod-tls.crt" | openssl md5)
pod_key_mod=$(openssl rsa -noout -modulus -in "$TLS_TMP/pod-tls.key" | openssl md5)
secret_cert_mod=$(openssl x509 -noout -modulus -in "$TLS_TMP/secret-tls.crt" | openssl md5)
secret_key_mod=$(openssl rsa -noout -modulus -in "$TLS_TMP/secret-tls.key" | openssl md5)

[[ "$pod_cert_mod" == "$pod_key_mod" ]] && echo "✅ Pod: ключ соответствует сертификату" || echo "❌ Pod: ключ не соответствует сертификату"
[[ "$secret_cert_mod" == "$secret_key_mod" ]] && echo "✅ Secret: ключ соответствует сертификату" || echo "❌ Secret: ключ не соответствует сертификату"

# ==============================
# Шаг 6: сравнение файлов
# ==============================
echo "===== Сравнение файлов ====="

diff -q "$TLS_TMP/pod-tls.crt" "$TLS_TMP/secret-tls.crt" >/dev/null && \
  echo "✅ tls.crt совпадают" || echo "❌ tls.crt различаются"

diff -q "$TLS_TMP/pod-tls.key" "$TLS_TMP/secret-tls.key" >/dev/null && \
  echo "✅ tls.key совпадают" || echo "❌ tls.key различаются"