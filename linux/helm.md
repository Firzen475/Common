
```shell
helm repo update
helm repo list -A
helm search repo
helm repo add NAME URL --debug \
      --force-update --insecure-skip-tls-verify \
      --ca-file=/tmp/ca.crt --cert-file=/tmp/tls.crt --key-file=/tmp/tls.key
      --kubeconfig=$KUBECONFIG --kube-context=$KUBE_CONTEX

helm list -A
helm get values -n NS  NAME
helm upgrade $RELEASE_NAME $CI_PROJECT_NAME/$CI_PROJECT_NAME -n $NS \
      --dry-run=server \
      --force --wait --install --reset-then-reuse-values --debug  \
      --set image=registry.fzen.pro/dev/flask-example-1:$IMAGE_TAG \
      --set ingress.ingressClassName=$INGRESS_CLASS_NAME \
      --set host=$HOST \
      --kubeconfig=$KUBECONFIG --kube-context=$KUBE_CONTEX \
      -f /tmp/values.yaml
helm uninstall $RELEASE_NAME -n $NS \
      --dry-run \
      --ignore-not-found --debug \
      --kubeconfig=$KUBECONFIG --kube-context=$KUBE_CONTEX
    
```