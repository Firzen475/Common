

```shell

kubectl exec -it -n storage            redis-node-0 -- bash

redis-cli -h 127.0.0.1 -p 26379 --user gitlab -a fe75x1jd --tls --cacert /opt/bitnami/redis/certs/ca.crt

redis-cli -h 192.170.1.200 -p 6379 --user gitlab -a fe75x1jd --tls --cacert /opt/bitnami/redis/certs/ca.crt

redis-cli -h 127.0.0.1 -p 26379 --user admin -a 8vwdw6c0 --tls --cacert /opt/bitnami/redis/certs/ca.crt sentinel get-master-addr-by-name master

```