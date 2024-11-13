Снимать с каждого ПОДА.
endpoint :10257/metrics

| Метрика                                                      | Важность | Описание                                                                                                                                                                                                                                                                      | Параметры |
|:-------------------------------------------------------------|:---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| aggregator_discovery_aggregation_count_total                 | 10       | Counter of number of times discovery was aggregated                                                                                                                                                                                                                           | ---       | 
| apiextensions_apiserver_validation_ratcheting_seconds        | 10       | Time for comparison of old to new for the purposes of CRDValidationRatcheting during an UPDATE in seconds.                                                                                                                                                                    | ---       | 
| apiserver_audit_event_total                                  | 10       | Counter of audit events generated and sent to the audit backend.                                                                                                                                                                                                              | ---       | 
| apiserver_audit_requests_rejected_total                      | 10       | Counter of apiserver requests rejected due to an error in audit logging backend.                                                                                                                                                                                              | ---       | 
| apiserver_cel_compilation_duration_seconds                   | 10       | CEL compilation time in seconds.                                                                                                                                                                                                                                              | ---       | 
| apiserver_cel_evaluation_duration_seconds                    | 10       | CEL evaluation time in seconds.                                                                                                                                                                                                                                               | ---       | 
| apiserver_client_certificate_expiration_seconds              | 10       | Distribution of the remaining lifetime on the certificate used to authenticate a request.                                                                                                                                                                                     | ---       | 
| apiserver_delegated_authn_request_duration_seconds           | 10       | Request latency in seconds. Broken down by status code.                                                                                                                                                                                                                       | ---       | 
| apiserver_delegated_authn_request_total                      | 10       | Number of HTTP requests partitioned by status code.                                                                                                                                                                                                                           | ---       | 
| apiserver_delegated_authz_request_duration_seconds           | 10       | Request latency in seconds. Broken down by status code.                                                                                                                                                                                                                       | ---       | 
| apiserver_delegated_authz_request_total                      | 10       | Number of HTTP requests partitioned by status code.                                                                                                                                                                                                                           | ---       | 
| apiserver_envelope_encryption_dek_cache_fill_percent         | 10       | Percent of the cache slots currently occupied by cached DEKs.                                                                                                                                                                                                                 | ---       | 
| apiserver_kube_aggregator_x509_insecure_sha1_total           | 10       | Counts the number of requests to servers with insecure SHA1 signatures in their serving certificate OR the number of connection failures due to the insecure SHA1 signatures (either/or, based on the runtime environment)                                                    | ---       | 
| apiserver_kube_aggregator_x509_missing_san_total             | 10       | Counts the number of requests to servers missing SAN extension in their serving certificate OR the number of connection failures due to the lack of x509 certificate SAN extension missing (either/or, based on the runtime environment)                                      | ---       | 
| apiserver_storage_data_key_generation_duration_seconds       | 10       | Latencies in seconds of data encryption key(DEK) generation operations.                                                                                                                                                                                                       | ---       | 
| apiserver_storage_data_key_generation_failures_total         | 10       | Total number of failed data encryption key(DEK) generation operations.                                                                                                                                                                                                        | ---       | 
| apiserver_storage_envelope_transformation_cache_misses_total | 10       | Total number of cache misses while accessing key decryption key(KEK).                                                                                                                                                                                                         | ---       | 
| apiserver_webhooks_x509_insecure_sha1_total                  | 10       | Counts the number of requests to servers with insecure SHA1 signatures in their serving certificate OR the number of connection failures due to the insecure SHA1 signatures (either/or, based on the runtime environment)                                                    | ---       | 
| apiserver_webhooks_x509_missing_san_total                    | 10       | Counts the number of requests to servers missing SAN extension in their serving certificate OR the number of connection failures due to the lack of x509 certificate SAN extension missing (either/or, based on the runtime environment)                                      | ---       | 
| authenticated_user_requests                                  | 10       | Counter of authenticated requests broken out by username.                                                                                                                                                                                                                     | ---       | 
| authentication_attempts                                      | 10       | Counter of authenticated attempts.                                                                                                                                                                                                                                            | ---       | 
| authentication_duration_seconds                              | 10       | Authentication duration in seconds broken out by result.                                                                                                                                                                                                                      | ---       | 
| authentication_token_cache_active_fetch_count                | 10       |                                                                                                                                                                                                                                                                               | ---       | 
| authentication_token_cache_fetch_total                       | 10       |                                                                                                                                                                                                                                                                               | ---       | 
| authentication_token_cache_request_duration_seconds          | 10       |                                                                                                                                                                                                                                                                               | ---       | 
| authentication_token_cache_request_total                     | 10       |                                                                                                                                                                                                                                                                               | ---       | 
| authorization_attempts_total                                 | 10       | Counter of authorization attempts broken down by result. It can be either 'allowed', 'denied', 'no-opinion' or 'error'.                                                                                                                                                       | ---       | 
| authorization_duration_seconds                               | 10       | Authorization duration in seconds broken out by result.                                                                                                                                                                                                                       | ---       | 
| cardinality_enforcement_unexpected_categorizations_total     | 10       | The count of unexpected categorizations during cardinality enforcement.                                                                                                                                                                                                       | ---       | 
| disabled_metrics_total                                       | 10       | The count of disabled metrics.                                                                                                                                                                                                                                                | ---       | 
| hidden_metrics_total                                         | 10       | The count of hidden metrics.                                                                                                                                                                                                                                                  | ---       | 
| kubernetes_build_info                                        | 10       | A metric with a constant '1' value labeled by major, minor, git version, git commit, git tree state, build date, Go version, and compiler from which Kubernetes was built, and platform on which it is running.                                                               | ---       |
| kubernetes_feature_enabled                                   | 10       | This metric records the data about the stage and enablement of a k8s feature.                                                                                                                                                                                                 | ---       |
| leader_election_master_status                                | 10       | Gauge of if the reporting system is master of the relevant lease, 0 indicates backup, 1 indicates master. 'name' is the string used to identify the lease. Please make sure to group by name.                                                                                 | ---       |
| node_collector_update_all_nodes_health_duration_seconds      | 10       | Duration in seconds for NodeController to update the health of all nodes.                                                                                                                                                                                                     | ---       |
| node_collector_update_node_health_duration_seconds           | 10       | Duration in seconds for NodeController to update the health of a single node.                                                                                                                                                                                                 | ---       |
| process_cpu_seconds_total                                    | 10       | Total user and system CPU time spent in seconds.                                                                                                                                                                                                                              | ---       |
| process_max_fds                                              | 10       | Maximum number of open file descriptors.                                                                                                                                                                                                                                      | ---       |
| process_open_fds                                             | 10       | Number of open file descriptors.                                                                                                                                                                                                                                              | ---       |
| process_resident_memory_bytes                                | 10       | Resident memory size in bytes.                                                                                                                                                                                                                                                | ---       |
| process_start_time_seconds                                   | 10       | Start time of the process since unix epoch in seconds.                                                                                                                                                                                                                        | ---       |
| process_virtual_memory_bytes                                 | 10       | Virtual memory size in bytes.                                                                                                                                                                                                                                                 | ---       |
| process_virtual_memory_max_bytes                             | 10       | Maximum amount of virtual memory available in bytes.                                                                                                                                                                                                                          | ---       |
| registered_metrics_total                                     | 10       | The count of registered metrics broken by stability level and deprecation version.                                                                                                                                                                                            | ---       |
| rest_client_exec_plugin_certificate_rotation_age             | 10       | Histogram of the number of seconds the last auth exec plugin client certificate lived before being rotated. If auth exec plugin client certificates are unused, histogram will contain no data.                                                                               | ---       |
| rest_client_exec_plugin_ttl_seconds                          | 10       | Gauge of the shortest TTL (time-to-live) of the client certificate(s) managed by the auth exec plugin. The value is in seconds until certificate expiry (negative if already expired). If auth exec plugins are unused or manage no TLS certificates, the value will be +INF. | ---       |
| rest_client_rate_limiter_duration_seconds                    | 10       | Client side rate limiter latency in seconds. Broken down by verb, and host.                                                                                                                                                                                                   | ---       |
| rest_client_request_duration_seconds                         | 10       | Request latency in seconds. Broken down by verb, and host.                                                                                                                                                                                                                    | ---       |
| rest_client_request_size_bytes                               | 10       | Request size in bytes. Broken down by verb and host.                                                                                                                                                                                                                          | ---       |
| rest_client_requests_total                                   | 10       | Number of HTTP requests, partitioned by status code, method, and host.                                                                                                                                                                                                        | ---       |
| rest_client_response_size_bytes                              | 10       | Response size in bytes. Broken down by verb and host.                                                                                                                                                                                                                         | ---       |
| rest_client_transport_cache_entries                          | 10       | Number of transport entries in the internal cache.                                                                                                                                                                                                                            | ---       |
| rest_client_transport_create_calls_total                     | 10       | Number of calls to get a new transport, partitioned by the result of the operation hit: obtained from the cache, miss: created and added to the cache, uncacheable: created and not cached                                                                                    | ---       |
| workqueue_adds_total                                         | 10       | Total number of adds handled by workqueue                                                                                                                                                                                                                                     | ---       |
| workqueue_depth                                              | 10       | Current depth of workqueue                                                                                                                                                                                                                                                    | ---       |
| workqueue_longest_running_processor_seconds                  | 10       | How many seconds has the longest running processor for workqueue been running.                                                                                                                                                                                                | ---       |
| workqueue_queue_duration_seconds                             | 10       | How long in seconds an item stays in workqueue before being requested.                                                                                                                                                                                                        | ---       |
| workqueue_retries_total                                      | 10       | Total number of retries handled by workqueue                                                                                                                                                                                                                                  | ---       |
| workqueue_unfinished_work_seconds                            | 10       | How many seconds of work has done that is in progress and hasn't been observed by work_duration. Large values indicate stuck threads. One can deduce the number of stuck threads by observing the rate at which this increases.                                               | ---       |
| workqueue_work_duration_seconds                              | 10       | How long in seconds processing an item from workqueue takes.                                                                                                                                                                                                                  | ---       |








