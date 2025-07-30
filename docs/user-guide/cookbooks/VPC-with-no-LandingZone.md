# VPC with no Landing Zone

## What

Do you want to try [**binbash Leverage**](/) but you are not willing to transform yet your already existent infra to the [**binbash Leverage Landing Zone**](/try-leverage/) (honoring the [AWS Well Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html))?

With this cookbook you will create a VPC with all the benefits **binbash Leverage** [network layer](/user-guide/ref-architecture-aws/features/network/vpc-addressing/) provides.


!!! info "If you want to use the Full **binbash Leverage Landing Zone** please visit the [Try Leverage section](/try-leverage/)"
    This will give you the full power of **binbash Leverage** and the [AWS Well Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html).

## Why

Maybe because you found **binbash Leverage** but you want to try it out first before you convert your base infra.

## How
 
### Objective

We will create a simple VPC (with all its resources) and an will add an EC2 instance to it so we can test it for real.

### What you need:

- an AWS account
- a user with programmatic access keys and the keys
- **binbash Leverage**

### Common Process

Ok, just [install binbash Leverage](/try-leverage/local-setup/) and [create the Leverage project](/try-leverage/leverage-project-setup/). When creating credentials, do it for MANAGEMENT type. 
Basically:
```bash
mkdir project && cd project
leverage project init
## edit the yaml file
leverage project create
leverage credentials configure --type MANAGEMENT
```

You end up with this structure:
```bash
❯ tree -L 2 .
.
├── build.env
├── config
│   └── common.tfvars
├── management
│   ├── config
│   ├── global
│   └── us-east-1
├── Pipfile
├── Pipfile.lock
├── project.yaml
├── security
│   ├── config
│   └── us-east-1
└── shared
    ├── config
    └── us-east-1

```


Create a dummy account dir.

Despite we won't create a real account (since there is no Landing Zone), we'll have to create a dir to hold all the layers we need.

```bash
mkdir -p apps-dummy/us-east-1/
```

Copy the config files:

```bash
cp -r shared/config apps-dummy/
```

In `config/account.tfvars` change this:
```yaml
## Environment Name
environment = "shared"
```
to this
```yaml
## Environment Name
environment = "apps-dummy"
```
(note the environment is the same as the created dir)

In `config/backend.tfvars` change this:
```yaml
profile = "bm-shared-oaar"
```
to this:
```yaml
profile = "bm-management"
```


### VPC Process

Copy the network layer:

```bash
cp -r shared/us-east-1/base-network apps-dummy/us-east-1/
```

Go into the layer:

```bash
cp -r shared/us-east-1/base-network apps-dummy/us-east-1/
cd apps-dummy/us-east-1/base-network
```

Since we are testing we won't use the S3 backend (we didn't create the bucket, but you can do it easily with the `base-tf-backend` layer), so comment this line in `config.tf` file:

```yaml
  #backend "s3" {
  #  key = "shared/network/terraform.tfstate"
  #}
```

Initialize the layer:

```bash
leverage tf init --skip-validation
```

Note the `skip-validation` flag. This is needed since we are using local tfstate.

Plan it:
```bash
leverage tf plan
```

If you are happy (or you are unhappy but you are ok with the plan), apply it:
```bash
leverage tf apply
```

You should end up with something like this:
```bash
Apply complete! Resources: 20 added, 0 changed, 0 destroyed.

Outputs:

availability_zones = [
  "us-east-1a",
  "us-east-1b",
]
nat_gateway_ids = []
private_route_table_ids = [
  "rtb-065deXXXXXXX86b6d",
]
private_subnets = [
  "subnet-0aXXXXXXXXXXd80a6",
  "subnet-0bXXXXXXXXXX0ff67",
]
private_subnets_cidr = [
  "172.18.0.0/21",
]
public_route_table_ids = [
  "rtb-01XXXXXXXXXXXX887",
]
public_subnets = [
  "subnet-0648XXXXXXXXX69",
  "subnet-0297XXXXXXXXf10",
]
public_subnets_cidr = [
  "172.18.8.0/21",
]
vpc_cidr_block = "172.18.0.0/20"
vpc_id = "vpc-0aXXXXXXXXXX06d8f"
vpc_name = "bm-apps-dummy-vpc"
```

### EC2 Process

