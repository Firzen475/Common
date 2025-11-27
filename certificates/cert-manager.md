

ACME letsencrypt.org               DNS -> TXT _acme-challenge.<domain.com>

Issuer/ClusterIssuer -> Certificate -> CertificateRequest -> Order -> Challenge





1. Issuer/ClusterIssuer
   Что это: Базовый ресурс, определяющий конфигурацию CA (Certificate Authority), от которой будут выпускаться сертификаты.

Зачем:

Хранит настройки для работы с ACME-провайдером (например, Let's Encrypt).

Указывает сервер ACME, API-ключи, метод валидации (HTTP-01, DNS-01 и т.д.).

Issuer работает в рамках одного namespace, ClusterIssuer — для всего кластера.

Пример: Настройки для Let's Encrypt (production/staging), email для уведомлений.

2. Certificate
   Что это: Пользовательский ресурс, описывающий желаемый TLS-сертификат.

Зачем:

Определяет домены (SANs), для которых нужен сертификат.

Ссылается на Issuer/ClusterIssuer, который должен выпустить сертификат.

После успешного выпуска сохраняет сертификат и ключ в Kubernetes Secret.

Пример: Запрос сертификата для example.com и *.example.com.

3. CertificateRequest
   Что это: Временный ресурс, создаваемый cert-manager на основе Certificate.

Зачем:

Содержит CSR (Certificate Signing Request), который отправляется в ACME-провайдер.

Связывает Certificate с Order (для ACME).

Удаляется после завершения процесса (успешного или неудачного).

4. Order
   Что это: ACME-специфичный ресурс, представляющий запрос на валидацию доменов.

Зачем:

Описывает набор доменов, которые нужно подтвердить.

Создаётся ACME-клиентом (cert-manager) при обработке CertificateRequest.

Может включать несколько Challenge (если доменов несколько).

5. Challenge
   Что это: Ресурс для валидации права на владение доменом.

Зачем:

Реализует механизм подтверждения (HTTP-01, DNS-01, TLS-ALPN-01).

Для HTTP-01: создаёт временный Ingress/Pod для ответа на запрос Let's Encrypt.

Для DNS-01: создаёт TXT-запись в DNS.

Удаляется после успешной валидации.







