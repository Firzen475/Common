
```shell
kubectl get componentstatus
kubectl get tigerastatus

kubectl get\delete pod --selector=[label]=[value] -A
kubectl get\delete pod --field-selector status.phase=Failed -A

# get data * - all
kubectl get persistentvolume -o jsonpath={.items[*].status.phase}

# run cronjob manual

kubectl create job --from=cronjob/backup-storage backup -n storage

```