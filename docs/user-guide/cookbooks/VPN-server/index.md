# Setting up a VPN Server

## Overview

Companies use Client VPNs primarily to give remote employees secure access to internal company resources, protect data transmission over public networks, and maintain security policies and compliance requirements for workers outside the office.

This post explores a couple of alternatives that we have successfully implemented for our clients. It then goes on to provide detailed instructions on how to set up your own Client VPN.

## Comparing alternatives

Two common approaches cover most needs: a managed service (AWS Client VPN) and a self‑hosted server (Pritunl on EC2).

- **AWS Client VPN**: Managed by AWS, integrates with IAM/SSO, auto-scales and offers high availability out of the box. Trade-offs are higher ongoing costs and fewer low-level customization options.
- **Pritunl on EC2**: Full control and OpenVPN compatibility with a predictable EC2-based cost; you own patching, scaling, and any high-availability setup.

Refer to the [VPN Solutions Comparison](./VPN-comparison.md) page for a full, side‑by‑side comparison.

## Implementation Guide

### Spinning up a Pritunl server on AWS EC2

This section provides instructions to stand up a Pritunl server on AWS EC2.

!!! note "Pre-requisites"
    Before you start, this guide makes the following assumptions:

    - Your AWS infrastructure follows the conventions of the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/).
    - We will be using region `us-east-1`.
    - We will deploy the EC2 instance on a public subnet of the `shared` VPC.
    - We will use an Elastic IP so the EC2 instance can be started/stopped without worrying about getting a new public IP address every time you start the instance.

!!! tip "Hint"
    If you would like to start/stop this instance in an scheduled fashion, check [here](/user-guide/cookbooks/schedule-start-stop-ec2).

#### Deployment Steps

Our Pritunl deployment consists of 3 steps:

1. [Creating the EC2 instance via Terraform/OpenTofu](./VPN-server-opentofu.md)
2. [Installing Pritunl via Ansible](./VPN-server-ansible.md)
3. [Configuring Pritunl through the Web Admin](./VPN-server-gui-setup.md)


### AWS VPN Client

For detailed instructions on implementing AWS Client VPN, including endpoint configuration, authentication setup, and network associations, please refer to our [AWS Client VPN implementation guide](https://github.com/binbashar/le-tf-infra-aws/blob/master/network/us-east-1/client-vpn/README.md). The guide provides step-by-step procedures for creating a secure VPN connection, configuring authorization rules, and managing client access using AWS best practices.
