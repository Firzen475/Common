



## Вариант prometheus-adapter
Забирает управление apiservice.v1beta1.metrics.k8s.io  
Настройки для работы:
* kubectl top
* hpa (v1beta1.metrics.k8s.io)

### Через kubelet
kubelet.cadvisor => prometheus-adapter.rules.resource => v1beta1.metrics.k8s.io => kubectl top | hpa  
prometheus-adapter.yaml
```yaml
rules:
  default: false
  ...
  resource:
    "cpu":
      "containerLabel": "container"
      "containerQuery": |
        sum by (<<.GroupBy>>) (
          irate (
              container_cpu_usage_seconds_total{<<.LabelMatchers>>,container!="",pod!=""}[120s]
          )
        )
      "nodeQuery":  sum(rate(container_cpu_usage_seconds_total{<<.LabelMatchers>>, id='/'}[120s])) by (<<.GroupBy>>)
      resources:
        overrides:
          instance:
            resource: node
          namespace:
            resource: namespace
          pod:
            resource: pod
    "memory":
      "containerLabel": "container"
      "containerQuery": |
        sum by (<<.GroupBy>>) (
          container_memory_working_set_bytes{<<.LabelMatchers>>,container!="",pod!=""}
        )
      nodeQuery: sum(container_memory_working_set_bytes{<<.LabelMatchers>>,id='/'}) by (<<.GroupBy>>)
      "resources":
        "overrides":
          "instance":
            "resource": "node"
          "namespace":
            "resource": "namespace"
          "pod":
            "resource": "pod"
    "window": "5m"
  ...
```
### Через node-exporter
node-exporter && kube-state-metrics => prometheus (с добавлением меток) => prometheus.recording_rules (создание своих метрик) => prometheus-adapter.rules.resource => v1beta1.metrics.k8s.io => kubectl top | hpa

prometheus.yml
```yaml
...
- job_name: _4_prometheus-node-exporter
  kubernetes_sd_configs:
    # Можно брать со всех нод
    - role: endpoints
  honor_timestamps: true
  scrape_interval: 30s
  scrape_timeout: 10s
  metrics_path: /metrics
  # Включен RBAC-proxy
  scheme: https
  tls_config:
    ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    insecure_skip_verify: true
  bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
  follow_redirects: true
  relabel_configs:
    # Отборы
    - source_labels: [job]
      separator: ;
      regex: (.*)
      target_label: __tmp_prometheus_job_name
      replacement: $1
      action: replace
    - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
      separator: ;
      regex: (prometheus-node-exporter);true
      replacement: $1
      action: keep
    - source_labels: [__meta_kubernetes_endpoint_port_name]
      separator: ;
      regex: metrics
      replacement: $1
      action: keep
    # Добавление дополнительных меток
    - source_labels: [__meta_kubernetes_endpoint_node_name]
      separator: ;
      regex: (.*)
      target_label: node
      replacement: ${1}
      action: replace
    - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
      separator: ;
      regex: Pod;(.*)
      target_label: pod
      replacement: ${1}
      action: replace
    - source_labels: [__meta_kubernetes_namespace]
      separator: ;
      regex: (.*)
      target_label: namespace
      replacement: $1
      action: replace
    - source_labels: [__meta_kubernetes_service_name]
      separator: ;
      regex: (.*)
      target_label: service
      replacement: $1
      action: replace
    - source_labels: [__meta_kubernetes_pod_name]
      separator: ;
      regex: (.*)
      target_label: pod
      replacement: $1
      action: replace
    - source_labels: [__meta_kubernetes_pod_container_name]
      separator: ;
      regex: (.*)
      target_label: container
      replacement: $1
      action: replace
    - source_labels: [__meta_kubernetes_service_name]
      separator: ;
      regex: (.*)
      target_label: job
      replacement: ${1}
      action: replace
    - source_labels: [__meta_kubernetes_service_label_jobLabel]
      separator: ;
      regex: (.+)
      target_label: job
      replacement: ${1}
      action: replace
    # Служебные подстановки
    - separator: ;
      regex: (.*)
      target_label: endpoint
      replacement: http-metrics
      action: replace
    - source_labels: [__address__]
      separator: ;
      regex: (.*)
      modulus: 1
      target_label: __tmp_hash
      replacement: $1
      action: hashmod
    - source_labels: [__tmp_hash]
      separator: ;
      regex: "0"
      replacement: $1
      action: keep

...
```
recording_rules.yml
```yaml
groups:
  - name: "v1beta1.metrics.k8s.io"
    rules:
      - expr: |
          max(label_replace(kube_pod_info, "pod", "$1", "pod", "(.*)")) by (node, namespace, pod)
        record: 'node_namespace_pod:kube_pod_info:'
```
prometheus-adapter.yaml
```yaml
rules:
  default: false
  ...
  resource:
    "cpu":
      "containerLabel": "container"
      "containerQuery": |
        sum by (<<.GroupBy>>) (
          irate (
              container_cpu_usage_seconds_total{<<.LabelMatchers>>,container!="",pod!=""}[120s]
          )
        )
      "nodeQuery":  |
        sum by (<<.GroupBy>>) (
          1 - irate(
            node_cpu_seconds_total{mode="idle"}[120s]
          )
          * on(namespace, pod) group_left(node) (
            node_namespace_pod:kube_pod_info:{<<.LabelMatchers>>}
          )
        )
        or sum by (<<.GroupBy>>) (
          1 - irate(
            windows_cpu_time_total{mode="idle", job="windows-exporter",<<.LabelMatchers>>}[4m]
          )
        )
      resources:
        overrides:
          node:
            resource: node
          namespace:
            resource: namespace
          pod:
            resource: pod
    "memory":
      "containerLabel": "container"
      "containerQuery": |
        sum by (<<.GroupBy>>) (
          container_memory_working_set_bytes{<<.LabelMatchers>>,container!="",pod!=""}
        )
      nodeQuery: |
        sum by (<<.GroupBy>>) (
          node_memory_MemTotal_bytes{<<.LabelMatchers>>}
          -
          node_memory_MemAvailable_bytes{<<.LabelMatchers>>}
        )
        or sum by (<<.GroupBy>>) (
          windows_cs_physical_memory_bytes{job="windows-exporter",<<.LabelMatchers>>}
          -
          windows_memory_available_bytes{job="windows-exporter",<<.LabelMatchers>>}
        )
      "resources":
        "overrides":
          "node":
            "resource": "node"
          "namespace":
            "resource": "namespace"
          "pod":
            "resource": "pod"
    "window": "5m"
  ...
```



