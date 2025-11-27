
# Редактирование настроек
```shell
KUBE_EDITOR="nano" kubectl edit -n kube-system cm/coredns
```
```yaml
data:
  Corefile: |
      svc:53 {
          errors
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
          health {
              lameduck 5s
          }
          ready
          template IN A fzen.pro {
              match "(^[\w\-_]*[.]|^.*[.]pages[.])fzen[.]pro[.]$"
              answer "{{ .Name }}  60  IN  A  192.168.2.2"
              fallthrough
          }
          kubernetes .svc fzen.pro in-addr.arpa ip6.arpa {
              pods insecure
              fallthrough in-addr.arpa ip6.arpa
              ttl 30
          }
          forward . /etc/resolv.conf
          prometheus :9153
          cache 30
          loop
          reload
          loadbalance
      }
```


```shell
kubectl rollout restart -n kube-system deployment/coredns

kubectl logs -f -n kube-system --selector k8s-app=kube-dns
```
