```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-shared-pvc
  namespace: gitlab
  labels:
    app.kubernetes.io/name: test-shared-pvc
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: test-shared-pvc
  replicas: 1
  template:
    metadata:
      name: test-shared-pvc
      labels:
        app.kubernetes.io/name: test-shared-pvc
    spec:
      containers:
        - name: test-shared-pvc-container
          image: alpine:latest
          command: ["/usr/sbin/crond", "-f"] # Заглушка. Крон не работает без рут прав!
          volumeMounts:
            - mountPath: "/tmp/test/"
              name: test
      volumes:
        - name: test
          persistentVolumeClaim:
            claimName: repo-data-backup-gitaly-0
```