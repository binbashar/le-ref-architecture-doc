# K8s and Cilium cluster mesh

**Cilium cluster mesh is used to address the networking challenges inherent in multi-cluster Kubernetes setups, which are increasingly adopted for advantages like fault isolation, scalability, and geographical distribution.**

Traditional networking models struggle to handle the complexities of service discovery, network segmentation, policy enforcement, and load balancing across multiple Kubernetes clusters.

The distributed nature of services also complicates the management of security protocols and policies in such environments.

Cilium provides a robust solution to these problems, facilitating secure and streamlined communication within multi-cluster Kubernetes deployments.

## Goal

To install and configure a Cilium cluster mesh on two EKS Clusters created on the [**binbash Leverage**](https://leverage.binbash.co/) way.

!!! Note
    To read more on how to create the EKS Cluster on the [**binbash Leverage**](https://leverage.binbash.co/) way, read [here](./k8s.md).


!!! Note
    To lear more about Cilium read [the official site](https://cilium.io/).
    
![CILIUM](https://res.cloudinary.com/startup-grind/image/upload/c_fill,dpr_2.0,f_auto,g_center,h_1080,q_100,w_1080/v1/gcs/platform-data-goog/events/Cilium_o5OhHsU.png)

For more info on EKS+Cilium read [here](https://aws.amazon.com/blogs/containers/a-multi-cluster-shared-services-architecture-with-amazon-eks-using-cilium-clustermesh/).

### Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was created and region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

### Note

For the implementation in this blog, we will be using the tunneling mode which has the fewest requirements on the underlying networking infrastructure. 

To read more on this see [here](https://aws.amazon.com/blogs/containers/a-multi-cluster-shared-services-architecture-with-amazon-eks-using-cilium-clustermesh/).

---

---

## A Cluster Mesh

To read more on what is a Cluster Mesh read [this](https://aws.amazon.com/blogs/containers/a-multi-cluster-shared-services-architecture-with-amazon-eks-using-cilium-clustermesh/).

![Cluster Mesh](https://d2908q01vomqb2.cloudfront.net/fe2ef495a1152561572949784c16bf23abb28057/2021/06/14/clustermesh-arch.png)

Basically:
> A cluster mesh is a dedicated infrastructure layer that facilitates secure and efficient networking between multiple Kubernetes clusters.

Cilium Cluster Mesh is Cilium's implementation for connecting multiple Kubernetes clusters.

### Features

It provides several features, including:

* Inter-cluster pod-to-pod connectivity without gateways or proxies.
* Transparent service discovery across clusters using standard Kubernetes services and CoreDNS.
* Network policy enforcement across clusters.
* Encryption in transit between nodes within a cluster as well as across cluster boundaries.

### EKS Requirements

Since we are working with EKS, these are the requisites to be able to work with Cilium:

* Clusters can be created using any method outlined in [Creating an Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html).
* Worker nodes can be provisioned using managed node groups or self-managed nodes.
  * However, because Cilium's eBPF replacement for kube-proxy has [specific Linux kernel requirements](https://docs.cilium.io/en/stable/gettingstarted/kubeproxy-free/), it is recommended to use the latest EKS-optimized Amazon Linux AMI 
* Security groups for worker nodes should allow VXLAN traffic over UDP as per the [Firewall Rules](https://docs.cilium.io/en/v1.9/operations/system_requirements/#firewall-requirements) documentation.
* Clusters should be in different VPCs with non-overlapping CIDRs and a VPC peering connection to enable IP connectivity between nodes.
* Clusters need non-overlapping PodCIDRs.

!!! Attention
    Be sure to meet these requirements before proceed!

!!! Attention
    Note that Cillium ENI support only allows IPV4 addresses for now.
    
### Steps

#### Step 0 - create the cluster

Create the network and the cluster applying the [network](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks/network) and the [cluster](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks/cluster) under your [**binbash Leverage**](https://leverage.binbash.co/) project.

Note that Security Groups for worker nodes have to be updated to includ traffic to and from `8472/udp`.

#### Step 1 - remove aws-node and kube-proxy

As this cluster will be using Cilium CNI with eBPF replacement for kube-proxy, we will have to first disable aws-node and kube-proxy daemonsets. To do this use a node selector that does not match any nodes in the cluster, e.g.:

```shell
kubectl patch daemonset aws-node -n kube-system -p '{"spec":{"template":{"spec":{"nodeSelector":{"no-such-node": "true"}}}}}'
kubectl patch daemonset kube-proxy -n kube-system -p '{"spec":{"template":{"spec":{"nodeSelector":{"no-such-node": "true"}}}}}'
```

#### Step 2 - Scale down coreDNS

CoreDNS deployment has to be sacled-down to 0 replicas:

```shell
kubectl scale deployment coredns --replicas=0 -n kube-system
```

#### Step 3 - Install Cilium

Install Cilium. We will use Helm here. 
  
Each cluster in the mesh is assigned a unique ID and name with the cluster.id and cluster.name parameters. 

The ipam.mode parameter configures Cilium to operate in cluster-scope mode which assigns per-node PodCIDR to each node and delegates pod IP address allocation to each individual node in the cluster. 

The ipam.operator.clusterPoolIPv4PodCIDR and ipam.operator.clusterPoolIPv4MaskSize parameters are used to specify the CIDR for cluster’s pods and the CIDR size that should be allocated for each node. 

In this case, with the latter set to 24, each node will be able to accommodate up to 256 pods. 

The parameters kubeProxyReplacement, k8sServiceHost and k8sServicePort will install Cilium as a CNI plugin with the eBPF kube-proxy replacement to implement handling of Kubernetes services of type ClusterIP, NodePort, LoadBalancer, and services with externalIPs.

```shell
helm install cilium cilium/cilium --version 1.16.3 \
  --set cluster.id=1 \
  --set cluster.name=bb-apps-devstg-eks-training \
  --set eni.enabled=false \
  --set tunnelProtocol=vxlan \
  --set ipam.mode=cluster-pool \
  --set ipam.operator.clusterPoolIPv4PodCIDRList=10.50.0.0/16 \
  --set ipam.operator.clusterPoolIPv4MaskSize=24 \
  --set kubeProxyReplacement=true \
  --set k8sServiceHost=F334A90D0571D2146228B1F58E3CBBF9.yl4.us-east-1.eks.amazonaws.com \
  --set k8sServicePort=443 \
  -n kube-system
```
*Replace the values that have to be adapted to your case. Also note the cluster.id and cluster.name must be unique for each cluster.*

*To get the k8sServiceHost you can use the command `kubectl cluster-info`.*

Wait until all the pods are up and running.

#### Step 4 - Scale up coreDNS

CoreDNS deployment has to be sacled-up:

```shell
kubectl scale deployment coredns --replicas=2 -n kube-system
```

#### Step 5 - Enable ETCD access

Now Cilium is set up to use Kubernetes Custom Resource Definitions (CRDs) to store and propagate cluster state between agents. 

For cluster mesh, we must update the deployment to use an etcd data store for storing cluster state

```shell
helm upgrade cilium cilium/cilium --version 1.16.3 \
  --set etcd.enabled=true \
  --set identityAllocationMode=kvstore \
  --set k8sServiceHost=F334A90D0571D2146228B1F58E3CBBF9.yl4.us-east-1.eks.amazonaws.com \
  --set k8sServicePort=443 \
  -n kube-system
```
*Replace the values that have to be adapted to your case. Also note the cluster.id and cluster.name must be unique for each cluster.*

*To get the k8sServiceHost you can use the command `kubectl cluster-info`.*
