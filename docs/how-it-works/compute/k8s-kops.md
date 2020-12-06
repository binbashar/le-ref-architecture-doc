# Kubernetes Kops

**_[Kops is an official Kubernetes project](https://github.com/kubernetes/kops)_** for managing production-grade 
Kubernetes clusters. Kops is currently the best tool to deploy Kubernetes clusters to Amazon Web Services. 
The project describes itself as kubectl for clusters.

!!! check "Core Features"
    - [x] Open-source & supports AWS and GCE
    - [x] Deploy clusters to existing virtual private clouds (VPC) or create a new VPC from scratch
    - [x] Supports public & private topologies
    - [x] Provisions single or multiple master clusters
    - [x] Configurable bastion machines for SSH access to individual cluster nodes
    - [x] Built on a state-sync model for dry-runs and automatic idempotency
    - [x] Direct infrastructure manipulation, or works with CloudFormation and Terraform
    - [x] Rolling cluster updates
    - [x] Supports heterogeneous clusters by creating multiple instance groups
    
![leverage-aws-k8s-kops](../../assets/images/diagrams/aws-k8s-kops.png "Leverage"){: style="width:950px"}

<figcaption style="font-size:15px">
<b>Figure:</b> AWS K8s Kops architecture diagram (just as reference).
(Source: Carlos Rodriguez, 
<a href="https://www.nclouds.com/blog/kubernetes-aws-terraform-kops/">
"How to deploy a Kubernetes cluster on AWS with Terraform & kops"</a>,
Nclouds.com Blog post, accessed November 18th 2020).
</figcaption>