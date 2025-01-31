

```shell
kubectl get -n secrets secret/vault -o jsonpath='{.data.token}' | base64 --decode


curl -k --cacert /tmp/certs/ca.crt --header "X-Vault-Token: hvs.FGZKRVop2obKoqeHLmb2bKqB" \
       --request GET \
       https://vault.secrets.svc:8200/v1/database/static-creds | jq



curl -k --cacert /tmp/certs/ca.crt --header "X-Vault-Token: $(cat /tmp/token)" --request PUT https://vault.secrets.svc:8200/v1/sys/policies/acl/pgadmin4;
curl -k --cacert /tmp/certs/ca.crt --header "X-Vault-Token: $(cat /tmp/token)" --request POST --data '{"policies": ["pgadmin4"],"bound_service_account_names": $(echo $AC),"bound_service_account_namespaces":$(echo $NS)}' https://vault.secrets.svc:8200/v1/auth/kubernetes/role/pgadmin4;
```




## Настройка

После КАЖДОГО удаления пода vault нужно выполнить:
1) Разблокировать базу данных через ui
2) Пере привязать jwt_token:
```shell
kubectl exec -ti vault-0 -n secrets -- /bin/sh
export VAULT_ADDR='https://vault.secrets.svc:8200'
export VAULT_CACERT='/tmp/certs/ca.crt'
export VAULT_TOKEN="hvs.######"
vault write auth/kubernetes/config token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host=https://192.168.2.2:6443 kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export VAULT_TOKEN=""
```

## GITHUB auth
```shell

kubectl exec -ti vault-0 -n secrets -- /bin/sh
export VAULT_ADDR='https://vault.secrets.svc:8200'
export VAULT_CACERT='/tmp/certs/ca.crt'
export VAULT_TOKEN="hvs.######" # Сгенерированный root токен при инициализации.
# https://developer.hashicorp.com/vault/docs/auth
vault auth enable github
vault write auth/github/config organization=FZEN475 # Это организация на github
vault write auth/github/map/users/Firzen475 value=default # Привязка пользователя github к политике. root использовать нельзя.
# Создаётся токен доступа на github с правами на чтение Members
vault login -method=github # Проверка работы токена.
export VAULT_TOKEN=""

```

