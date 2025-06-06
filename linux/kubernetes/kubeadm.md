```
preflight                     Run pre-flight checks
certs                         Certificate generation
  /ca                           Generate the self-signed Kubernetes CA to provision identities for other Kubernetes components
  /apiserver                    Generate the certificate for serving the Kubernetes API
  /apiserver-kubelet-client     Generate the certificate for the API server to connect to kubelet
  /front-proxy-ca               Generate the self-signed CA to provision identities for front proxy
  /front-proxy-client           Generate the certificate for the front proxy client
  /etcd-ca                      Generate the self-signed CA to provision identities for etcd
  /etcd-server                  Generate the certificate for serving etcd
  /etcd-peer                    Generate the certificate for etcd nodes to communicate with each other
  /etcd-healthcheck-client      Generate the certificate for liveness probes to healthcheck etcd
  /apiserver-etcd-client        Generate the certificate the apiserver uses to access etcd
  /sa                           Generate a private key for signing service account tokens along with its public key
kubeconfig                    Generate all kubeconfig files necessary to establish the control plane and the admin kubeconfig file
  /admin                        Generate a kubeconfig file for the admin to use and for kubeadm itself
  /super-admin                  Generate a kubeconfig file for the super-admin
  /kubelet                      Generate a kubeconfig file for the kubelet to use *only* for cluster bootstrapping purposes
  /controller-manager           Generate a kubeconfig file for the controller manager to use
  /scheduler                    Generate a kubeconfig file for the scheduler to use
etcd                          Generate static Pod manifest file for local etcd
  /local                        Generate the static Pod manifest file for a local, single-node local etcd instance
control-plane                 Generate all static Pod manifest files necessary to establish the control plane
  /apiserver                    Generates the kube-apiserver static Pod manifest
  /controller-manager           Generates the kube-controller-manager static Pod manifest
  /scheduler                    Generates the kube-scheduler static Pod manifest
kubelet-start                 Write kubelet settings and (re)start the kubelet
upload-config                 Upload the kubeadm and kubelet configuration to a ConfigMap
  /kubeadm                      Upload the kubeadm ClusterConfiguration to a ConfigMap
  /kubelet                      Upload the kubelet component config to a ConfigMap
upload-certs                  Upload certificates to kubeadm-certs
mark-control-plane            Mark a node as a control-plane
bootstrap-token               Generates bootstrap tokens used to join a node to a cluster
kubelet-finalize              Updates settings relevant to the kubelet after TLS bootstrap
  /enable-client-cert-rotation  Enable kubelet client certificate rotation
  /experimental-cert-rotation   Enable kubelet client certificate rotation (DEPRECATED: use 'enable-client-cert-rotation' instead)
addon                         Install required addons for passing conformance tests
  /coredns                      Install the CoreDNS addon to a Kubernetes cluster
  /kube-proxy                   Install the kube-proxy addon to a Kubernetes cluster
show-join-command             Show the join command for control-plane and worker node
```
### Сброс NODE
```shell
# Обычный сброс
kubeadm reset -f
# Сброс по правилами в файле
kubeadm reset --config=/mnt/swarm/repo/kuberadm_init.conf
# Удаление драйвера cni
rm -rf /opt/cni/bin/ && rm -rf /etc/cni/net.d/ && mkdir -p /opt/cni/bin/ && mkdir -p /etc/cni/net.d/
# Сброс iptables
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
iptables -X

ip route flush proto bird
# Удаление сетевых интерфейсов
ip link list | grep doc | awk '{print $2}' | cut -c 1-15 | xargs -I {} ip link delete {}
ip link list | grep cali | awk '{print $2}' | cut -c 1-15 | xargs -I {} ip link delete {}
ip link list | grep xv | awk '{print $2}' | cut -c 1-15 | xargs -I {} ip link delete {}
ip link list | grep xe | awk '{print $2}' | cut -c 1-15 | xargs -I {} ip link delete {}
# Удаление модуля ядра ipip
modprobe -r ipip

# Восстановление маршрутов docker
systemctl docker restart
```

### Установка master node
```shell
# Проверка файла настроек
kubeadm config validate --config="/tmp/kuberadm_init.conf"

kubeadm init --config=/mnt/swarm/repo/kuberadm_init.conf --v=5

echo "$(kubeadm token create --print-join-command) --control-plane --certificate-key $(kubeadm init phase upload-certs --upload-certs --config=/tmp/kubeadm_init.conf | tail -n1 )" > /tmp/manager
echo "$(kubeadm token create --print-join-command)" > /tmp/worker

```
### Присоединение node
```shell
# Фаза генерации InitConfiguration.certificateKey
# Может понадобиться на новых NODE
kubeadm init phase upload-certs --upload-certs --config=/tmp/kuberadm_init.conf 
/tmp/manager
/tmp/worker

kubectl label node node1 node-role.kubernetes.io/resource=resource_name
```
### Calico
```shell
helm repo add projectcalico https://docs.tigera.io/calico/charts
helm upgrade calico projectcalico/tigera-operator -n kube-system \
      --force --wait --install \
      -f /tmp/calico-values.yaml
kubectl-calico create -f /tmp/calico-networks.yaml
```

