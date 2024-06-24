# How to create a VPN Server

## Goal

To create a VPN server to access all the private networks (or at least, those ones "peered" to the VPN one) in the Organization.

### Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, `apps-devstg` and `shared` were created and region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

---

---

## How to

As per [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) defaults, the VPN server will be created in a public network of the `shared` base-network VPC.

It is a "Pritunl" server.

All the networks that should be accessible from the VPN must:

- be "peered" to the `shared` base-network VPC
- their CIDR have to be added to the "Pritunl" server

This Pritunl server will be deployed in an EC2 instance.

Note this instance can be started/stopped in an scheduled fashion, see [here](/user-guide/cookbooks/schedule-start-stop-ec2) for more info. (Note also, if no EIP is being used, when the instance is stopped and then started again the IP will change.)

These are the steps:

- create the EC2 instance
- deploy Pritunl
- configure Pritunl

### Create the EC2

#### Copy the layer

A few methods can be used to download the [VPN Server layer](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/tools-vpn-server) directory into the [**binbash Leverage**](https://leverage.binbash.co/) project.

E.g. [this addon](https://addons.mozilla.org/en-US/firefox/addon/gitzip/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search) is a nice way to do it.

Paste this layer into the account/region chosen to host this, e.g. `shared/us-east-1/`, so the final layer is `shared/us-east-1/tools-vpn-server/`.

!!! info
    As usual when copying a layer this way, remove the file `common-variables.tf` and soft-link it to your project level one. E.g. `rm common-variables.tf && ln -s ../../../config/common-variables.tf common-variables.tf`.

#### Update the layer

Change as per your needs. At a minimum, change the S3 backend key in `config.tf` file and in file `ec2.tf` update the objects `dns_records_public_hosted_zone` and `dns_records_internal_hosted_zone` with your own domain.

Also, temporarily, allow access to port 22 (SSH) from Internet, so we can access the instance with Ansible.

To do this, in file `ec2.tf` chage this:

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

...to this:

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

...and this:

```terraform
  /*  dns_records_public_hosted_zone = [{
    zone_id = data.terraform_remote_state.dns.outputs.aws_public_zone_id[0],
    name    = "vpn.aws.binbash.co",
    type    = "A",
    ttl     = 300
  }]*/
```

...to this:

```terraform
  dns_records_public_hosted_zone = [{
    zone_id = data.terraform_remote_state.dns.outputs.public_zone_id,
    name    = "vpn.binbash.co",
    type    = "A",
    ttl     = 300
  }]
```

Also, to access in port 443 this need to be changed from this:

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

to this

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

#### Apply the layer

As usual:

```shell
leverage tf init 
leverage tf apply
```

### Deploy Pritunl

#### SSH connection

To do this SSH access is needed. For this a new key pair will be created to allow you to run `ansible`.

Create a key pair, more [here](https://www.ssh.com/academy/ssh/keygen), or use an already created one.

Store the keys in a safe place.

Copy the content of the public key.

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

!!! info
    `ubuntu` is the default user for the default image used here, if needed change it.
    
!!! info
    In this command you can use the public URL that was set, in the example `vpn.binbash.co`.

#### Run Ansible

!!! info
    It seems to be obvious but... you need Ansible installed.
    
This Ansible repo will be used here: [Pritunl VPN Server Playbook](https://github.com/binbashar/le-ansible-infra/tree/master/vpn-pritunl)

!!! alert
    This is a private repository, please get in touch with us to get access to it!

Copy the playbooks into your project repository. (e.g. you can create an `ansible` directory inside your [**binbash Leverage**](https://leverage.binbash.co/) project repository, so all your infraesctructure code is in the same place)

`cd` into the `ansible-pritunl-vpn-server` (or the name you've chosen) directory.

Follow the steps in the repository README file to install the server.

#### Connect and configure the server

`ssh` into the server and run this command: 

```shell
sudo pritunl default-password
```

Grab the user and password and use them as credentials in the web page at your public domain!

In the initial setup page and change the password and enter the domain in "Lets Encrypt Domain".

Hit Save.

##### A user and an organization

First things first, add a user.

Go to Users.

Hit Add Organization. 

Enter a name and hit Add.

Now Add User.

Enter a name, select the organization, enter an email and let the pin empty. 

Hit Add.

##### A new server

Now add a server to log into.

Go to Servers and hit "Add Server".

Enter the name, check "Enable Google Authenticator" and add it.

!!! info
    Note the Port and Protocol has to be in the range stated in the VPN Server layer, in the `ec2.tf` file under this block:
    ```terraform
    {
      from_port   = 15255, # Pritunl VPN Server public UDP service ports -> pritunl.server.admin org
      to_port     = 15257, # Pritunl VPN Server public UDP service ports -> pritunl.server.devops org
      protocol    = "udp",
      cidr_blocks = ["0.0.0.0/0"],
      description = "Allow Pritunl Service"
    }
    ```

Hit Attach Organization and attach the organization you've created.

Hit Attach.

Now hit Start Server.

##### A note on AWS private DNS

To use a Route53 private zone (where your private addresses are set), these steps have to be followed:

- Edit the server 
- In the "DNS Server" box (where `8.8.8.8` is set) add the internal DNS for the VPC
  - the internal DNS is x.x.x.2, e.g. if the VPC in which your VPN Server is is 172.18.0.0/16, then your DNS is 172.18.0.2
  - for the example, the final text is `172.18.0.2, 8.8.8.8` (note we are adding the `8.8.8.8` as a secondary DNS)
- Add a specific route for the DNS server, for the example `172.18.0.2/32`
- Then add all the other routes you need to access your resources, e.g. to access the VPN Server's VPC this route must be added: `172.18.0.0/16`

##### Use the user to log into the VPN

Go to Users.

Click the chain icon (Temporary Profile Link) next to the user.

Copy the "Temporary url to view profile links, expires after 24 hours" link and send it to the user.

The user should open the link.

The user has to create an OTP with an app such as Authy, enter a PIN, copy the "Profile URI Link" and enter it in the "import > profile URI" in the Pritunl Client.
    
Start the VPN and enjoy being secure!

## Set back security

Set back all the configurations to access the server and apply the layer:


```terraform
    {
      from_port = 22, # SSH
      to_port   = 22,
      protocol  = "tcp",
      #cidr_blocks = ["0.0.0.0/0"],
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block],
      description = "Allow SSH"
    },
    
  /*  dns_records_public_hosted_zone = [{
    zone_id = data.terraform_remote_state.dns.outputs.aws_public_zone_id[0],
    name    = "vpn.aws.binbash.co",
    type    = "A",
    ttl     = 300
  }]*/

    {
      from_port = 443, # Pritunl VPN Server UI
      to_port   = 443,
      protocol  = "tcp",
      #cidr_blocks = ["0.0.0.0/0"], # Public temporally accessible for new users setup (when needed)
      cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block],
      description = "Allow Pritunl HTTPS UI"
    },
```
## Note about Routes

When you create a Pritunl VPN server, a VPN network CIDR is used, let's say `192.168.122.0/24`.

So, all the clients connecting to the VPN will be assigned with an IP in this range.

The VPN Server, at the same time, is living in a network, with its own IP in a given range, e.g. `10.20.0.0/16`, and it has a public IP.

Clients will be connecting to the public IP and reiceiving a VPN IP.

Now, we need to route the traffic. 

Let's say you have an internal network (to which the VPN Server has access) in the range `10.40.0.0/16`.

If you want the VPN clients to reach this network, you must Add a Route to the VPN server.

Go to the Servers page.

Stop the server you want to add the route to.

Hit Add Route.

Fill the CIDR (e.g. `192.168.69.0/24`), select the server name and hit Attach.

Start the server.

Also note the route `0.0.0.0./0` is added by default. This means all traffic go through the VPN server.

You can remove this and allow just the internal CIDRs.

## Lets Encrypt Domain

- must temporally open port 80 to the world (line 52)
- must temporally open port 443 to the world (line 59)
- must uncomment public DNS record block (lines 105-112)
- make apply
- connect to the VPN and ssh to the Pritunl EC2
- run '$sudo pritunl reset-ssl-cert'
- force SSL cert update (manually via UI or via API call)
  in the case of using the UI, set the "Lets Encrypt Domain" field with the vpn domain and click on save
- rollback steps a,b & c + make apply