## Интеграция с cert-manager
```shell
kubectl exec -ti vault-0 -n secrets -- /bin/sh
export VAULT_ADDR='https://vault.secrets.svc:8200'
export VAULT_CACERT='/tmp/certs/ca.crt'
export VAULT_TOKEN="hvs.######"
vault secrets enable pki
vault write pki/config/urls issuing_certificates="https://vault.secrets.svc:8200/v1/pki/ca" crl_distribution_points="https://vault.secrets.svc:8200/v1/pki/crl"
vault write pki/roles/etcd allowed_domains=etcd.secrets.svc allow_subdomains=true allow_any_name=true ext_key_usage=Any max_ttl=72h
vault policy write pki - <<EOF
path "pki*"                        { capabilities = ["read", "list"] }
path "pki/sign/etcd"    { capabilities = ["create", "update"] }
path "pki/issue/etcd"   { capabilities = ["create"] }
EOF
vault write auth/kubernetes/role/issuer \
    bound_service_account_names=issuer \
    bound_service_account_namespaces=secrets \
    policies=pki \
    ttl=20m
```
```yaml
# Позволяет создавать токен для ServiceAccount issuer
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: vault-issuer
  namespace: secrets
rules:
  - apiGroups: ['']
    resources: ['serviceaccounts/token'] # Какой ресурс разрешено создавать.
    resourceNames: ['issuer'] # Для кого есть право создавать ресурс.
    verbs: ['create']
---
# Привязка разрешения к ServiceAccount cert-manager
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: vault-issuer
  namespace: secrets
subjects:
  - kind: ServiceAccount
    name: cert-manager
    namespace: secrets
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: vault-issuer
---
# ServiceAccount создающий сертификаты
apiVersion: v1
kind: ServiceAccount
metadata:
  name: issuer
  namespace: secrets
---
# ClusterIssuer создаёт сертификаты в vault и помещает в секреты
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: vault-etcd-ci
  namespace: secrets
spec:
  vault:
    path: pki/sign/etcd
    server: https://vault.secrets.svc:8200
    caBundleSecretRef:
      name: "cm-vault-tls"
      key: "ca.crt"
    auth:
      kubernetes:
        role: issuer
        mountPath: /v1/auth/kubernetes
        serviceAccountRef:
          name: issuer
---
# Пример клиентского сертификата для etcd
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cm-test-etcd-client-tls
  namespace: default
spec:
  isCA: false
  # Secret names are always required.
  secretName: test-etcd-client-tls
  commonName: client
  usages:
    - server auth
    - client auth
  subject:
    organizations:
      - cert-manager
  dnsNames:
    - 'etcd.fzen.local'
  ipAddresses:
    - 192.168.2.2
  additionalOutputFormats:
    - type: CombinedPEM
  issuerRef:
    name: vault-etcd-ci
    kind: ClusterIssuer
    group: cert-manager.io
---
# Deployment для теста 
# curl --cacert /tmp/test-etcd-client-tls/ca.crt  --cert /tmp/test-etcd-client-tls/tls.crt  --key /tmp/test-etcd-client-tls/tls.key  -L https://192.168.2.2:2381/readyz?verbose
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-etcd-client-dp
  namespace: default
  labels:
    app: test-etcd-client
spec:
  selector:
    matchLabels:
      app: test-etcd-client
  replicas: 1
  template:
    metadata:
      labels:
        app: test-etcd-client
    spec:
      containers:
        - name: test-reloader-ct
          image: registry.k8s.io/e2e-test-images/agnhost:2.39
          volumeMounts:
            - mountPath: "/tmp/test-etcd-client-tls/"
              name: test-etcd-client-tls
              readOnly: true
      volumes:
        - name: test-etcd-client-tls
          secret:
            secretName: test-etcd-client-tls
```



## kuber auth
### Подготовка
```shell
kubectl exec -ti vault-0 -n secrets -- /bin/sh
export VAULT_ADDR='https://vault.secrets.svc:8200'
export VAULT_CACERT='/tmp/certs/ca.crt'
export VAULT_TOKEN="hvs.######"
vault auth enable kubernetes
vault write auth/kubernetes/config token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host=https://192.168.2.2:6443 kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export VAULT_TOKEN=""
```
### Тестирование
Предположим, для каждого пространства имён секреты будут общие. Структура секретов [namespace]/[app]/[key]:
 - Создать политику чтения секретов (Проще всего через UI)
```
path "default*" {
  capabilities = ["read"]
}
```
 - Привязать политику к сервис-аккаунтам, которые будут читать секреты
```shell
kubectl exec -ti vault-0 -n secrets -- /bin/sh
export VAULT_ADDR='https://vault.secrets.svc:8200'
export VAULT_CACERT='/tmp/certs/ca.crt'
export VAULT_TOKEN="hvs.######"

vault policy write test - <<EOF
path "default**"                        { capabilities = ["read", "list"] }
EOF

vault write auth/kubernetes/role/test bound_service_account_names="test-vault-sa" bound_service_account_namespaces="default" policies=test ttl=1h
vault secrets enable -path=default kv-v2
vault secrets list -detailed
vault kv put -mount=default test-vault/credentials username=user password=password
vault kv put -mount=default test-vault/some-secret secret=secret
export VAULT_TOKEN=""
```

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test-vault-sa
  namespace: default
  labels:
    app: test-vault
---

apiVersion: trust.cert-manager.io/v1alpha1
kind: Bundle
metadata:
  name: cm-vault-tls-ca
