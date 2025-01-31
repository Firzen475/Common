


```shell





curl --cacert /mnt/etcd/ca_etcd.pem --cert /mnt/etcd/client.pem --key /mnt/etcd/client-key.pem -L https://192.168.2.10:2379/v3/kv/put -X POST -d '{"key": "dGVzdDE=", "value": "MQ=="}' -vvv
curl --cacert /mnt/etcd/ca_etcd.pem --cert /mnt/etcd/client.pem --key /mnt/etcd/client-key.pem -L https://192.168.2.11:2379/v3/kv/put -X POST -d '{"key": "dGVzdDI=", "value": "Mg=="}' -vvv


curl --cacert /mnt/etcd/ca_etcd.pem --cert /mnt/etcd/client.pem --key /mnt/etcd/client-key.pem -L https://192.168.2.10:2379/v3/kv/put -X POST -d '{"key": "test1", "value": "1"}' 
curl --cacert /mnt/etcd/ca_etcd.pem --cert /mnt/etcd/client.pem --key /mnt/etcd/client-key.pem -L https://192.168.2.11:2379/v3/kv/put -X POST -d '{"key": "test2", "value": "2"}' 
curl --cacert /mnt/etcd/ca_etcd.pem --cert /mnt/etcd/client.pem --key /mnt/etcd/client-key.pem -L https://192.168.2.10:2379/v3/kv/range -X POST -d '{"key": "dGVzdDI="}' 
curl --cacert /mnt/etcd/ca_etcd.pem --cert /mnt/etcd/client.pem --key /mnt/etcd/client-key.pem -L https://192.168.2.11:2379/v3/kv/range -X POST -d '{"key": "dGVzdDE="}' 

etcdctl --cacert="/mnt/etcd/ca_etcd.pem" --cert="/mnt/etcd/client.pem" --key="/mnt/etcd/client-key.pem" --endpoints="https://192.168.2.2:2381" get foo



etcdctl endpoint health --cacert="/mnt/swarm/etcd/ca_etcd.pem" --cert="/mnt/swarm/etcd/client.pem" --key="/mnt/swarm/etcd/client-key.pem" --endpoints="https://192.168.2.2:2381"




# список всех ключей
etcdctl --cacert="/etc/ssl/etcd/ca_etcd.pem" --cert="/etc/ssl/etcd/client.pem" --key="/etc/ssl/etcd/client-key.pem" --endpoints="https://192.168.2.2:2381" get / --prefix --keys-only


curl --cacert /etc/ssl/etcd/ca_etcd.pem --cert /etc/ssl/etcd/client.pem --key /etc/ssl/etcd/client-key.pem -L https://192.168.2.2:2381/readyz?verbose

```