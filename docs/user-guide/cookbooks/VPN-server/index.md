# How to create a VPN Server

## Goal

To create a VPN server to access all the private networks (or at least, those ones "peered" to the VPN one) 
in the Organization.

!!! note "Assumptions"
    We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, `apps-devstg` and `shared` were
    created and region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

## VPN Solution Alternatives

### 1. AWS Client VPN Endpoint

**Pros:**

- Fully managed AWS service - no infrastructure management required
- Native integration with AWS IAM and AWS SSO for authentication
- Automatic scaling and high availability
- Built-in security features and encryption
- Direct integration with VPC networking
- Supports split-tunnel VPN configurations
- CloudWatch integration for monitoring and logging

**Cons:**

- Limited customization options compared to self-managed solutions
- Requires AWS VPN client software on end-user devices
- Higher cost as you pay for:
    - Each VPN endpoint association per hour
    - Each client connection per hour
    - Data transfer fees

### 2. Pritunl VPN Server *on EC2*

**Pros:**

- One-time EC2 instance configuration  
- Constant cost: One EC2 instance (plus storage)  
- Full control over the VPN server configuration
- User-friendly web GUI for administration
- Supports multiple organizations and users
- Compatible with standard OpenVPN clients
- Flexible authentication options (certificates, 2FA)
- Can be scheduled to start/stop to reduce costs
- Custom routing and network configurations

**Cons:**

- Requires manual setup and maintenance
- Self-managed security updates and patches
- High availability requires additional configuration
- Scaling requires manual intervention
- Infrastructure management overhead
- Dependent on EC2 instance availability

### Key Considerations

| **Aspect** | **AWS Client VPN** | **Pritunl** |
|------------|--------------------|-------------|
| Setup Complexity | Simple setup through AWS Console or IaC | Requires EC2 instance setup, software installation, and configuration |
| Administration | Managed through AWS Console, simple user management with SSO | Web GUI interface, certificate management, more hands-on administration |
| Scalability | Automatic scaling, managed by AWS | Manual scaling, dependent on EC2 instance size |
| Reliability | Built-in high availability | Requires custom HA setup if needed |


### Use Case Recommendations

**Choose AWS Client VPN when:**

- You need a managed solution with minimal overhead
- Your organization uses AWS SSO
- You require automatic scaling and high availability
- Budget is not a primary concern

**Choose Pritunl when:**

- Cost optimization is important
- You need full control over the VPN configuration
- You have technical expertise for maintenance
- You want to leverage existing OpenVPN clients
- You need to implement custom routing or configurations


## How to

### Pritunl

As per [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) defaults, the VPN server will be created in a public network of 
the `shared` base-network VPC.

It is a "Pritunl" server.

All the networks that should be accessible from the VPN must:

- be "peered" to the `shared` base-network VPC
- their CIDR have to be added to the ["Pritunl VPN" server](https://pritunl.com/)

This Pritunl server will be deployed in an EC2 instance.

Note this instance can be started/stopped in an scheduled fashion, see [here](/user-guide/cookbooks/schedule-start-stop-ec2) for more info. 
(Note also, if no EIP is being used, when the instance is stopped and then started again the IP will change.)

#### Deployment Steps
1. [Create the EC2 instance with OpenTofu](./VPN-server-opentofu.md)
2. [Deploy Pritunl VPN Server with Ansible](./VPN-server-ansible.md)
3. [Configure Pritunl from its web GUI interface](./VPN-server-gui-setup.md)

### AWS VPN Client

For detailed instructions on implementing AWS Client VPN, including endpoint configuration, authentication setup, and network associations, please refer to our [AWS Client VPN implementation guide](https://github.com/binbashar/le-tf-infra-aws/blob/master/network/us-east-1/client-vpn/README.md). The guide provides step-by-step procedures for creating a secure VPN connection, configuring authorization rules, and managing client access using AWS best practices.