## Вариант metrics-server
Получает данные с kubelet и агрегирует их для:
* kubectl top
* hpa

## Проверка работы 
```shell
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes | jq && echo "////////" && kubectl get --raw /apis/metrics.k8s.io/v1beta1/pods | jq
```
```json
{
  "kind": "NodeMetricsList",
  "apiVersion": "metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "metadata": {
        "name": "control01",
        "creationTimestamp": "2024-11-22T15:27:36Z",
        "labels": {
          "beta.kubernetes.io/arch": "amd64",
          "beta.kubernetes.io/os": "linux",
          "kubernetes.io/arch": "amd64",
          "kubernetes.io/hostname": "control01",
          "kubernetes.io/os": "linux",
          "node-role.kubernetes.io/control-plane": "",
          "node.kubernetes.io/exclude-from-external-load-balancers": ""
        }
      },
      "timestamp": "2024-11-22T15:27:26Z",
      "window": "20.079s",
      "usage": {
        "cpu": "504009163n",
        "memory": "2010776Ki"
      }
    },
    ...
  ]
}
////////
{
  "kind": "PodMetricsList",
  "apiVersion": "metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "metadata": {
        "name": "calico-apiserver-56f77b7d54-2vtz4",
        "namespace": "calico-apiserver",
        "creationTimestamp": "2024-11-22T15:30:54Z",
        "labels": {
          "apiserver": "true",
          "app.kubernetes.io/name": "calico-apiserver",
          "k8s-app": "calico-apiserver",
          "pod-template-hash": "56f77b7d54"
        }
      },
      "timestamp": "2024-11-22T15:30:41Z",
      "window": "16.001s",
      "containers": [
        {
          "name": "calico-apiserver",
          "usage": {
            "cpu": "5735579n",
            "memory": "54844Ki"
          }
        }
      ]
    },
    ...
  ]
}



```