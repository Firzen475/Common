
```shell
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



kubectl get -n monitoring         secret/dashboard-token -o jsonpath='{.data.token}' | base64 --decode

kubectl get -n secrets secret/vault -o jsonpath='{.data.token}' | base64 --decode

# Удаление Released persistentvolumes
kubectl get persistentvolume -o json | jq -r '.items[] | select(.status.phase == "Released") | .metadata.name' \
  xargs -I {} kubectl delete persistentvolumes --field-selector=metadata.name={}

KUBE_EDITOR="nano" kubectl edit -n kube-system cm/coredns

# Логи через селектор
kubectl logs -f -n kube-system --selector=k8s-app=kube-dns

journalctl -f -u kubelet




```