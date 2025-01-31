




```shell

watch "kubectl get clusterissuers -A &&  kubectl get certificates -A && kubectl get secrets -A"

# Проверка цепочки сертификатов
# Исходная последовательность:
# ca -> Issuer.root-ca-issuer - генерирует коневой сертификат.
# Issuer.root-ca-issuer -> Certificate.root-ca - из корневого сертификата создаёт промежуточный в namespace: kube-system
# Certificate.root-ca -> ClusterIssuer.intermediate-ca-cluster-issuer - даёт возможность создать промежуточный сертификат на весь кластер
# ClusterIssuer.intermediate-ca-cluster-issuer -> Certificate.intermediate-root-ca - создаёт промежуточный сертификат l2 
#    для namespace: kube-system но уже из ClusterIssuer (просто пример)
# Цепочка: root -> Certificate.root-ca -> Certificate.intermediate-root-ca

# root                       kuber-root-ca.[ca.crt] = kuber-root-ca.[tls.crt]
kubectl get secret -n kube-system kuber-root-ca -o jsonpath='{.data.ca\.crt}' | base64 --decode  > /tmp/root_ca.crt
kubectl get secret -n kube-system kuber-root-ca -o jsonpath='{.data.tls\.crt}' | base64 --decode  > /tmp/root_ca_tls.crt

# kuber-root-ca.[ca.crt] = kuber-root-ca.[tls.crt] = root-intermediate0-ca.[ca.crt] != root-intermediate0-ca.[tls.crt]
kubectl get secret -n kube-system root-intermediate0-ca -o jsonpath='{.data.ca\.crt}' | base64 --decode  > /tmp/intermediate0_ca.crt
kubectl get secret -n kube-system root-intermediate0-ca -o jsonpath='{.data.tls\.crt}' | base64 --decode  > /tmp/intermediate0_ca_tls.crt

kubectl get secret -n monitoring cm-prometheus-server-tls -o jsonpath='{.data.ca\.crt}' | base64 --decode  > /tmp/prometheus-server_ca.crt
kubectl get secret -n monitoring cm-prometheus-server-tls -o jsonpath='{.data.tls\.crt}' | base64 --decode  > /tmp/prometheus-server_ca_tls.crt



# все ca.crt в цепочке должны быть одинаковые.
cat /tmp/root_ca.crt && echo "//////" && cat /tmp/root_ca_tls.crt
# prometheus-server_ca_tls.cr накапливает tls.crt родителей кроме /tmp/root_ca_tls.crt
cat /tmp/intermediate0_ca_tls.crt && echo "//////" && cat /tmp/prometheus-server_ca_tls.crt
# ВАЖНО! если root_ca самоподписан, то он не добавляется в цепочку tls.crt и в таком Certificate.root-ca Issuer = Subject
openssl x509 -in /tmp/root_ca_tls.crt -text -noout
# цепочка это связь Issuer -> Subject -> Issuer -> Subject ...
openssl x509 -in /tmp/intermediate0_ca.crt -text -noout && echo "//////" && openssl x509 -in /tmp/prometheus-server_ca.crt -text -noout


openssl x509 -in $(kubectl get secret/cm-vault-tls -n secrets -o jsonpath='{.data.tls\.crt}' | base64 --decode) -text -noout

```