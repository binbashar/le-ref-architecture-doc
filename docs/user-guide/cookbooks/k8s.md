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

### Assumptions

The base VPC for the account will be used. 

Since this K8s is aimed mainly to quick POCs, it will be created as a public machine (but using the OS Firewall to block unused ports).

### Procedure

Steps

- 0: Create the EC2 instance
- 1: Install K3s and enable firewall
- 2: Access K8s

#### 0 - Create the EC2 instance

Here, the [**binbash Leverage**](https://leverage.binbash.co/) [EC2 fleet layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/ec2-fleet-ansible%20--) will be used.

A few methods can be used to download the layer directory into the [**binbash Leverage**](https://leverage.binbash.co/) project.

E.g. [this addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) is a nice way to do it.

Paste this layer into the account/region chosen to host this, e.g. `apps-devstg/us-east-1/`, so the final layer is `apps-devstg/us-east-1/ec2-fleet-ansible/`.

In the `locals.tf` file locate the object `multiple_instances` and add a configuration like this:

```hcl
  multiple_instances = {
    1 = {
      # MANDATORY the subnet in which the instance will be created
      subnet_id        = data.terraform_remote_state.vpc.outputs.public_subnets[0]

      instance_type    = "t3a.medium"
      ami              = data.aws_ami.ubuntu_linux.id
      key_name         = data.terraform_remote_state.security.outputs.aws_key_pair_name
      # root ebs device
      root_volume_size = 30
      root_volume_type = "gp3"
      # whether or not it is a spot instance
      create_spot_instance = false
      # the additional ebs volume for this instance
      ebs_volume       = {
                         # whether or not this ebs will be created
                         enable = false
                         # The size of the drive in GiBs.
                         size = 8
                         # The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1
                         # Check types in your region here https://aws.amazon.com/ebs/pricing/
                         type = "gp3"
                       }
    }
```

!!! Info
    Note the key set here. It will be later used to access the instance with Ansible.

Open the `config.tf` file.

Here set the backend key if needed:

```terraform
  backend "s3" {
    key = "apps-devstg/us-east-1/ec2-fleet-ansible/terraform.tfstate"
  }
```

Note you can add labels to the EC2 instances if you want them to be auto stopped/started using the [start/stop Lambda](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/tools-cloud-scheduler-stop-start), e.g. in the `locals.tf` file:

```hcl
locals {
  tags = {
    Terraform           = "true"
    Environment         = var.environment
    ScheduleStopDaily   = true
    ScheduleStartManual = true
  }
}
```

Init and apply as usual:

```shell
leverage tf init
leverage tf apply
```

##### DNS

If you want to set a DNS or a local `hosts` record to access the server, use the public IP provided in the output.

If you have set a DNS with [**binbash Leverage**](https://leverage.binbash.co/), you can automate this process adding a remote state and an automatic record creation like this in this layer:

```hcl

provider "aws" {
  alias   = "shared"
  region  = var.region
  profile = "${var.project}-shared-devops"
}
data "terraform_remote_state" "shared-dns" {
  backend = "s3"

  config = {
    region  = var.region
    profile = "${var.project}-shared-devops"
    bucket  = "${var.project}-shared-terraform-backend"
    key     = "shared/global/dns/basemates.co/terraform.tfstate"
  }
}
locals {
    public_ips    = { for p in sort(keys(local.multiple_instances)) : p => module.ec2_ansible_fleet[p].public_ip }
    public_domain = "instance1.binbash.co"
}

# Example for EC2 instance 1
resource "aws_route53_record" "access-for-instance-1" {
  provider = aws.shared

  allow_overwrite = true
  name            = local.public_domain
  records         = [local.public_ips["1"]]
  ttl             = 3600
  type            = "A"
  zone_id         = data.terraform_remote_state.shared-dns.outputs.public_zone_id

  depends_on = [module.ec2_ansible_fleet]
}
```
    

#### 1 - Install K3s and enable firewall

Once installed, you should have access to the EC2 **using the corresponding key**.

```shell
ssh ubuntu@instance1.binbash.co
```

Now we can install K3s with Ansible.

I am using here this [Ansible playbook](https://gitlab.com/ansible-kungfoo/k3s#).

!!! Info
    You can add an ssh key so it is used by Ansible by adding it to the [ssh-agent](https://en.wikipedia.org/wiki/Ssh-agent) like this:
    
    ```shell
    ssh-add <yourkeypath>
    ```


##### Playing with the Playbook

As it says in the Ansible Playbook repository README:

> Search in files for `<emailaddresshere>` and `<instancehostnamehere>` and replace with your own values.

Copy file `inventory/hosts.prod.ini` to `inventory/hosts.dev.ini`. (I am using dev here, you use what you need)

Test the connection:

```shell
ansible-playbook ping-servers.yaml --inventory-file inventory/hosts.dev.ini
```

Now install K3s:

```shell
ansible-playbook basedata-setup.yaml  --inventory-file inventory/hosts.dev.ini
```

Finally, since this is a public machine, close the unneeded ports:

```shell
ansible-playbook close-ports.yaml  --inventory-file inventory/hosts.dev.ini
```

##### Get the K3s credentials

Now you can get the credentials using SSH:

```shell
# get the configfile
ssh ubuntu@instance1.binbash.co sudo k3s kubectl config view --raw  | sed 's/server: https:\/\/127.0.0.1:6443/server: https:\/\/instance1.binbash.co:6443/' > ~/kubeconfig.yaml
```

Replace the hostname!

And finally, test it:

```shell
# export the KUBECONFIG envvar
export KUBECONFIG=${HOME}/kubeconfig.yaml
# check it works
kubectl --insecure-skip-tls-verify get nodes
```

Note here we are using the `--insecure-skip-tls-verify` flag to connect over internet.

!!! Warning
    This is not recommended for production!
  
!!! Info
    To access the cluster you should reach the private IP for security reasons. (e.g. using a VPN or SSHing into the server)

##### Ingress controller

At the bottom of `basedata-setup.yaml` file, uncomment the Traefik part and re run the playbook.

This will install Traefik.

---

---

## KOPS

See also [here](/user-guide/ref-architecture-aws/features/compute/k8s-kops/).

### Goal

A [gossip-cluster](https://kops.sigs.k8s.io/gossip/) (not exposed to Internet cluster, an Internet exposed cluster can be created using Route53) with a master node and a worker node (with node autoscaling capabilities) will be deployed here.

More master nodes can be deployed. (i.e. one per AZ, actually three are recommended for production grade clusters)

It will be something similar to what is stated [here](/user-guide/ref-architecture-aws/features/compute/k8s-kops/), but with one master, one worker, and the LB for the API in the private network.

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
    If the nat-gateway is not in place check how to enable it using the [**binbash Leverage**](https://leverage.binbash.co/) network layer [here](/user-guide/cookbooks/enable-nat-gateway).

!!! Warning
    If you will activate **Karpenter** you need to tag the target subnets (i.e. the private subnets in your VPC) with:
    ```hcl
        "kops.k8s.io/instance-group/nodes"     = "true"
        "kubernetes.io/cluster/<cluster-name>" = "true"
    ```
    <br />
    We are assuming here the worker Instance Group is called `nodes`. If you change the name or have more than one Instance Group you need to adapt the first tag.
    
!!! Info
    Note a DNS is not needed since this will be a gossip cluster.

!!! Info
    A new bucket is created so KOPS can store the state there

By default, the [account base network](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/base-network) is used. If you want to change this check/modify this resource in `config.tf` file:

```terraform
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

```terraform
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
    
!!! info
    Note the role `AWSReservedSSO_DevOps` (the one created in the SSO for Devops) is added as `system:masters`. If you want to change the role, check the `devopsrole` in `data.tf` file.

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
make cluster-update
```

Finally, apply the layer:

```shell
leverage tf init
leverage tf apply
```

Cluster can be checked with this command:

```shell
make kops-cmd KOPS_CMD="validate cluster"
```
#### Accessing the cluster
 
Here there are two questions. 

One is how to expose the cluster so Apps running in it can be reached.

The other one is how to access the cluster's API.
    
For the first one:

    since this is a `gossip-cluster` and as per the KOPS docs: When using gossip mode, you have to expose the kubernetes API using a loadbalancer. Since there is no hosted zone for gossip-based clusters, you simply use the load balancer address directly. The user experience is identical to standard clusters. kOps will add the ELB DNS name to the kops-generated kubernetes configuration.
    
So, we need to create a LB with public access.

For the second one, we need to access the VPN (we have set the access to the used network previously), and hit the LB. With the cluster, a Load Balancer was deployed so you can reach the K8s API.

##### Access the API

Run:

```shell
make kops-kubeconfig
```

A file named as the cluster is created with the kubeconfig content (admin user, so keep it safe). So export it and use it!

```shell
export KUBECONFIG=$(pwd)/clustername.k8s.local
kubectl get ns
```

!!! warning
    You have to be connected to the VPN to reach your cluster!
 
##### Access Apps

You should use some sort of ingress controller (e.g. Traefik, Nginx) and set ingresses for the apps. (see Extras)


#### 3 - Extras

Copy the KUBECONFIG file to the `3-extras` directory, e.g.:

```shell
cp ${KUBECONFIG} ../3-extras/
```

`cd` into `3-extras`.

Set the name for this file and the context in the file `config.tf`.

Set what extras you want to install (e.g. `traefik = true`) and run the layer as usual:

```shell
leverage tf init
leverage tf apply
```

You are done!

---

---

## EKS

See also [here](/user-guide/ref-architecture-eks/overview/).

### Goal

A cluster with one node (worker) per AZ and the control plane managed by AWS is deployed here.

Cluster autoscaler is used to create more nodes.

### Procedure

These are the steps:

- 0 - copy the [K8s EKS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks) to your [**binbash Leverage**](https://leverage.binbash.co/) project.
    - paste the layer under the `apps-devstg/us-east-1` account/region directory
- 1 - create the network
- 2 - Add path to the VPN Server
- 3 - create the cluster and dependencies/components
- 4 - access the cluster

--- 

#### 0 - Copy the layer

A few methods can be used to download the [K8s EKS layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/k8s-eks) directory into the [**binbash Leverage**](https://leverage.binbash.co/) project.

E.g. [this addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) is a nice way to do it.

Paste this layer into the account/region chosen to host this, e.g. `apps-devstg/us-east-1/`, so the final layer is `apps-devstg/us-east-1/k8s-eks/`. Note you can change the layer name (and CIDRs and cluster name) if you already have an EKS cluster in this Account/Region.

#### 1 - Create the network

First go into the network layer (e.g. `apps-devstg/us-east-1/k8s-eks/network`) and config the Terraform S3 background key, CIDR for the network, names, etc.

```shell
cd apps-devstg/us-east-1/k8s-eks/network
```

Then, from inside the layer run:

```shell
leverage tf init
leverage tf apply
```

#### 2 - Add the path to the VPN server

Since we are working on a private subnet (as per the [**binbash Leverage**](https://leverage.binbash.co/) and the AWS Well Architected Framework best practices), we need to set the VPN routes up.

If you are using the [Pritunl VPN server](../VPN-server/) (as per the [**binbash Leverage**](https://leverage.binbash.co/) recommendations), add the route to the CIDR set in the step 1 to the server you are using to connect to the VPN.

Then, connect to the VPN to access the private space.

#### 3 - Create the cluster

First go into each layer and config the Terraform S3 background key, names, addons, the components to install, etc.

!!! Note
    If you are using [SSO](../../ref-architecture-aws/features/sso/overview/) with the [Landing Zone](https://leverage.binbash.co/try-leverage/), the [**binbash Leverage**](https://leverage.binbash.co/) recommended way to access your resources, note you have to set the right role name in file `cluster/locals.tf` under `map_roles` object.

```shell
cd apps-devstg/us-east-1/k8s-eks/
```

Then apply layers as follow:

```shell
leverage tf init --layers cluster,identities,addons,k8s-components
leverage tf apply --layers cluster,identities,addons,k8s-components
```

#### 4 - Access the cluster

Go into the cluster layer:

```shell
cd apps-devstg/us-east-1/k8s-eks/cluster
```

Use the embedded `kubectl` to config the context:

```shell
leverage kubectl configure
```

!!! Info
    You can export the context to use it with stand alone `kubectl`.

Once this process is done, you'll end up with temporary credentials created for `kubectl`.

Now you can try a `kubectl` command, e.g.:

```shell
leverage kubectl get ns
```

!!! Info
    If you've followed the [**binbash Leverage**](https://leverage.binbash.co/) recommendations, your cluster will live on a private subnet, so you need to connect to the VPN in order to access the K8s API.

!!! Attention
    **About Destroying the cluster**</br></br>
    Note if you will delete the cluster you have to do so in order, i.e. with:</br>`--layers k8s-components,addons,identities,cluster,network`.</br>(if you have applyed the `k8s-workloads` layer it has to go first.)</br></br>
    Also note that when destroying the `network` layer you'll see an error saying the flow logs bucket can not be deleted.</br>It makes sense for a security reason (to keep the logs). If you want to delete the layer you must empty the bucket first.