spec:
  sources:
    - useDefaultCAs: false
    - secret:
      name: "cm-vault-tls"
      key: "ca.crt"
  target:
    secret:
      key: "ca.crt"
    additionalFormats:
      jks:
        key: "bundle.jks"
      pkcs12:
        key: "bundle.p12"
    namespaceSelector:
      matchLabels:
        kubernetes.io/metadata.name: "default"
---
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: test-ss
  namespace: default
spec:

  # Used to select the correct ESO controller (think: ingress.ingressClassName)
  # The ESO controller is instantiated with a specific controller name
  # and filters ES based on this property
  # Optional
  #controller: dev

  # You can specify retry settings for the http connection
  # these fields allow you to set a maxRetries before failure, and
  # an interval between the retries.
  # Current supported providers: AWS, Hashicorp Vault, IBM
  retrySettings:
    maxRetries: 5
    retryInterval: "10s"

  # provider field contains the configuration to access the provider
  # which contains the secret exactly one provider must be configured.
  provider:


    # (2) Hashicorp Vault
    vault:
      server: "https://vault.secrets.svc:8200"
      # Path is the mount path of the Vault KV backend endpoint
      # Used as a path prefix for the external secret key
      # префикс пути конечной точки. Для версии v2 в моём примере:
      # /default/[path]/test-vault/secret
      # по умолчанию /data
      #            path: "/data"
      # Version is the Vault KV secret engine version.
      # This can be either "v1" or "v2", defaults to "v2"
      version: "v2"
      #            # vault enterprise namespace: https://www.vaultproject.io/docs/enterprise/namespaces
      namespace: "secrets"
      #            # base64 encoded string of certificate
      #            caBundle: "..."
      #            # Instead of caBundle you can also specify a caProvider
      #            # this will retrieve the cert from a Secret or ConfigMap
      caProvider:
        # Can be Secret or ConfigMap
        type: "Secret"
        name: "cm-vault-tls-ca"
        key: "ca.crt"
      #            # client side related TLS communication, when the Vault server requires mutual authentication
      #            tls:
      #              certSecretRef:
      #                namespace: ...
      #                name: "my-cert-secret"
      #                key: "tls.crt"
      #              keySecretRef:
      #                namespace: ...
      #                name: "my-cert-secret"
      #                key: "tls.key"

      auth:
        #              # static token: https://www.vaultproject.io/docs/auth/token
        #              tokenSecretRef:
        #                name: "my-secret"
        #                key: "vault-token"

        #              # AppRole auth: https://www.vaultproject.io/docs/auth/approle
        #              appRole:
        #                path: "approle"
        #                # Instead of referencing the AppRole's ID from the secret, you can also specify it directly
        #                # roleId: "db02de05-fa39-4855-059b-67221c5c2f63"
        #                roleRef:
        #                  name: "my-secret"
        #                  key: "vault-role-id"
        #                secretRef:
        #                  name: "my-secret"
        #                  key: "vault-role-secret"

        # Kubernetes auth: https://www.vaultproject.io/docs/auth/kubernetes
        kubernetes:
          # Путь, по которому в Vault смонтирован бэкэнд аутентификации Kubernetes.
          # по факту это часть пути к эндпоинту, которое формируеется командой:
          # vault write auth/[mountPath]/config ...
          mountPath: "kubernetes"
          # vault write auth/[mountPath]/role/[role]
          role: "test"
          # Optional service account reference
          serviceAccountRef:
            name: "test-vault-sa"
#                # Optional secret field containing a Kubernetes ServiceAccount JWT
#                # used for authenticating with Vault
#                secretRef:
#                  name: "my-secret"
#                  key: "vault"

#              # TLS certificates auth method: https://developer.hashicorp.com/vault/docs/auth/cert
#              cert:
#                clientCert:
#                  namespace: ...
#                  name: "my-cert-secret"
#                  key: "tls.crt"
#                secretRef:
#                  namespace: ...
#                  name: "my-cert-secret"
#                  key: "tls.key"

