




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




```shell

kubectl exec -it -n gitlab             pod/gitlab-gitaly-0 -- chown -R git:git /home/git/repositories/


# control01
watch kubectl get sc,pvc,pv,volumeattachments -A -o wide
# control01
watch kubectl get secretstores,externalsecrets,clustersecretstores,clusterexternalsecrets -A -o wide
# control01
watch "kubectl get issuers,clusterissuers,certificates,bundles,secrets,cm -A -o wide | grep -v helm | grep -v calico-system | grep  -v kube-system | grep  -v secrets "
# control02
watch "kubectl get rc,ingress,services,node -A -o wide | grep -v calico-system | grep  -v kube-system"
# control03
watch "kubectl get pods -A -o wide | grep -v calico-system | grep  -v kube-system"




kubectl get sa,role,rolebinding,clusterrole,clusterrolebinding -o wide

helm search repo

helm get values RELEASE_NAME

```





```shell
kubeadm config validate --config="/tmp/kuberadm_init.conf" # Проверка файла настроек

kubeadm init phase upload-certs --upload-certs --config=/tmp/kuberadm_init.conf # Фаза генерации InitConfiguration.certificateKey

kubeadm init --config=/mnt/swarm/repo/kuberadm_init.conf --v=5

kubeadm reset --config=/mnt/swarm/repo/kuberadm_init.conf

kubectl get pods -A -o wide

kubectl get rc,services,node -A -o wide

kubectl logs -n kube-system kube-controller-manager-control01

kubectl get componentstatus

journalctl -f -u kubelet


kubectl describe pods/calico-typha-74dcf59cbf-ffcv2 -n calico-system

crictl -h # Управление контейнерами на уровне containerd

kubectl get svc kubernetes


kubectl delete pod --selector=[label]=[value] -A
kubectl delete pod --field-selector status.phase=Failed -A

/////////////////////////////////////

calico
kubectl get tigerastatus


helm upgrade calico projectcalico/tigera-operator --version v3.28.2 -f /mnt/kuber/repo/calico-values.yaml --namespace tigera-operator




# Тестирование пользовательских метрик
watch "kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1 | jq && echo '//////////////////////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pods/*/my_custom_metric | jq"

watch "kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1 | jq && echo '/////////////target//////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/kube-system/testing/pods/*/my_custom_metric?selector=pod%3Dcoredns | jq && \
echo '/////////////namespaces+pods//////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/kube-system/pods/coredns/my_custom_metric | jq && \
echo '/////////////pods//////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/pods/coredns/my_custom_metric | jq && \
echo '/////////////namespaces//////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/kube-system/my_custom_metric | jq && \
echo '/////////////---------//////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/my_custom_metric | jq " 


kubectl get deploy -A
kubectl exec -it deploy/grafana -n monitoring -- sh


```
