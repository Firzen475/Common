
```shell
# control01
watch kubectl get sc,pvc,pv,volumeattachments -A -o wide
# control01
watch kubectl get secretstores,externalsecrets,clustersecretstores,clusterexternalsecrets -A -o wide
# control01
watch "kubectl get issuers,clusterissuers,certificates,bundles,secrets,cm -A -o wide | grep -v helm | grep -v calico-system | grep  -v kube-system | grep  -v secrets "
# control02
watch "kubectl get rc,ingress,services,node -A | grep -v calico-system | grep  -v kube-system | grep  -v monitoring"
# control03
watch "kubectl get pods -A -o wide | grep -v calico-system | grep  -v kube-system | grep -v monitoring"

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



    svc:53 {
        errors
        log
        health {
            lameduck 5s
        }
        ready
        kubernetes . in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough
            ttl 30
        }
        forward . 8.8.8.8
        cache 30
        loop
        reload
        loadbalance
    }
    .:53 {
        errors
        log
        health {
            lameduck 5s
        }
        ready
        template IN A fzen.pro {
            match "(^[\w\-_]*[.]|^.*[.]pages[.])fzen[.]pro[.]$"
            answer "{{ .Name }}  60  IN  A  192.168.2.2"
            fallthrough
        }
        kubernetes svc cluster.local fzen.pro in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough svc cluster.local fzen.pro in-addr.arpa ip6.arpa
            ttl 30
        }
        forward . /etc/resolv.conf
        prometheus :9153
        cache 30
        loop
        reload
        loadbalance
    }


  Corefile: |
    svc:53 {
        errors
        log
        health {
            lameduck 5s
        }
        ready
        kubernetes . in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough
            ttl 30
        }
        forward . 8.8.8.8
        cache 30
        loop
        reload
        loadbalance
    }
    .:53 {
        errors
        log
        health {
            lameduck 5s
        }
        ready
        kubernetes fzen.pro in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough fzen.pro in-addr.arpa ip6.arpa
            ttl 30
        }
        forward . 192.168.2.1
        prometheus :9153
        cache 30
        loop
        reload
        loadbalance
    }



```

