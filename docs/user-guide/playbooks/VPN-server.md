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
- its CIDR has to be added to the "Pritunl" server

This Pritunl server will be deployed in an EC2 instance.

Note this instance can be started/stopped in an scheduled fasion, see [here](/user-guide/playbooks/schedule-start-stop-ec2) for more info. Note also that if the instance is stopped when it is started again the IP will change. So, to keep the IP between runs, an EIP should be used.

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

Change as per your needs. At a minimum, change the S3 backend key in `config.tf` file and in file `ec2.tf` update the object `dns_records_internal_hosted_zone` with your own domain.

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

Connect to the instance (connect button) using SSM.

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
    
This Ansible repo will be used here: [Pritunl VPN Server Playbook](https://gitlab.com/ansible-kungfoo/ansible-pritunl-vpn-server)

Copy the [VPN ansible repository](https://gitlab.com/ansible-kungfoo/ansible-pritunl-vpn-server) into your project repository. (e.g. you can create an `ansible` directory inside your [**binbash Leverage**](https://leverage.binbash.co/) project repository, so all your infraesctructure code is in the same place)

`cd` into the `ansible-pritunl-vpn-server` directory.

If you don´t have your password file just create it:

```shell
echo 'your-password-here' > .vault_pass
```

!!! warning
    Keep your password safe and avoid uploading it to the repo adding the file to the `.gitignore` file: `echo ".vault_pass" >> ../../.gitignore` (check the path)
    

- copy `.hosts.example` to `.hosts`
- copy `.config.cfg.example` to `.config.cfg`
- copy `group_vars/all.yml.example` to `group_vars/all.yml`
- copy `group_vars/secrets.enc.yml.example` to `group_vars/secrets.enc.yml`

- edit `.hosts` file and change the `ansible_host` and `ansible_ssh_private_key_file` parameters, the former with the host names you selected before, the later with the path to your private key.
- edit `group_vars/all.yaml` file and update the values as per your needs
- edit the `group_vars/secrets.enc.yml` with the passwords for your users ([a-zA-Z0-9])
- encrypt the `group_vars/secrets.enc.yml` file:

```shell
ansible-vault encrypt --vault-password-file=.vault_pass --encrypt-vault-id=default group_vars/secrets.enc.yml
```

- edit `ansible.cfg` file and set the `vault_password_file` to the right path (pointing to `.vault_pass` file)
- edit `setup.yaml` file and update the host sections so the public access is used:

```yaml
  hosts:
    # At first, you provision the instance through its public DNS name
    - pritunl_public
    # After that, you can use the private one
    #- pritunl_private
```

!!! info
    This first time the public access has to be used since we don't have VPN now!
    
Run the playbooks:

```shell
ansible-playbook setup.yml
```

#### Connect and configure the server

`ssh` into the server and run this command: 

#```shell
#sudo pritunl setup-key
#```
#
#Grab the key and go to:
#
#`https://your-url`
#
#Enter the key.
#
#
#wait for it to configure
#
#go back to the server and run 

```shell
sudo pritunl default-password
```

grab the user and password and use them as credentials in the web page!

In the initial setup page set the "Lets Encrypt Domain" and (if needed) change the password.

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

Hit Attach Organization and attach the organization you've created.

Hit Attach.

Now hit Start Server.

##### Use the user to log into the VPN

Go to Users.

Click the chain icon (Temporary Profile Link) next to the user.

Copy the "Temporary url to view profile links, expires after 24 hours" link and send it to the user.

The user should open the link.

The user has to create an OTP with an app such as Authy, enter a PIN, copy the "Profile URI Link" and enter it in the "import > profile URI" in the Pritunl Client.
    
Start the VPN and enjoy being secure!

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
