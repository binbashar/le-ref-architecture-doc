# Compute

## Containers and Serverless

!!! summary "Overview"
    In order to serve Client application workloads we propose to implement **_Kubernetes_**, and proceed to containerize all
    application stacks whenever it’s the best solution (we’ll also consider **_AWS Lambda_** for a Serverless approach when
    it fits better). Kubernetes is an open source container orchestration platform that eases the process of running
    containers across many different machines, scaling up or down by adding or removing containers when demand changes
    and provides high availability features. Also, it serves as an abstraction layer that will give Client the
    possibility, with minimal effort, to move the apps to other Kubernetes clusters running elsewhere, or a managed
    Kubernetes service such as AWS EKS, GCP GKE or others.

Clusters will be provisioned with [**_Kops_**](https://github.com/kubernetes/kops) and/or
[**_AWS EKS_**](https://aws.amazon.com/eks/), which are solutions meant to orchestrate this
 compute engine in AWS. Whenever possible the initial version deployed will be the latest stable release.

![leverage-k8s-architecture](../../../assets/images/diagrams/k8s-architecture.png "Leverage"){: style="width:700"}

<figcaption style="font-size:15px">
<b>Figure:</b> Kubernetes high level components architecture.
(Source: Andrew Martin, 
<a href="https://kubernetes.io/blog/2018/07/18/11-ways-not-to-get-hacked">
"11 Ways (Not) to Get Hacked"</a>,
Kubernetes.io Blog post, accessed November 18th 2020).
</figcaption>

## Kubernetes addons 

!!! info "Some possible K8s addons could be"
    **Security**
        
    - [x] IAM Authenticator

    **Networking**
        
    - [x] Kubernetes Nginx Ingress Controller
    - [x] Linked2 (Service Mesh)
    
    **Monitoring & Logs** 
      
    - [x] fluentd daemonset for elasticsearch logs
    - [x] kube-state-metrics
    - [x] prometheus node-exporter
    
    **Distributed Tracing**
        
    - [x] jaeger
    - [x] opencensus
    
    **UI Dashboard** 
        
    - [x] kube-ops-view
    - [x] kubernetes-dashboard
    - [x] weave-scope
    
    **Availability & Reliability**
        
    - [x] autoscaler
    - [x] Velero (Backups)
    
    **Utilities** 
        
    - [x] onetimesecret 

