# Kubernetes for different stages of your projects

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

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was created and a region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

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

- 0 - copy the [KOPS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-kops%20--) to your [**binbash Leverage**](https://leverage.binbash.co/) project.
    - paste the layer under the `apps-devstg/us-east-1` account/region directory
    - for easy of use, the `k8s-kops --` can be renamed to `k8s-kops`
- 1 - apply prerequisites
- 2 - apply the cluster
- 3 - apply the extras

Ok, take it easy, now the steps explained.

--- 

#### 0 - Copy the layer

A few methods can be used to download the [KOPS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-kops%20--) directory into the [**binbash Leverage**](https://leverage.binbash.co/) project.

E.g. [this addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) is a nice way to do it.

Paste this layer into the account/region chosen to host this, e.g. `apps-devstg/us-east-1/`, so the final layer is `apps-devstg/us-east-1/k8s-kops/`.

!!! warning
    Do not change the `1-prerequisites`, `2-kops`, `3-extras` dir names since scripts depend on these!

#### 1 - Prerequisites

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
    A new bucket is created so KOPS can store the state there

By default, the [account base network](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/base-network) is used. If you want to change this check/modify this resource in `config.tf` file:

```hcl
data "terraform_remote_state" "vpc" {
```

Also, `shared` VPC will be used to allow income traffic from there. This is because in the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) defaults, the VPN server will be created there.

`cd` into the `1-prerequisites` directory.

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
    Remember [**binbash Leverage**](https://leverage.binbash.co/) has its rules for this, the key name should match `<account-name>/[<region>/]<layer-name>/<sublayer-name>/terraform.tfstate`. 

Init and apply as usual:

```shell
leverage tf init
leverage tf apply
```

!!! warning
    You will be prompted to enter the `ssh_pub_key_path`. Here enter the full path (e.g. `/home/user/.ssh/thekey.pub`) for your public SSH key and hit enter.<br />
    A key managed by KMS can be used here. A regular key-in-a-file is used for this example, but you can change it as per your needs.
    
!!! info
    Note if for some reason the nat-gateway changes, this layer has to be applied again.

#### 2 - Apply the cluster with KOPS

`cd` into the `2-kops` directory.

Open the `config.tf` file and edit the backend key if needed:

```shell
  backend "s3" {
    key = "apps-devstg/us-east-1/k8s-kops/terraform.tfstate"
  }
```

!!! info
    Remember [**binbash Leverage**](https://leverage.binbash.co/) has its rules for this, the key name should match `<account-name>/[<region>/]<layer-name>/<sublayer-name>/terraform.tfstate`. 

!!! info
    If you want to check the configuration:

    ```shell
    make cluster-template
    ```

    The final template in file `cluster.yaml`.

If you are happy with the config (or you are not happy but you think the file is ok), let's create the Terraform files!

```shell
make cluster-updated
```

Finally, apply the layer:

```shell
leverage tf init
leverage tf apply
```

#### Accessing the cluster
 
With the cluster, a Load Balancer was deployed so you can reach the K8s API.

Here there are two questions. One is how to expose the cluster so Apps running in it can be reached.

The other one is how to access the cluster's API.
    
For the first one, since this is a `gossip-cluster` and as per the KOPS docs: When using gossip mode, you have to expose the kubernetes API using a loadbalancer. Since there is no hosted zone for gossip-based clusters, you simply use the load balancer address directly. The user experience is identical to standard clusters. kOps will add the ELB DNS name to the kops-generated kubernetes configuration.<br /><br />
    
    It can be reached also using a VPN. Check the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) documentation for this.
    
---

---

## EKS

See also [here](/user-guide/ref-architecture-eks/overview/).

### Goal
