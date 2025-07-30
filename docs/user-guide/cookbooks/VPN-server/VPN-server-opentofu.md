## Create the EC2 OpenTofu layer

### Copy the layer

A few methods can be used to download the [VPN Server layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/tools-vpn-server) directory into the [**binbash Leverage**](https://leverage.binbash.co/) project.

E.g. [this addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) is a nice way to do it.

Paste this layer into the account/region chosen to host this, e.g. `shared/us-east-1/`, so the final layer is `shared/us-east-1/tools-vpn-server/`.

!!! info
    As usual when copying a layer this way, remove the file `common-variables.tf` and soft-link it to your project 
level one. E.g. `rm common-variables.tf && ln -s ../../../config/common-variables.tf common-variables.tf`.

### Update the layer

Change as per your needs. At a minimum, change the S3 backend key in [`config.tf`](https://github.com/binbashar/le-tf-infra-aws/blob/2d573360a60f1ca48019bd00f845236d6127cfb0/shared/us-east-1/tools-vpn-server/config.tf#L20) 
file and in file [`ec2.tf`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/tools-vpn-server/ec2.tf) update the
objects [`dns_records_public_hosted_zone`](https://github.com/binbashar/le-tf-infra-aws/blob/efe68338a6cd67c41dfb756bd451c770fd9b8ada/shared/us-east-1/tools-vpn-server/ec2.tf#L104) 
and [`dns_records_internal_hosted_zone`](https://github.com/binbashar/le-tf-infra-aws/blob/efe68338a6cd67c41dfb756bd451c770fd9b8ada/shared/us-east-1/tools-vpn-server/ec2.tf#L76) with your own domain.

!!! warning "DNS: AWS Route53 Hosted Zones and Domain Delegation"
    If you're using the Leverage LZ you will use the already deployed [AWS Route53 layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/global/base-dns/binbash.co)
    and the hosted zones in it. In most cases you'll need to delegate your `domain.com` 
    (eg: `binbash.co`) or a subdomain eg: `aws.domain.com` passing the `ns` from your
    Route53 public hosted zone. 

Also, temporarily, allow access to port 22 (SSH) so we can access the instance with Ansible. 
Moreover, open port 443 (HTTPS) and create the public DNS record to access the Pritunl web interface.

To do this, in file [`ec2.tf`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/tools-vpn-server/ec2.tf) change this

**From:**

```terraform
    {
      from_port = 22, # SSH
      to_port   = 22,
      protocol  = "tcp",
      #cidr_blocks = ["0.0.0.0/0"],
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block],
      description = "Allow SSH"
    },
```

**To:**

```terraform
    {
      from_port = 22, # SSH
      to_port   = 22,
      protocol  = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
      #cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block],
      description = "Allow SSH"
    },
```

**and DNS from:**

```terraform
  /*  dns_records_public_hosted_zone = [{
    zone_id = data.terraform_remote_state.dns.outputs.aws_public_zone_id[0],
    name    = "vpn.aws.binbash.co",
    type    = "A",
    ttl     = 300
  }]*/
```

**To:**

```terraform
  dns_records_public_hosted_zone = [{
    zone_id = data.terraform_remote_state.dns.outputs.public_zone_id,
    name    = "vpn.binbash.co",
    type    = "A",
    ttl     = 300
  }]
```

Also, to access in port 443 this need to be changed **from**:

```terraform
    {
      from_port = 443, # Pritunl VPN Server UI
      to_port   = 443,
      protocol  = "tcp",
      #cidr_blocks = ["0.0.0.0/0"], # Public temporally accessible for new users setup (when needed)
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block],
      description = "Allow Pritunl HTTPS UI"
    },
```

**To:**

```terraform
    {
      from_port = 443, # Pritunl VPN Server UI
      to_port   = 443,
      protocol  = "tcp",
      cidr_blocks = ["0.0.0.0/0"], # Public temporally accessible for new users setup (when needed)
      #cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block],
      description = "Allow Pritunl HTTPS UI"
    },
```

!!! info
    Replace the domain with your own. A public record is being created so we can reach the server.

### Apply the layer

As usual:

```shell
leverage tf init 
leverage tf plan
leverage tf apply
```

## SSH connection

For this a new key pair will be created, same one that will be used for `ansible` provisioning.

Create a key pair, more [here](https://www.ssh.com/academy/ssh/keygen), or use an already created one.

Store the keys in a safe place.

Then you have 2 options to set up the SSH key pair in your EC2:

#### Opt-1: Via OpenTofu 
Copy the content of the public key in the associated 
[shared/us-east-1/security-keys layer variable](https://github.com/binbashar/le-tf-infra-aws/blob/2d573360a60f1ca48019bd00f845236d6127cfb0/shared/us-east-1/security-keys/variables.tf#L17).

And pass this at the [**ec2.tf** `key_pair_name = data.terraform_remote_state.keys.outputs.aws_key_pair_name`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/tools-vpn-server/ec2.tf) parameter

Check the connection:

```shell
ssh -i <path-2-your-private-key> ubuntu@<the-instance-public-ip>
```

When prompted to accept the fingerprint, type "yes" and hit enter.

#### Opt-2: Via Web Console SSM access
Access the EC2 instance from [AWS Web Console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Home:). (use the `shared` account)

Connect to the instance (connect button) using SSM (Session Manager).

Once in the instance terminal, paste the copied content in the to the authorized keys file:

```shell
sudo bash -c 'echo "ssh-ed25519 yourkey binbhash-AWS-instances" >> /home/ubuntu/.ssh/authorized_keys'
```

*Replace the content between double quotes with your private key content*

Check the connection:

```shell
ssh -i <path-2-your-private-key> ubuntu@<the-instance-public-ip>
```

When prompted to accept the fingerprint, type "yes" and hit enter.

!!! info "CONSIDERATIONS"
    `ubuntu` is the default user for the default image used here, if needed change it.
    In this command you can use the public URL that was set, in the example `vpn.binbash.com.ar`.
