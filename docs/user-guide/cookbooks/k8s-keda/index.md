# K8s pod autoscaling with KEDA

Kubernetes, a powerful container orchestration platform, revolutionized the way applications are deployed and managed.

However, scaling applications to meet fluctuating workloads can be a complex task.

KEDA, a Kubernetes-based Event-Driven Autoscaler, provides a simple yet effective solution to automatically scale Kubernetes Pods based on various metrics, including resource utilization, custom metrics, and external events.

## Goal

To install and configure KEDA on an EKS Cluster created on the [**binbash Leverage**](https://leverage.binbash.co/) way.

!!! Note
    To read more on how to create the EKS Cluster on the [**binbash Leverage**](https://leverage.binbash.co/) way, read [here](./k8s.md).

![KEDA](https://keda.sh/img/logos/keda-icon-color.png)

### Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was created and region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

---

---

## Installation

To install KEDA, just enable it in the components layer [here](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks/k8s-components).

Note it can be done by setting `enable_keda`, in the `terraform.tfvars` file, to `true`.

To read more on how to enable components see [here](./k8s.md#eks).

## Giving it a try!

Here are some examples:

* [Keda based on HTTP Requests](./keda-http.md)
* Keda based on Prometheus metrics (TBD)
    
## Final thoughts

Given the scale-to-zero feature for pods, KEDA is a great match to Karpenter!