Great, now we can go for the EC2!

#### Get the layer

For this step we'll go for a layer that can be found in the **binbash Leverage RefArch** under [this directory](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/ec2-fleet-ansible%20--).

You can download a directory from a git repository using [this Firefox addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/) or any method you want.

Note when you copy the layer (e.g. with gitzip), the file `common-variables.tf` , which is a soft link, was probably copied as a regular file. 
If this happens, delete it:

```bash
cd ec2-fleet-ansible\ --
rm common-variables.tf
```

#### Prepare the layer

Again, since we are not running the whole **binbash Leverage Landing Zone** we need to comment out these lines in `config.tf`:

```yaml
  #backend "s3" {
  #  key = "apps-devstg/ec2-fleet-ansible/terraform.tfstate"
  #}
```

Also in this file, comment out these two resources:
```yaml
data "terraform_remote_state" "security" {
data "terraform_remote_state" "vpc-shared" {
```

And change `vpc` to be like this:
```yaml
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../base-network/terraform.tfstate"
  }
}
```
Again, since we are not using the full **binbash Leverage** capabilities, we are not using the S3 OpenTofu backend, thus the backend is local.

In `ec2_fleet.tf` update module version like this:
```yaml
  source = "github.com/binbashar/terraform-aws-ec2-instance.git?ref=v5.5.0"
```

Init the layer:
```bash
leverage tf init --skip-validation
```
(same as before with the skip flag)

Now, we need some common and specific vars that are not set.

So, create a `variables.tf` file with this content:

```yaml
variable "environment" {
  type        = string
  description = "Environment Name"
}
variable "profile" {
  type        = string
  description = "AWS Profile (required by the backend but also used for other resources)"
}
variable "region" {
  type        = string
  description = "AWS Region"
}
##=============================#
##  EC2 Attributes             #
##=============================#
variable "aws_ami_os_id" {
  type        = string
  description = "AWS AMI Operating System Identificator"
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "aws_ami_os_owner" {
  type        = string
  description = "AWS AMI Operating System Owner, eg: 099720109477 for Canonical "
  default     = "099720109477"
}

## security.tf file
##=============================#
##  SSM Attributes             #
##=============================#
variable "instance_profile" {
  type        = string
  description = "Whether or not to create the EC2 profile, use null or 'true'"
  default     = "true"
}

variable "prefix" {
  type        = string
  description = "EC2 profile prefix"
  default     = "fleet-ansible"
}

variable "name" {
  type        = string
  description = "EC2 profile name"
  default     = "ssm-demo"
}

variable "enable_ssm_access" {
  type        = bool
  description = "Whether or not to attach SSM policy to EC2 profile IAM role, use false or true"
  default     = true
}
```
(set the Ubuntu image as per your needs)

In `ec2_fleet.tf` file comment these lines:

```yaml
 # data.terraform_remote_state.vpc-shared.outputs.vpc_cidr_block

 # key_name               = data.terraform_remote_state.security.outputs.aws_key_pair_name
```
...again, due to the lack of the whole **binbash Leverage Landing Zone**... 

If you plan to access the instance from the Internet (EC2 in a public subnet)(e.g. to use Ansible), you change the first line to `"0.0.0.0/0"`. (or better, a specific public IP)

If you want to add an SSH key (e.g. to use Ansible), you can [generate a new SSH key](https://www.ssh.com/academy/ssh/keygen), add a resource like this:
```yaml
resource "aws_key_pair" "devops" {
  key_name   = "devops-key"
  public_key = "ssh-ed25519 AAAAC3N9999999999999999999999999eF Binbash-AWS-instances"
}

```
And replace the line in `ec2_fleet.tf` with this one:
```yaml
  key_name               = aws_key_pair.devops.key_name
```

In the same file, change `instance_type` as per your needs.

Also you can add this 
* * *to the `ec2_ansible_fleet` resource:
```yaml
  create_spot_instance = true
```
to create spot instances....
and this
```yaml
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
```
to add SSM access.



In `locals.tf` file check the variable `multiple_instances`. There the EC2 instances are defined, by default there are four.
Remember to set the subnets in which the instances will be created.

Finally, apply the layer:

```bash
leverage tf apply
```

Check your public IP and try to SSH into your new instance!

Have fun!