| Метрика                                                           | Важность | Описание | Параметры |
|:------------------------------------------------------------------|:---------|----------|-----------|
| go_cgo_go_to_c_calls_calls_total                                  | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       | 
| go_cpu_classes_gc_mark_dedicated_cpu_seconds_total                | 10       |          | ---       | 
| go_cpu_classes_gc_mark_idle_cpu_seconds_total                     | 10       |          | ---       | 
| go_cpu_classes_gc_pause_cpu_seconds_total                         | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       | 
| go_cpu_classes_gc_total_cpu_seconds_total                         | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       | 
| go_cpu_classes_idle_cpu_seconds_total                             | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       | 
| go_cpu_classes_scavenge_assist_cpu_seconds_total                  | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       | 
| go_cpu_classes_scavenge_background_cpu_seconds_total              | 10       |          | ---       | 
| go_cpu_classes_scavenge_total_cpu_seconds_total                   | 10       |          | ---       | 
| go_cpu_classes_total_cpu_seconds_total                            | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       |
| go_cpu_classes_user_cpu_seconds_total                             | 10       |          | ---       | 
| go_cpu_classes_gc_mark_assist_cpu_seconds_total                   | 10       |          | ---       | 
| go_gc_cycles_automatic_gc_cycles_total                            | 10       |          | ---       | 
| go_gc_cycles_forced_gc_cycles_total                               | 10       |          | ---       | 
| go_gc_cycles_total_gc_cycles_total                                | 10       |          | ---       | 
| go_gc_duration_seconds                                            | 10       |          | ---       | 
| go_gc_gogc_percent                                                | 10       |          | ---       | 
| go_gc_gomemlimit_bytes                                            | 10       |          | ---       | 
| go_gc_heap_allocs_by_size_bytes                                   | 10       |          | ---       | 
| go_gc_heap_allocs_bytes_total                                     | 10       |          | ---       | 
| go_gc_heap_allocs_objects_total                                   | 10       |          | ---       | 
| go_gc_heap_frees_by_size_bytes                                    | 10       |          | ---       | 
| go_gc_heap_frees_bytes_total                                      | 10       |          | ---       | 
| go_gc_heap_frees_objects_total                                    | 10       |          | ---       | 
| go_gc_heap_goal_bytes                                             | 10       |          | ---       | 
| go_gc_heap_live_bytes                                             | 10       |          | ---       | 
| go_gc_heap_objects_objects                                        | 10       |          | ---       | 
| go_gc_heap_tiny_allocs_objects_total                              | 10       |          | ---       | 
| go_gc_limiter_last_enabled_gc_cycle                               | 10       |          | ---       | 
| go_gc_pauses_seconds                                              | 10       |          | ---       | 
| go_gc_scan_globals_bytes                                          | 10       |          | ---       | 
| go_gc_scan_heap_bytes                                             | 10       |          | ---       | 
| go_gc_scan_stack_bytes                                            | 10       |          | ---       | 
| go_gc_scan_total_bytes                                            | 10       |          | ---       | 
| go_gc_stack_starting_size_bytes                                   | 10       |          | ---       | 
| go_godebug_non_default_behavior_execerrdot_events_total           | 10       |          | ---       | 
| go_godebug_non_default_behavior_gocachehash_events_total          | 10       |          | ---       | 
| go_godebug_non_default_behavior_gocachetest_events_total          | 10       |          | ---       | 
| go_godebug_non_default_behavior_gocacheverify_events_total        | 10       |          | ---       | 
| go_godebug_non_default_behavior_gotypesalias_events_total         | 10       |          | ---       | 
| go_godebug_non_default_behavior_http2client_events_total          | 10       |          | ---       | 
| go_godebug_non_default_behavior_http2server_events_total          | 10       |          | ---       | 
| go_godebug_non_default_behavior_httplaxcontentlength_events_total | 10       |          | ---       | 
| go_godebug_non_default_behavior_httpmuxgo121_events_total         | 10       |          | ---       | 
| go_godebug_non_default_behavior_installgoroot_events_total        | 10       |          | ---       | 
| go_godebug_non_default_behavior_jstmpllitinterp_events_total      | 10       |          | ---       | 
| go_godebug_non_default_behavior_multipartmaxheaders_events_total  | 10       |          | ---       | 
| go_godebug_non_default_behavior_multipartmaxparts_events_total    | 10       |          | ---       | 
| go_godebug_non_default_behavior_multipathtcp_events_total         | 10       |          | ---       | 
| go_godebug_non_default_behavior_netedns0_events_total             | 10       |          | ---       | 
| go_godebug_non_default_behavior_panicnil_events_total             | 10       |          | ---       | 
| go_godebug_non_default_behavior_randautoseed_events_total         | 10       |          | ---       | 
| go_godebug_non_default_behavior_tarinsecurepath_events_total      | 10       |          | ---       | 
| go_godebug_non_default_behavior_tls10server_events_total          | 10       |          | ---       | 
| go_godebug_non_default_behavior_tlsmaxrsasize_events_total        | 10       |          | ---       | 
| go_godebug_non_default_behavior_tlsrsakex_events_total            | 10       |          | ---       | 
| go_godebug_non_default_behavior_tlsunsafeekm_events_total         | 10       |          | ---       | 
| go_godebug_non_default_behavior_x509sha1_events_total             | 10       |          | ---       | 
| go_godebug_non_default_behavior_x509usefallbackroots_events_total | 10       |          | ---       | 
| go_godebug_non_default_behavior_x509usepolicies_events_total      | 10       |          | ---       | 
| go_godebug_non_default_behavior_zipinsecurepath_events_total      | 10       |          | ---       | 
| go_goroutines                                                     | 10       |          | ---       | 
| go_info                                                           | 10       |          | ---       | 
| go_memory_classes_heap_free_bytes                                 | 10       |          | ---       | 
| go_memory_classes_heap_objects_bytes                              | 10       |          | ---       | 
| go_memory_classes_heap_released_bytes                             | 10       |          | ---       | 
| go_memory_classes_heap_stacks_bytes                               | 10       |          | ---       | 
| go_memory_classes_heap_unused_bytes                               | 10       |          | ---       | 
| go_memory_classes_metadata_mcache_free_bytes                      | 10       |          | ---       | 
| go_memory_classes_metadata_mcache_inuse_bytes                     | 10       |          | ---       | 
| go_memory_classes_metadata_mspan_free_bytes                       | 10       |          | ---       | 
| go_memory_classes_metadata_mspan_inuse_bytes                      | 10       |          | ---       | 
| go_memory_classes_metadata_other_bytes                            | 10       |          | ---       | 
| go_memory_classes_os_stacks_bytes                                 | 10       |          | ---       | 
| go_memory_classes_other_bytes                                     | 10       |          | ---       | 
| go_memory_classes_profiling_buckets_bytes                         | 10       |          | ---       | 
| go_memory_classes_total_bytes                                     | 10       |          | ---       | 
| go_memstats_alloc_bytes                                           | 10       |          | ---       | 
| go_memstats_alloc_bytes_total                                     | 10       |          | ---       | 
| go_memstats_buck_hash_sys_bytes                                   | 10       |          | ---       | 
| go_memstats_frees_total                                           | 10       |          | ---       | 
| go_memstats_gc_sys_bytes                                          | 10       |          | ---       | 
| go_memstats_heap_alloc_bytes                                      | 10       |          | ---       | 
| go_memstats_heap_idle_bytes                                       | 10       |          | ---       | 
| go_memstats_heap_inuse_bytes                                      | 10       |          | ---       | 
| go_memstats_heap_objects                                          | 10       |          | ---       | 
| go_memstats_heap_released_bytes                                   | 10       |          | ---       | 
| go_memstats_heap_sys_bytes                                        | 10       |          | ---       | 
| go_memstats_last_gc_time_seconds                                  | 10       |          | ---       | 
| go_memstats_lookups_total                                         | 10       |          | ---       | 
| go_memstats_mallocs_total                                         | 10       |          | ---       | 
| go_memstats_mcache_inuse_bytes                                    | 10       |          | ---       | 
| go_memstats_mcache_sys_bytes                                      | 10       |          | ---       | 
| go_memstats_mspan_inuse_bytes                                     | 10       |          | ---       | 
| go_memstats_mspan_sys_bytes                                       | 10       |          | ---       | 
| go_memstats_next_gc_bytes                                         | 10       |          | ---       | 
| go_memstats_other_sys_bytes                                       | 10       |          | ---       | 
| go_memstats_stack_inuse_bytes                                     | 10       |          | ---       | 
| go_memstats_stack_sys_bytes                                       | 10       |          | ---       | 
| go_memstats_sys_bytes                                             | 10       |          | ---       | 
| go_sched_gomaxprocs_threads                                       | 10       |          | ---       | 
| go_sched_goroutines_goroutines                                    | 10       |          | ---       | 
| go_sched_latencies_seconds                                        | 10       |          | ---       | 
| go_sched_pauses_stopping_gc_seconds                               | 10       |          | ---       | 
| go_sched_pauses_stopping_other_seconds                            | 10       |          | ---       | 
| go_sched_pauses_total_gc_seconds                                  | 10       |          | ---       | 
| go_sched_pauses_total_other_seconds                               | 10       |          | ---       | 
| go_sync_mutex_wait_total_seconds_total                            | 10       |          | ---       | 
| go_threads                                                        | 10       |          | ---       | 


