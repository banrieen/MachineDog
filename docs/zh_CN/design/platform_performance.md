
平台性能调研
=====================================================================================

* https://web.dev/measure/

* k8s-kpis-with-kuberhealthy:

https://kubernetes.io/blog/2020/05/29/k8s-kpis-with-kuberhealthy/

https://github.com/Comcast/kuberhealthy/blob/master/docs/EXTERNAL_CHECKS_REGISTRY.md

* kubeflow/testing:

https://github.com/kubeflow/testing
https://github.com/kubernetes/test-infra

* argo

https://github.com/argoproj/argo/

https://argoproj.github.io/argo-cd/getting_started/#1-install-argo-cd

https://blog.argoproj.io/about

* kubernetes perf-tests:

https://github.com/kubernetes/perf-tests


k8s Limits
--------------------------------------------------------------------
https://kubernetes.io/docs/setup/best-practices/cluster-large/#:~:text=More%20specifically%2C%20Kubernetes%20is%20designed,more%20than%20150000%20total%20pods

No more than 100 pods per node
No more than 5000 nodes
No more than 150000 total pods
No more than 300000 total containers

https://cloud.google.com/kubernetes-engine/docs/best-practices/scalability
默认情况下：

Pod 次要范围默认为 /14（262144 个 IP 地址）。
每个节点都有为其 Pod 分配的 /24 范围（用于其 Pod 的 256 个 IP 地址）。
节点的子网为 /20（4092 个 IP 地址）。

testExample:
https://www.jeffgeerling.com/blog/2020/10000-kubernetes-pods-10000-subscribers
https://docs.openshift.com/container-platform/3.7/scaling_performance/cluster_limits.html
https://learnk8s.io/setting-cpu-memory-limits-requests
https://blog.newrelic.com/engineering/kubernetes-request-and-limits/
https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
https://github.com/kubernetes/community/blob/master/sig-scalability/configs-and-limits/thresholds.md


