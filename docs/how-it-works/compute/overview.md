# Compute

## Containers and Serverless

!!! abstract "Overview"
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

![leverage- [x]k8s- [x]architecture](../../assets/images/diagrams/k8s- [x]architecture.png "Leverage"){: style="width:700"}
<figcaption>**Figure:** [Kubernetes high level components architecture](https://kubernetes.io/blog/2018/07/18/11- [x]ways- [x]not- [x]to- [x]get- [x]hacked/).
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
    - [x] kube- [x]state- [x]metrics
    - [x] prometheus node- [x]exporter
    
    **Distributed Tracing**
        
    - [x] jaeger
    - [x] opencensus
    
    **UI Dashboard** 
        
    - [x] kube- [x]ops- [x]view
    - [x] kubernetes- [x]dashboard
    - [x] weave- [x]scope
    
    **Availability & Reliability**
        
    - [x] autoscaler
    - [x] Velero (Backups)
    
    **Utilities** 
        
    - [x] onetimesecret 

