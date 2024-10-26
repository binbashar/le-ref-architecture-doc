# How to create a VPN Server: Pritunl

## Goal

To create a VPN server to access all the private networks (or at least, those ones "peered" to the VPN one) 
in the Organization.

!!! note "Assumptions"
    We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, `apps-devstg` and `shared` were
    created and region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

## How to

As per [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) defaults, the VPN server will be created in a public network of 
the `shared` base-network VPC.

It is a "Pritunl" server.

All the networks that should be accessible from the VPN must:

- be "peered" to the `shared` base-network VPC
- their CIDR have to be added to the ["Pritunl VPN" server](https://pritunl.com/)

This Pritunl server will be deployed in an EC2 instance.

Note this instance can be started/stopped in an scheduled fashion, see [here](/user-guide/cookbooks/schedule-start-stop-ec2) for more info. 
(Note also, if no EIP is being used, when the instance is stopped and then started again the IP will change.)

## DEPLOYMENT STEPS
1. [Create the EC2 instance with Terraform](./VPN-server-terraform.md)
2. [Deploy Pritunl VPN Server with Ansible](./VPN-server-ansible.md)
3. [Configure Pritunl from its web GUI interface](./VPN-server-gui-setup.md)