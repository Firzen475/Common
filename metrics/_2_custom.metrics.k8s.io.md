
## Заметки
1) Чтобы сделать выборку по меткам из серии, нужно добавить <<.Series>>{<<.LabelMatchers>>}  
Тогда можно отфильтровать полученные результаты ?metricLabelSelector=namespace%3Dmonitoring
2) (<<.GroupBy>>) берёт все доступные метки из полученной метрики, до применения к ним overrides. Пояснение:  
У метрики 2 метки - namespace и instance. Тогда:
```yaml
        overrides:
          namespace: { resource: "namespace" }
          instance: { resource: "node" }
```
URL будет /apis/custom.metrics.k8s.io/v1beta1/namespaces/[NS]/nodes/*/...  
Но (<<.GroupBy>>) = (namespace,instance)
3) Фильтры ?metricLabelSelector=[label]%3D[value] и ?metricLabelSelector=[label]+in+%28[value]%29  
Работают только при полном совпадении значения [value]  
4) API возвращает только одну запись из категории. Пояснение:  
Есть базовая метрика, возвращающая 5 записей для каждого namespace.  
При metricsQuery: '<<.Series>>{<<.LabelMatchers>>} и запросе /apis/custom.metrics.k8s.io/v1beta1/namespaces/%2A/metrics/custom-test-namespace-pod-instance  
В результате будет получено только одна (случайная?) запись из 5-ти, для этого namespace.  
Поэтому обязательно нужно из сгруппировать. metricsQuery: 'sum(<<.Series>>{<<.LabelMatchers>>}) by (namespace)'  
5) Фильтровать поды можно по меткам самих подов. ?labelSelector=app.kubernetes.io/name%3Dprometheus  
При использовании hpa c spec.metrics.type: Pods, запрос будет иметь вид:  
/apis/custom.metrics.k8s.io/v1beta1/namespaces/[NS]/pods/*/[spec.metrics.pods.metric.name]?labelSelector=run%3D[spec.scaleTargetRef.name]  
для выполнения условия селектора, в Deployment.spec нужно добавить
```yaml
  template:
    metadata:
      labels:
        run: [DeploymentName]
```
По сути селектор должен присутствовать в объекте, возвращаемом в выборке, не обязательно это должен быть под.

## Просмотр доступных кастомных метрик
```shell
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1 | jq
```
```json
{
  "kind": "APIResourceList",
  "apiVersion": "v1",
  "groupVersion": "custom.metrics.k8s.io/v1beta1",
  "resources": [
    ...
  ]
}
```
## Просмотр выборки, в которой есть только namespaces (namespaces/custom-test-namespace) c фильтром по namespace
```shell
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/*/metrics/custom-test-namespace?metricLabelSelector=namespace%3Dmonitoring | jq
```
## Просмотр выборки, для случайной метрики с фильтром по метке результирующего объекта
```shell
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/monitoring/pods/%2A/custom-test-namespace-pod?LabelSelector=app.kubernetes.io/name%3Dprometheus | jq
```


