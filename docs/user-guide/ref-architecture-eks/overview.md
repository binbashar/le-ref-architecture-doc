# AWS EKS Reference Architecture

## Overview
[**Amazon Elastic Kubernetes Services** (EKS)](https://aws.amazon.com/eks/) is a managed service that makes it easy for you 
to run **Kubernetes** on AWS without needing to install and operate your own Kubernetes control plane or worker nodes. 

!!! check "Core Features"
    - [x] Highly Secure: EKS automatically applies the latest security patches to your cluster control plane. 
    - [x] Multiple Availability Zones: EKS auto-detects and replaces unhealthy control plane nodes and provides on-demand,
     zero downtime upgrades and patching.
    - [x] Serverless Compute: EKS supports AWS Fargate to remove the need to provision and manage servers, improving
     security through application isolation by design. 
    - [x] Built with the Community: AWS actively works with the Kubernetes community, including making contributions to the
     Kubernetes code base helping you take advantage of AWS services.

<div class="hide-on-mobile">
<img alt="leverage-aws-eks" src="/assets/images/diagrams/aws-k8s-eks.png" style="width:950px" title="Leverage">

<figcaption style="font-size:15px">
<b>Figure:</b> AWS K8s EKS architecture diagram (just as reference).
(Source: Jay McConnell, 
<a href="https://aws.amazon.com/blogs/infrastructure-and-automation/a-tale-from-the-trenches-the-cloudbees-core-on-aws-quick-start/">
"A tale from the trenches: The CloudBees Core on AWS Quick Start"</a>,
AWS Infrastructure & Automation Blog post, accessed November 18th 2020).
</figcaption>
</div>

## Version Support
At Leverage we support the last 3 latest stable 
[Kubernetes version](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html) releases (at best effort)
within our
[Reference Architecture EKS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks) 
and [IaC Library EKS module](https://github.com/binbashar/terraform-aws-eks)

We think this is a good balance between management overhead and an acceptable level of 
supported versions (at best effort). If your project have and older legacy version we could work along
your CloudOps team to safely migrate it to a Leverage supported EKS version.

## Resources

### Control Plane
This is the primary resource which defines the cluster. We will create one cluster on each
account:

- [x] [apps-devstg/us-east-1/k8s-eks](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks)
- [x] [apps-prd/us-east-1/k8s-eks](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/us-east-1/k8s-eks)

!!! info "Important" 
    In case of multiple environments hosted in the same cluster as for the one with
    Apps Dev and Stage, the workload isolation will be achieved through Kubernetes
    features such as namespaces, network policies, RBAC, and others.

### Data Plane
We have 3 options here: 

- Managed Nodes
- Fargate
- Fargate Spot 

!!! info "Considerations" 
    Each option has its pros and cons with regard to cost, operation complexity, extensibility,
    customization capabilities, features, and management.

    In general we implement Managed Nodes. The main reasons being:
    
    1. They allow a high degree of control in terms of the components we can deploy and the features those components can provide to us. For instance we can run ingress controllers and service mesh, among other very customizable resources.
    2. AWS takes care of provisioning and lifecycle management of nodes which is one less task to worry about.
    3. Upgrading Kubernetes versions becomes much simpler and quicker to perform.
    4. We still can, at any time, start using Fargate and Fargate Spot by simply creating a profile for one or both of them, then we only need to move the workloads that we want to run on Fargate profiles of our choice.
