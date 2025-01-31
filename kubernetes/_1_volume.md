

## Монтирование configMap и secrets

extraVolumes.name - имя configMap в том-же namespace
extraVolumeMounts.mountPath - точка монтирования. Файл или директория.
extraVolumeMounts.subPath - конкретный файл или поддиректория в cm (работает только без items:)


```yaml
spec:
  containers:
    - name: test
      image: busybox:1.28
      command: ['sh', '-c', 'echo "The app is running!" && tail -f /dev/null']
      volumeMounts:
        - name: example-cm
          mountPath: /etc/config/file.conf
          subPath: file.conf
  volumes:
    - name: example-cm
      configMap:
        name: example-cm
        items:
        - key: file.conf
          path: file.conf
          mode: 0755

```


```yaml
example1:
    extraVolumes:
      - name: ssl-certs
        configMap:
          name: kube-root-ca.crt
    
    # Any extra volume mounts
    extraVolumeMounts:
      - name: ssl-certs
        mountPath: /tmp/certs/ca-certificates.crt
        subPath: ca.crt 
        readOnly: true

example2:
    ## Additional volumes to minio container
    extraVolumes:
      - name: etcd-crt-key
        secret:
          secretName: custom-etcd-tls
          items:
            - key: tls.crt
              path: etcd_client_cert.crt
            - key: tls.key
              path: etcd_client_cert_key.key
    
    
    ## Additional volumeMounts to minio container
    extraVolumeMounts:
      - name: etcd-crt-key
        mountPath: "/tmp/credentials/"
        readOnly: true

```

## persistence


```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc
  namespace: minio
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  volumeName: pv
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
  namespace: minio
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  nfs:
    path: "/minio-01"
    server: "192.168.2.1"
    readOnly: false
---
apiVersion: v1
kind: Pod
metadata:
  name: test-pvc
  namespace: minio
  labels:
    app.kubernetes.io/name: test-pvc
spec:
  containers:
    - name: test-pvc
      image: registry.k8s.io/e2e-test-images/agnhost:2.39
      volumeMounts:
        - mountPath: "/tmp/test/"
          name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: pvc
```
```shell

[ -z $dddddd ]
```



