#          # (3): GCP Secret Manager
#          gcpsm:
#            # Auth defines the information necessary to authenticate against GCP by getting
#            # the credentials from an already created Kubernetes Secret.
#            auth:
#              secretRef:
#                secretAccessKeySecretRef:
#                  name: gcpsm-secret
#                  key: secret-access-credentials
#            projectID: myproject
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: test-es
  namespace: default
  # labels and annotations are copied over to the
  # secret that will be created
  labels:
    managed.by: "test-es"
  annotations:
    app: test-vault

spec:

  # Optional, SecretStoreRef defines the default SecretStore to use when fetching the secret data.
  secretStoreRef:
    name: test-ss
    kind: SecretStore  # or ClusterSecretStore

  # RefreshInterval is the amount of time before the values reading again from the SecretStore provider
  # Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h" (from time.ParseDuration)
  # May be set to zero to fetch and create it once
  refreshInterval: "1h"

  # the target describes the secret that shall be created
  # there can only be one target per ExternalSecret
  target:

    # The secret name of the resource
    # Defaults to .metadata.name of the ExternalSecret
    # It is immutable
    name: credentials

    # Specifies the ExternalSecret ownership details in the created Secret. Options:
    # - Owner: (default) Creates the Secret and sets .metadata.ownerReferences. If the ExternalSecret is deleted, the Secret will also be deleted.
    # - Merge: Does not create the Secret but merges data fields into the existing Secret (expects the Secret to already exist).
    # - Orphan: Creates the Secret but does not set .metadata.ownerReferences. If the Secret already exists, it will be updated.
    # - None: Does not create or update the Secret (reserved for future use with injector).
    creationPolicy: Owner

    # Specifies what happens to the Secret when data fields are deleted from the provider (e.g., Vault, AWS Parameter Store). Options:
    # - Retain: (default) Retains the Secret if all Secret data fields have been deleted from the provider.
    # - Delete: Removes the Secret if all Secret data fields from the provider are deleted.
    # - Merge: Removes keys from the Secret but not the Secret itself.
    deletionPolicy: Delete

      # Specify a blueprint for the resulting Kind=Secret
      #          template:
      #            type: Opaque # or TLS...
      #
      #            metadata:
      #              annotations: {}
      #              labels: {}
      #
      #            # Use inline templates to construct your desired config file that contains your secret
      #            data:
      #              credentials: !unsafe |
      #                credentials-inline:
      #                  {{ .username }}:{{ .password }}:{{ .secret }}



  #            # Uses an existing template from configmap
  #            # Secret is fetched, merged and templated within the referenced configMap data
  #            # It does not update the configmap, it creates a secret with: data["alertmanager.yml"] = ...result...
  #            templateFrom:
  #              - configMap:
  #                  name: application-config-tmpl
  #                  items:
  #                    - key: config.yml

  #        # Data defines the connection between the Kubernetes Secret keys and the Provider data
  data:
    - secretKey: username
      remoteRef:
        key: default/test-vault/credentials
        property: username
        #              version: 2 # Версия секрета!!!
        decodingStrategy: None # can be None, Base64, Base64URL or Auto
    - secretKey: password
      remoteRef:
        key: default/test-vault/credentials
        property: password
        decodingStrategy: None
    - secretKey: secret
      remoteRef:
        key: default/test-vault/some-secret
        property: secret
        decodingStrategy: None
#          - secretKey: username
#            remoteRef:
#              key: database-credentials
#              version: v1
#              property: username
#              decodingStrategy: None # can be None, Base64, Base64URL or Auto
#
#            # define the source of the secret. Can be a SecretStore or a Generator kind
#            sourceRef:
#              # point to a SecretStore that should be used to fetch a secret.
#              # must be defined if no spec.secretStoreRef is defined.
#              storeRef:
#                name: aws-secretstore
#                kind: ClusterSecretStore

