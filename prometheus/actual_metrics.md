# Заметки
1) Нужно следить за источниками метрик. Например kubelet/metrics/cadvisor и kubelet/metrics/resource имеют container_cpu_usage_seconds_total и это задвоит результат.

# CPU
## container_cpu_usage_seconds_total 
Источник: kubelet/metrics/cadvisor, kubelet/metrics/resource
Описание: использование CPU контейнеров внутри подов.  
Особенности:  
* Если в метрике отсутствует image и name, то это сумма по поду, не учитывая это, можно задублировать результаты!  
* В kubelet/metrics/resource сумма по контейнерам. Пример:
sum(rate(container_cpu_usage_seconds_total{job="_2_cadvisor", instance="control01",name!=""}[5m])) by (namespace,pod)
равно
sum(rate(container_cpu_usage_seconds_total{job="_3_kubelet_resource", instance="control01"}[5m])) by (namespace,pod)

| Label     | Description                            | Example                                                                                                                                                                                             | 
|:----------|:---------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id        | ...                                    | "/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-pod1467edaf_db96_4e51_bf7e_adc3d001d3d2.slice/cri-containerd-744489728f6b1162bd69616c75dd2894f7399fa3cc47591fcbf00cb839c3ed54.scope" |
| image     | Название образа контейнера             | "registry.k8s.io/pause:3.8"                                                                                                                                                                         |
| instance  | Нода                                   | "dev01"                                                                                                                                                                                             |
| job       | Название источника метрик в Prometheus | "_2_cadvisor"                                                                                                                                                                                       |
| name      | Имя контейнера                         | "744489728f6b1162bd69616c75dd2894f7399fa3cc47591fcbf00cb839c3ed54"                                                                                                                                  |
| namespace | Пространство имён                      | "monitoring"                                                                                                                                                                                        |
| pod       | под                                    | "prometheus-prometheus-node-exporter-4r5hc"                                                                                                                                                         |

## pod_cpu_usage_seconds_total
Источник: kubelet/metrics/resource
Описание: использование CPU подов.
Особенности:
* Метрики более высокого уровня можно получить из метрик более низкого, но с дополнительными фильтрами. В примере метрика низкого уровня уже имеет агрегацию по поду, поэтому дублирование исключается выборкой image!="" или image="".
sum(rate(container_cpu_usage_seconds_total{job="_2_cadvisor",pod="calico-node-qn4ww",image!=""}[5m])) by (namespace,pod)
равно
sum(rate(container_cpu_usage_seconds_total{job="_2_cadvisor",pod="calico-node-qn4ww",image=""}[5m])) by (namespace,pod)
равно
sum(rate(pod_cpu_usage_seconds_total{pod="calico-node-qn4ww"}[5m])) by (namespace,pod)

| Label     | Description                            | Example               | 
|:----------|:---------------------------------------|-----------------------|
| instance  | Нода                                   | "dev01"               |
| job       | Название источника метрик в Prometheus | "_3_kubelet_resource" |
| namespace | Пространство имён                      | "monitoring"          |
| pod       | под                                    | "calico-node-qn4ww"   |

## node_cpu_usage_seconds_total / node_cpu_seconds_total
Источник: kubelet/metrics/resource / node-exporter/metrics/
Описание: использование CPU нод. node_cpu_seconds_total возвращает большее значение, вероятно потому, что учитывает  
все потребляемые ресурсы, а не только ресурсы kuber.
Особенности:
* node_cpu_seconds_total лучше тем, что есть разбивка по режимам процессора.

| Label    | Description                            | Example               | 
|:---------|:---------------------------------------|-----------------------|
| instance | Нода                                   | "dev01"               |
| job      | Название источника метрик в Prometheus | "_3_kubelet_resource" |

| Label     | Description                | Example                                                               | 
|:----------|:---------------------------|-----------------------------------------------------------------------|
| container | Всегда источник метрики    | "kube-rbac-proxy"                                                     |
| cpu       | Ядро процессора            | "0","1"...                                                            |
| endpoint  | Всегда название эндпоинта  | "http-metrics"                                                        |
| instance  | Всегда эндпоинт метрики    | "192.168.2.10:9100"                                                   |
| job       | Всегда название пода       | "prometheus-prometheus-node-exporter"                                 |
| mode      | Режим процессора как в top | "idle", "iowait", "irq", "nice", "softirq", "steal", "system", "user" |
| namespace | Всегда "monitoring"        | "monitoring"                                                          |
| node      | Нода                       | "dev01"                                                               |
| pod       | Всегда под экспортёра      | "prometheus-prometheus-node-exporter-8jnck"                           |
| service   | Всегда сервис экспортёра   | "prometheus-prometheus-node-exporter"                                 |

## container_spec_cpu_quota
Источник: kubelet/metrics/cadvisor
Описание: Лимит использования процессора для контейнера.
Особенности: 
1) container_spec_cpu_period - такт процессора. Обычно 100000.
2) Функция возвращает значение от 0 до 1 от использованных лимитов. Из-за внутреннего соединения,  
в списке будут только контейнеры, у которых настроена квота.
sum(rate(container_cpu_usage_seconds_total{image!="", container!=""}[5m])) by (pod, container) / 
sum(container_spec_cpu_quota{image!="", container!=""} / container_spec_cpu_period{image!="", container!=""}) by (pod, container)

| Label     | Description                                      | Example                                                            | 
|:----------|:-------------------------------------------------|--------------------------------------------------------------------|
| container | Название контейнера, на который выделены ресурсы | "dnsutils"                                                         |
| id        | ...                                              | "/kubepods.slice/kubepods-burstable.slice/..."                     |
| image     | Образ контейнера                                 | "registry.k8s.io/e2e-test-images/agnhost:2.39"                     |
| instance  | Нода                                             | "dev01"                                                            |
| job       | Название источника метрик в Prometheus           | "_2_cadvisor"                                                      |
| name      | Имя контейнера                                   | "cf688e555c60226914f211a8eea4f775e0138496a52683e557b7d673d5458dc1" |
| namespace | Пространство имён                                | "monitoring"                                                       |
| pod       | под                                              | "dnsutils-544b6fbc94-lj557"                                        |


## machine_cpu_cores и процент загрузки
Источник: kubelet/metrics/cadvisor
Описание: Количество ядер на ноде.
Особенности:
1) Пример загрузки нод через cadvisor.container_cpu_usage_seconds_total:
   sum (rate (container_cpu_usage_seconds_total{id="/"}[3m])) by (instance) / sum (machine_cpu_cores{}) by (instance) * 100
2) Пример загрузки нод через node-exporter.node_cpu_seconds_total
   sum(1 - rate(node_cpu_seconds_total{mode="idle"}[3m])) by (node) * 10


| Label       | Description                                      | Example                                | 
|:------------|:-------------------------------------------------|----------------------------------------|
| boot_id     | ---                                              | "272b8f72-4846-419d-a781-55628cd03198" |
| instance    | Нода                                             | "dev01"                                |
| job         | Название источника метрик в Prometheus           | "_2_cadvisor"                          |
| machine_id  | ---                                              | "0dcd6ee6484a4438b15a93de14a82db8"     |
| system_uuid | Название контейнера, на который выделены ресурсы | "1db84d56-2be1-6267-35ce-6a3a3163bb9e" |


## memory









