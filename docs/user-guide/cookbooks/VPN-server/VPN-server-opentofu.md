# Create the EC2 OpenTofu layer

## Getting the reference code

The VPN Server layer is located here: https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/tools-vpn-server
It contains the code you will use as a reference for building your own implementation. You just need to download that directory and place it within the directory structure of your Leverage project.

For instance, that layer usually goes within your Shared account folder and within your primary region folder, which in the case of the Reference Architecture is this: `shared/us-east-1/tools-vpn-server/`.

!!! warning "Important"
    As usual when copying a layer this way, you need to remove the `common-variables.tf` file and then soft-link it to the file located in the config folder of the root directory of your Leverage project. E.g. `rm common-variables.tf && ln -s ../../../config/common-variables.tf .`.

## Adjusting the code

Given that the layer you copied is configured to Binbash's implementation, you'll need to tweak it a little bit so it fits with your project.

The adjustments you'll need to make are only temporarily and include steps like granting yourself access to common ports 22 (SSH) and port 443 (HTTPS), and creating DNS records.

!!! warning "DNS: AWS Route53 Hosted Zones and Domain Delegation"
    If you're using the Leverage Landing Zone, you will use the already deployed [AWS Route53 layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/global/base-dns/binbash.co)
    and the hosted zones in it. In most cases you'll need to delegate your `domain.com` 
    (eg: `binbash.co`) or a subdomain eg: `aws.domain.com` passing the `ns` from your
    Route53 public hosted zone. 

Let's start with a few adjustments. Open the [`ec2.tf`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/tools-vpn-server/ec2.tf) file for editing. Now, locate the following block, read the comments to understand what is it for, and then add your IP to the `cidr_blocks` list:

```terraform
    {
      from_port = 22, # SSH
      to_port   = 22,
      protocol  = "tcp",
      cidr_blocks = [
        # SSH access is allowed while connected to the VPN
        data.terraform_remote_state.vpc.outputs.vpc_cidr_block,
        #
        # NOTE: During the first installation, it is convenient to add your
        #       IP here (unless you are planning to use SSM instead).
        #
      ],
      description = "Allow SSH"
    },
```

Now, do something similar in this other block:

```terraform
    {
      from_port = 443, # Pritunl VPN Server UI
      to_port   = 443,
      protocol  = "tcp",
      cidr_blocks = [
        # Access to Pritunl Admin Web from the VPN is allowed
        data.terraform_remote_state.vpc.outputs.vpc_cidr_block,
        # NOTE: Opening port 443 is usually required for onboarding new users,
        #       so they can set up their pin code and OTP. A more secure option
        #       is to whitelist each user's IP.
        #"0.0.0.0/0",
      ],
      description = "Allow Pritunl HTTPS UI"
    },
```

Now, locate this block and uncomment it:
```terraform
  /*  dns_records_public_hosted_zone = [{
    zone_id = data.terraform_remote_state.dns.outputs.aws_public_zone_id,
    name    = "vpn.aws.binbash.com.ar",
    type    = "A",
    ttl     = 300
  }]*/
```

!!! info "An important note on DNS"
    Replace the domain with your own. A public record is being created so we can reach the server.

Finally, make sure you review the rest of the code to spot other parts you may want to adjust to your needs, for instance:

* [Key pair name](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/tools-vpn-server/ec2.tf#L18): this is SSH key that will be used for connecting to the instance.
* VPC settings: VPC id and subnets.
* SSM access: which can be used to access the instance via SSM instead of SSH.


## Applying the changes

As usual, just follow the [Terraform/OpenTofu workflow](/user-guide/ref-architecture-aws/workflow/#the-basic-workflow) to initialize, plan, and apply the changes:

```shell
leverage tf init 
leverage tf plan
leverage tf apply
```

## Connecting to the EC2 instance

There are at last two options to connect to the EC2 instance: SSH and SSM.

### Option 1: Connect via SSH
Here you simply need the public IP of the instance and the private key associated to the public key that is defined in 
[this layer](https://github.com/binbashar/le-tf-infra-aws/blob/2d573360a60f1ca48019bd00f845236d6127cfb0/shared/us-east-1/security-keys/variables.tf#L17).

Using both you can run this command:

```shell
ssh -i <path-to-your-private-key> ubuntu@<the-instance-public-ip>
```

When prompted to accept the fingerprint, type "yes" and hit enter.

### Option 2: Connect via SSM
Browse to the [AWS Management Console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Home:). Make sure you are in the `shared` account.

Locate the instance, select it and then click on the "Connect" button. You should get SSH-like access via a Web Terminal interface.
