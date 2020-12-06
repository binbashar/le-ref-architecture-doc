# Kubernetes AWS EKS

[**Amazon Elastic Kubernetes Services** (EKS)](https://aws.amazon.com/eks/) is a managed service that makes it easy for you 
to run **Kubernetes** on AWS without needing to install and operate your own Kubernetes control plane or worker nodes. 

!!! check "Core Feautres"
    - [x] Highly Secure: EKS automatically applies the latest security patches to your cluster control plane. 
    - [x] Multiple Availability Zones: EKS auto-detects and replaces unhealthy control plane nodes and provides on-demand,
     zero downtime upgrades and patching.
    - [x] Serverless Compute: EKS supports AWS Fargate to remove the need to provision and manage servers, improving
     security through application isolation by design. 
    - [x] Built with the Community: AWS actively works with the Kubernetes community, including making contributions to the
     Kubernetes code base helping you take advantage of AWS services.

![leverage-aws-eks](../../assets/images/diagrams/aws-k8s-eks.png "Leverage"){: style="width:950px"}

<figcaption style="font-size:15px">
<b>Figure:</b> AWS K8s EKS architecture diagram (just as reference).
(Source: Jay McConnell, 
<a href="https://aws.amazon.com/blogs/infrastructure-and-automation/a-tale-from-the-trenches-the-cloudbees-core-on-aws-quick-start/">
"A tale from the trenches: The CloudBees Core on AWS Quick Start"</a>,
AWS Infrastructure & Automation Blog post, accessed November 18th 2020).
</figcaption>