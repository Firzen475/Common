# Установка кластера
## NODE не соединяется с кластером
### Не удаётся получить сертификаты внешнего ETCD.
* Подготовить актуальный kubeadm_init.conf кластера.
* На NODE control-plane
  ```shell
  echo "$(kubeadm token create --print-join-command) --control-plane --certificate-key $(kubeadm init phase upload-certs --upload-certs --config=/tmp/kubeadm_init.conf | tail -n1 )"
  ```
* На новой node
  ```shell
  kubeadm init phase upload-certs --upload-certs --config /tmp/kubeadm_init.conf
  [join-command]
  ```

# Внешние registry
Дано:
* Подключиться к https:registry.fzen.pro
## containerd
* Добавить ca.crt в /etc/ssl/certs/
* Создать секрет.
```yaml
.dockerconfigjson: !unsafe |
        {"auths":{"https://registry.fzen.pro/v2/":{"username":"root","password":"{{ .registry_token }}","email":"admin@fzen.pro","auth":"{{- printf "root:%s" .registry_token | b64enc -}}"}}}
```
```yaml
apiVersion: v1
data:
  .dockerconfigjson: {{ .dockerconfigjson }}
kind: Secret
metadata:
  name: secret
  namespace: ns
type: kubernetes.io/dockerconfigjson
```
* Добавить секрет в pod
```yaml
kind: Pod
metadata:
  name: test
  namespace: ns
spec:
  containers:
    - image: registry.fzen.pro/test/test:latest
      imagePullPolicy: Always
      name: test
  imagePullSecrets:
    - name: secret
```
* Перезапустить containerd на всех node
```shell
servise containerd restart
```
```yaml
- hosts: servers
  become: true
  tasks:
    - name: Restart containerd for apply registry certs
      ansible.builtin.service:
        name: containerd
        state: restarted
        enabled: true
```
## docker
* Добавить ca.crt в /etc/docker/certs.d/registry.fzen.pro/  
* --//--
* Перезапустить docker на всех node
```shell
servise docker restart
```
```yaml
- hosts: servers
  become: true
  tasks:
    - name: Restart containerd for apply registry certs
      ansible.builtin.service:
        name: docker
        state: restarted
        enabled: true
```