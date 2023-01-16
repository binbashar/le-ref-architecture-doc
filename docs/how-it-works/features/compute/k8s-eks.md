# Kubernetes AWS EKS

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

![leverage-aws-eks](../../../assets/images/diagrams/aws-k8s-eks.png "Leverage"){: style="width:950px"}

<figcaption style="font-size:15px">
<b>Figure:</b> AWS K8s EKS architecture diagram (just as reference).
(Source: Jay McConnell, 
<a href="https://aws.amazon.com/blogs/infrastructure-and-automation/a-tale-from-the-trenches-the-cloudbees-core-on-aws-quick-start/">
"A tale from the trenches: The CloudBees Core on AWS Quick Start"</a>,
AWS Infrastructure & Automation Blog post, accessed November 18th 2020).
</figcaption>

## Version support convention
At Leverage we support the last 3 latest stable 
[Kubernetes version](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html) releases (at best effort)
within our
[Reference Architecture EKS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks) 
and [IaC Library EKS module](https://github.com/binbashar/terraform-aws-eks)

We think this is a good balance between management overhead and an acceptable level of 
supported versions (at best effort). If your project have and older legacy version we could work along
your CloudOps team to safely migrate it to a Leverage supported EKS version.

# Network Layer: EKS Network Requirements

## Considerations
!!! attention "Design considerations"
    * :ledger: **AWS EKS:** Docker runs in the 172.17.0.0/16 CIDR range in Amazon EKS clusters. 
      We recommend that your cluster's VPC subnets do not overlap this range. Otherwise, you will 
      receive the following error:
      ```
      Error: : error upgrading connection: error dialing backend: dial tcp 172.17.nn.nn:10250: 
      getsockopt: no route to host
      ```
      Read more: [AWS EKS network requirements](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)   
    * :ledger: **Reserved IP Addresses**
    The first four IP addresses and the last IP address in each subnet CIDR block are not available for you to use, 
    and cannot be assigned to an instance. For example, in a subnet with CIDR block 10.0.0.0/24, the following five IP 
    addresses are reserved. For more [AWS VPC Subnets IP addressing](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html#vpc-sizing-ipv4)

---

## VPCs IP Addressing Plan (CIDR blocks sizing)

```
* Apps-DevStg
  * us-east-1
    * Main          172.18.32.0/20
    * EKS-v1.17     10.0.0.0/16 => subnets /19
    * EKS DemoApps  10.1.0.0/16 => subnets /19
    * EKS           10.2.0.0/16 => subnets /19
  * us-east-2
    * Main          N/A
    * EKS           10.10.0.0/16 => subnets /19
* Apps-Prd
  * us-east-1
    * Main          172.18.64.0/20
    * EKS           10.20.0/16 => subnets /19
* Network
  * us-east-1
    * Main          172.20.0.0/20
    * NFW           172.20.16.0/20
* Shared
  * us-east-1
    * Main          172.18.0.0/20
````

### EKS Clusters VPC CIDR Table

* VPC CIDR: 10.0.0.0/16 (starts at /16 due to AWS VPC limits)
* Subnetting to /19

Which leaves us with this:
* Number of subnets: 8
* Number of available hosts: 8190
* Number of available IPs (AWS): 8187


| Subnet address | Netmask       | Range of addresses          | Hosts | Assignment |
| -------------- | ------------- | --------------------------- | ----- | ---------- |
| 10.0.0.0/19    | 255.255.224.0 | 10.0.0.0 - 10.0.31.255      | 8190  |            |
| 10.0.32.0/19   | 255.255.224.0 | 10.0.32.0 - 10.0.63.255     | 8190  |            |
| 10.0.64.0/19   | 255.255.224.0 | 10.0.64.0 - 10.0.95.255     | 8190  |            |
| 10.0.96.0/19   | 255.255.224.0 | 10.0.96.0 - 10.0.127.255    | 8190  |            |
| 10.0.128.0/19  | 255.255.224.0 | 10.0.128.0 - 10.0.159.255   | 8190  |            |
| 10.0.160.0/19  | 255.255.224.0 | 10.0.160.0 - 10.0.191.0/255 | 8190  |            |
| 10.0.192.0/19  | 255.255.224.0 | 10.0.192.0 - 10.0.223.255   | 8190  |            |
| 10.0.224.0/19  | 255.255.224.0 | 10.0.224.0 - 10.0.224.255   | 8190  |            |


**Note:** Additional clusters can use their own available VPC space under 10.x.0.0/16.

#### Ref 1: https://www.davidc.net/sites/default/subnets/subnets.html?network=10.0.0.0&mask=16&division=15.7231
#### Ref 2: http://jodies.de/ipcalc?host=10.0.0.0&mask1=16&mask2=19