#        # Used to fetch all properties from the Provider key
#        # If multiple dataFrom are specified, secrets are merged in the specified order
#        # Can be defined using sourceRef.generatorRef or extract / find
#        # Both use cases are exemplified below
#        dataFrom:
#          - sourceRef:
#              generatorRef:
#                apiVersion: generators.external-secrets.io/v1alpha1
#                kind: ECRAuthorizationToken
#                name: "my-ecr"
#        #Or
#        dataFrom:
#          - extract:
#              key: database-credentials
#              version: v1
#              property: data
#              conversionStrategy: Default
#              decodingStrategy: Auto
#            rewrite:
#              - regexp:
#                  source: "exp-(.*?)-ression"
#                  target: "rewriting-${1}-with-groups"
#          - find:
#              path: path-to-filter
#              name:
#                regexp: ".*foobar.*"
#              tags:
#                foo: bar
#              conversionStrategy: Unicode
#              decodingStrategy: Base64
#            rewrite:
#              - regexp:
#                  source: "foo"
#                  target: "bar"
---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: test-es-with-template
  namespace: default
  # labels and annotations are copied over to the
  # secret that will be created
  labels:
    managed.by: "test-es-with-template"
  annotations:
    app: test-vault
spec:
  secretStoreRef:
    name: test-ss
    kind: SecretStore  # or ClusterSecretStore
  refreshInterval: "1h"
  target:
    name: credentials-with-template
    creationPolicy: Owner
    deletionPolicy: Delete
    template:
      type: Opaque # or TLS...

      metadata:
        annotations: {}
        labels: {}
      data:
        credentials: !unsafe |
          credentials-inline:
            {{ .username }}:{{ .password }}:{{ .secret }}
  data:
    - secretKey: username
      remoteRef:
        key: default/test-vault/credentials
        property: username
        #              version: 2 # Версия секрета!!!
        decodingStrategy: None # can be None, Base64, Base64URL or Auto
    - secretKey: password
      remoteRef:
        key: default/test-vault/credentials
        property: password
        decodingStrategy: None
    - secretKey: secret
      remoteRef:
        key: default/test-vault/some-secret
        property: secret
        decodingStrategy: None
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-vault-dp
  namespace: default
  labels:
    app: test-vault
spec:
  selector:
    matchLabels:
      app: test-vault
  replicas: 1
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/agent-inject-status: "update"
        vault.hashicorp.com/ca-cert: "/run/secrets/kubernetes.io/serviceaccount/ca.crt"
        vault.hashicorp.com/agent-inject-secret-credentials: "default/test-vault/credentials"
        vault.hashicorp.com/agent-inject-template-credentials: !unsafe |
          {{- with secret "default/test-vault/credentials" -}}
          {{ .Data.data.username }}:{{ .Data.data.password }}
          {{- end }}
        vault.hashicorp.com/agent-inject-secret-some-secret: "default/test-vault/some-secret"
        vault.hashicorp.com/agent-inject-template-some-secret: !unsafe |
          {{- with secret "default/test-vault/some-secret" -}}
          {{ .Data.data.secret }}
          {{- end }}
        vault.hashicorp.com/role: "test"
      labels:
        app: test-vault
    spec:
      serviceAccountName: test-vault-sa
      containers:
        - name: test-vault-ct
          image: registry.k8s.io/e2e-test-images/agnhost:2.39
          volumeMounts:
            - mountPath: "/tmp/credentials/"
              name: credentials
              readOnly: true
            - mountPath: "/tmp/credentials-with-template/"
              name: credentials-with-template
              readOnly: true

      volumes:
        - name: credentials
          secret:
            secretName: credentials
        - name: credentials-with-template
          secret:
            secretName: credentials-with-template
```
## Проверка
```shell
kubectl exec -it deploy/test-vault-dp -n default  -- sh
cat /vault/secrets/credentials
cat /tmp/credentials/password
cat /tmp/credentials-with-template/credentials
```























