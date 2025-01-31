
## Подготовка

```yaml
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: test-reloader-secret
  namespace: default
  annotations:
    reloader.stakater.com/match: "true"
stringData:
  foo: "foo"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-reloader-config-map
  namespace: default
  annotations:
    reloader.stakater.com/match: "true"
data:
  bar: "bar"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-reloader-dp
  namespace: default
  labels:
    app: test-reloader
spec:
  selector:
    matchLabels:
      app: test-reloader
  replicas: 1
  template:
    metadata:
      annotations:
        #              reloader.stakater.com/auto: "true" # Проверяет все связанные секреты и cm
        reloader.stakater.com/search: "true" # Проверяет только отмеченные секреты и cm
      #              configmap.reloader.stakater.com/reload: "test-reloader-config-map"
      #              secret.reloader.stakater.com/reload: "foo-secret"
      labels:
        app: test-reloader
    spec:
      containers:
        - name: test-reloader-ct
          image: registry.k8s.io/e2e-test-images/agnhost:2.39
          volumeMounts:
            - mountPath: "/tmp/test-reloader-secret/"
              name: test-reloader-secret
              readOnly: true
            - mountPath: "/tmp/test-reloader-config-map/"
              name: test-reloader-config-map
              readOnly: true

      volumes:
        - name: test-reloader-secret
          secret:
            secretName: test-reloader-secret
        - name: test-reloader-config-map
          configMap:
            name: test-reloader-config-map
```

## Проверка

```shell
# После изменения под перезапустится.
kubectl edit configmap/test-reloader-config-map

```
