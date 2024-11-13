Снимать с сервиса.
endpoint http :9153/metrics


| Метрика                                                      | Важность | Описание                                                                                                     | Параметры |
|:-------------------------------------------------------------|:---------|--------------------------------------------------------------------------------------------------------------|-----------|
| coredns_build_info                                           | 10       | A metric with a constant '1' value labeled by version, revision, and goversion from which CoreDNS was built. | ---       | 
| coredns_cache_entries                                        | 10       | The number of elements in the cache.                                                                         | ---       | 
| coredns_cache_misses_total                                   | 10       | The count of cache misses. Deprecated, derive misses from cache hits/requests counters.                      | ---       | 
| coredns_cache_requests_total                                 | 10       | The count of cache requests.                                                                                 | ---       | 
| coredns_dns_request_duration_seconds                         | 10       | Histogram of the time (in seconds) each request took per zone.                                               | ---       | 
| coredns_dns_request_size_bytes                               | 10       | Size of the EDNS0 UDP buffer in bytes (64K for TCP) per zone and protocol.                                   | ---       | 
| coredns_dns_requests_total                                   | 10       | Counter of DNS requests made per zone, protocol and family.                                                  | ---       | 
| coredns_dns_response_size_bytes                              | 10       | Size of the returned response in bytes.                                                                      | ---       | 
| coredns_dns_responses_total                                  | 10       | Counter of response status codes.                                                                            | ---       | 
| coredns_forward_healthcheck_broken_total                     | 10       | Counter of the number of complete failures of the healthchecks.                                              | ---       | 
| coredns_forward_max_concurrent_rejects_total                 | 10       | Counter of the number of queries rejected because the concurrent queries were at maximum.                    | ---       | 
| coredns_health_request_duration_seconds                      | 10       | Histogram of the time (in seconds) each request took.                                                        | ---       | 
| coredns_health_request_failures_total                        | 10       | The number of times the health check failed.                                                                 | ---       | 
| coredns_hosts_reload_timestamp_seconds                       | 10       | The timestamp of the last reload of hosts file.                                                              | ---       | 
| coredns_kubernetes_dns_programming_duration_seconds          | 10       | Histogram of the time (in seconds) it took to program a dns instance.                                        | ---       | 
| coredns_kubernetes_rest_client_rate_limiter_duration_seconds | 10       | Client side rate limiter latency in seconds. Broken down by verb and host.                                   | ---       | 
| coredns_kubernetes_rest_client_request_duration_seconds      | 10       | Request latency in seconds. Broken down by verb and host.                                                    | ---       | 
| coredns_kubernetes_rest_client_requests_total                | 10       | Number of HTTP requests, partitioned by status code, method, and host.                                       | ---       | 
| coredns_local_localhost_requests_total                       | 10       | Counter of localhost.<domain> requests.                                                                      | ---       | 
| coredns_panics_total                                         | 10       | A metrics that counts the number of panics.                                                                  | ---       | 
| coredns_plugin_enabled                                       | 10       | A metric that indicates whether a plugin is enabled on per server and zone basis.                            | ---       | 
| coredns_proxy_conn_cache_misses_total                        | 10       | Counter of connection cache misses per upstream and protocol.                                                | ---       | 
| coredns_proxy_request_duration_seconds                       | 10       | Histogram of the time each request took.                                                                     | ---       |
| coredns_reload_failed_total                                  | 10       | Counter of the number of failed reload attempts.                                                             | ---       |
| process_cpu_seconds_total                                    | 10       | Total user and system CPU time spent in seconds.                                                             | ---       |
| process_max_fds                                              | 10       | Maximum number of open file descriptors.                                                                     | ---       |
| process_open_fds                                             | 10       | Number of open file descriptors.                                                                             | ---       |
| process_resident_memory_bytes                                | 10       | Resident memory size in bytes.                                                                               | ---       |
| process_start_time_seconds                                   | 10       | Start time of the process since unix epoch in seconds.                                                       | ---       |
| process_virtual_memory_bytes                                 | 10       | Virtual memory size in bytes.                                                                                | ---       |
| process_virtual_memory_max_bytes                             | 10       | Maximum amount of virtual memory available in bytes.                                                         | ---       |






| Метрика                          | Важность | Описание                                                           | Параметры |
|:---------------------------------|:---------|--------------------------------------------------------------------|-----------|
| go_gc_duration_seconds           | 10       | A summary of the pause duration of garbage collection cycles.      | ---       |
| go_goroutines                    | 10       | Number of goroutines that currently exist.                         | ---       |
| go_info                          | 10       | Information about the Go environment.                              | ---       |
| go_memstats_alloc_bytes          | 10       | Number of bytes allocated and still in use.                        | ---       |
| go_memstats_alloc_bytes_total    | 10       | Total number of bytes allocated, even if freed.                    | ---       |
| go_memstats_buck_hash_sys_bytes  | 10       | Number of bytes used by the profiling bucket hash table.           | ---       |
| go_memstats_frees_total          | 10       | Total number of frees.                                             | ---       |
| go_memstats_gc_sys_bytes         | 10       | Number of bytes used for garbage collection system metadata.       | ---       |
| go_memstats_heap_alloc_bytes     | 10       | Number of heap bytes allocated and still in use.                   | ---       |
| go_memstats_heap_idle_bytes      | 10       | Number of heap bytes waiting to be used.                           | ---       |
| go_memstats_heap_inuse_bytes     | 10       | Number of heap bytes that are in use.                              | ---       |
| go_memstats_heap_objects         | 10       | Number of allocated objects.                                       | ---       |
| go_memstats_heap_released_bytes  | 10       | Number of heap bytes released to OS.                               | ---       |
| go_memstats_heap_sys_bytes       | 10       | Number of heap bytes obtained from system.                         | ---       |
| go_memstats_last_gc_time_seconds | 10       | Number of seconds since 1970 of last garbage collection.           | ---       |
| go_memstats_lookups_total        | 10       | Total number of pointer lookups.                                   | ---       |
| go_memstats_mallocs_total        | 10       | Total number of mallocs.                                           | ---       |
| go_memstats_mcache_inuse_bytes   | 10       | Number of bytes in use by mcache structures.                       | ---       |
| go_memstats_mcache_sys_bytes     | 10       | Number of bytes used for mcache structures obtained from system.   | ---       |
| go_memstats_mspan_inuse_bytes    | 10       | Number of bytes in use by mspan structures.                        | ---       |
| go_memstats_mspan_sys_bytes      | 10       | Number of bytes used for mspan structures obtained from system.    | ---       |
| go_memstats_next_gc_bytes        | 10       | Number of heap bytes when next garbage collection will take place. | ---       |
| go_memstats_other_sys_bytes      | 10       | Number of bytes used for other system allocations.                 | ---       |
| go_memstats_stack_inuse_bytes    | 10       | Number of bytes in use by the stack allocator.                     | ---       |
| go_memstats_stack_sys_bytes      | 10       | Number of bytes obtained from system for stack allocator.          | ---       |
| go_memstats_sys_bytes            | 10       | Number of bytes obtained from system.                              | ---       |
| go_threads                       | 10       | Number of OS threads created.                                      | ---       |


