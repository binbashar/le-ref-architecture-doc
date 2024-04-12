# Kubernetes for starting projects

## Goal

When starting a project using Kubernetes, usually a lot of testing is done.

Also, as a startup, the project is trying to save costs. (since probably no clients, or just a few, are now using the product)

To achieve this, we suggest the following path:

- Step 0 - develop in a K3s running on an EC2
- Step 1 - starting stress testing or having the first clients, go for KOPS
- Step 2 - when HA, escalation and easy of management is needed, consider going to EKS

For a lot of projects, Step 1 is ok for running!

Following we'll explore the three options.

### Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

---

---

## K3s

### Goal

A cluster with one node (master/worker) is deployed here.

Cluster autoscaler can be used with K3s to scale nodes, but it requires a lot of work that justifies going to KOPS.

---

---

## KOPS

See also [here](/user-guide/ref-architecture-aws/features/compute/k8s-kops/).

### Goal

A [gossip-cluster](https://kops.sigs.k8s.io/gossip/) (not exposed to Internet cluster, an Internet exposed cluster can be created using Route53) with a master node and a worker node (with node autoscaling capabilities) will be deployed here.

More master nodes can be deployed. (i.e. one per AZ, actually three are recommended for production grade clusters)

It will be something similar to what is stated [here](/user-guide/ref-architecture-aws/features/compute/k8s-kops/), but with one master and one worker.

![leverage-aws-k8s-kops](/assets/images/diagrams/aws-k8s-kops.png "Leverage"){: style="width:950px"}

### Procedure

These are the steps:

1. copy the [KOPS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-kops%20--) to your [**binbash Leverage**](https://leverage.binbash.co/) project.
    - paste the layer under the `apps-devstg/us-east-1` account/region directory
    - for easy of use, the `k8s-kops --` can be renamed to `k8s-kops`
2. apply prerequisites
3. apply the cluster
4. apply the extras

Ok, take it easy, now the steps explained.

--- 

#### 1 - Copy the layer

A few methods can be used to download the [KOPS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-kops%20--) directory into the [**binbash Leverage**](https://leverage.binbash.co/) project.

E.g. [this addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) is a nice way to do it.

!!! warning
    Do not change the `1-prerequisites`, `2-kops`, `3-extras` dir names since scripts depend on these!

#### 2 - Prerequisites

To create the KOPS cluster these are the requisites:

- a VPC to the cluster to live in
- a nat gateway to gain access to the Internet
- a bucket to store kops state
- an SSH key (you have to create it, )

!!! Warning
    If the nat-gateway is not in place check how to enable it using the [**binbash Leverage**](https://leverage.binbash.co/) network layer [here](/user-guide/playbooks/enable-nat-gateway).
    
!!! Info
    Note a DNS is not needed since this will be a gossip cluster.

!!! Info
    Note for the bucket the account Terraform backend bucket is used.

`cd` into the `1-prerequisites` directory.

By default, the [account base network](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/base-network) is used.

Open the `locals.tf` file.

Here these items can be updated:
- versions
- machine types (and max, min qty for masters and workers autoscaling groups)
- the number of AZs that will be used for master nodes.

Open the `config.tf` file.

Here set the backend key if needed:

```hcl
  backend "s3" {
    key = "apps-devstg/us-east-1/k8s-kops/prerequisites/terraform.tfstate"
  }
```

!!! info
    Remember [**binbash Leverage**](https://leverage.binbash.co/) has its rules for this, the key name should match `<account-name>/[<region>/]<layer-name>/[<sublayer-name>/]terraform.tfstate`. 

Init and apply as usual:

```shell
leverage tf init
leverage tf apply
```

!!! warning
    You will be prompted to enter the `ssh_pub_key_path`. Here enter the full path (e.g. `/home/user/.ssh/thekey.pub`) for your public SSH key and hit enter.
    

#### Playing with KOPS

`cd` into the `2-kops` directory.

Open the `config.tf` file and edit the backend key if needed:

```shell
  backend "s3" {
    key = "apps-devstg/us-east-1/k8s-kops/terraform.tfstate"
  }
```

!!! info
    Remember [**binbash Leverage**](https://leverage.binbash.co/) has its rules for this, the key name should match `<account-name>/[<region>/]<layer-name>/[<sublayer-name>/]terraform.tfstate`. 

Check the template just for checking:

```shell
make cluster-template
```

You can see the final template in file `cluster.yaml`.

#### Accessing the cluster

---

---

## EKS

See also [here](/user-guide/ref-architecture-eks/overview/).

### Goal
