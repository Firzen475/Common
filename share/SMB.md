#

Не создавать поддиректорий.
allowVolumeExpansion не работает


## Через class
```yaml
---
# Учетные данные передаются через секрет
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: smb-creds
  namespace: default
stringData:
  username: "{{ tmp_kuber_share[0] }}"
  password: "{{ tmp_kuber_share[1] }}"
  domain: "."
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: smb-client-example
provisioner: smb.csi.k8s.io
reclaimPolicy: Retain # /Delete 
parameters:
  # On Windows, "*.default.svc.cluster.local" could not be recognized by csi-proxy
  source: //192.168.2.1/kuber
  # if csi.storage.k8s.io/provisioner-secret is provided, will create a sub directory
  # with PV name under source
  # ВНИМАНИЕ! Поддиректория не создаётся. При удалении pvc, удаляется вся папка. 
  # Не использовать один pvc в нескольких deployment.
  subDir: ${pvc.metadata.name} 
  csi.storage.k8s.io/provisioner-secret-name: smb-creds
  csi.storage.k8s.io/provisioner-secret-namespace: default
  csi.storage.k8s.io/node-stage-secret-name: smb-creds
  csi.storage.k8s.io/node-stage-secret-namespace: default
volumeBindingMode: Immediate
allowVolumeExpansion: true
mountOptions:
  - dir_mode=0777
  - file_mode=0777
#  - uid=1001
#  - gid=1001
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc-smb-example
  namespace: default
  annotations:
    nfs.io/storage-path: "test-path" # not required, depending on whether this annotation was shown in the storage class description
spec:
  storageClassName: smb-client-example
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Mi
---
---
apiVersion: apps/v1
kind: Deployment
#  ...
spec:
#    ...
template:
  spec:
    containers:
      #          ...
      volumeMounts:
        - mountPath: /app/folder
          name: volume
    volumes:
      - name: volume
        persistentVolumeClaim:
          claimName: pvc-smb-example
```






## Через pc + pvc