```shell

# 

kubectl exec -it metrics-scraper -n monitoring -- sh
# получаем метрики изпод контейнера  подключенным токеном авторизации
curl -k -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" https://192.170.0.10:6443/metrics

kubectl logs -f -n kube-system deployment/metrics-server
kubectl logs -f -n monitoring deployment/prometheus-adapter


kubectl get  apiservice -A
kubectl describe apiservice v1beta1.custom.metrics.k8s.io && kubectl describe apiservice v1beta1.metrics.k8s.io


kubectl exec -it metrics-scraper -n monitoring -- sh
curl -k -H "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" https://192.168.2.10:9100/metrics | grep "# HELP" | awk '{out="| "$3" | --- | "; for(i=3;i<=NF;i++){out=out" "$i}; print out" | --- |"}'


watch "echo '/////////////hpa//////////////' && kubectl get hpa -A && \
echo '/////////////my_custom_metric//////////////' && kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1
echo '/////////////target//////////////' && \
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/testing/pods/%2A/my_custom_metric111?labelSelector=run%3Ddnsutils"

kubectl get hpa -A
kubectl describe hpa -n testing dnsutils


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


```