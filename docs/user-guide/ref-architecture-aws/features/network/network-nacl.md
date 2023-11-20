# Security in AWS with Leverage Reference Architecture and NACLs
When deploying an AWS Landing Zone resources, security is of fundamental importance. Network Access Control Lists (NACLs) play a crucial role in controlling traffic at the subnet level. In this section we'll describe the use of NACLs implementing with Terraform over the **Leverage AWS Reference Architecture**.

## Understanding Network Access Control Lists (NACLs)
Network Access Control Lists (NACLs) act as a virtual firewall for your AWS VPC (Virtual Private Cloud), controlling inbound and outbound traffic at the subnet level. They operate on a rule-based system, allowing or denying traffic based on defined rules.

## Leverage Ref Arch: Default Configuration and Variables Setup for NACLs
In the Leverage Reference Architecture, we adopt the default NACLs approach.
This foundational setup not only ensures a controlled security environment but also offers the flexibility for customization.


This setup ensures that default NACLs are used, providing a baseline level of security.:
```bash
manage_default_network_acl    = true
public_dedicated_network_acl  = false // use dedicated network ACL for the public subnets.
private_dedicated_network_acl = false // use dedicated network ACL for the private subnets.
```
To verify that default NACLs are enabled in your Leverage proyect, follow this steps:

1. Move into the `/shared/us-east-1/base-network/` directory.


1. Open `network.tf` file:
  The `network.tf` file defines the configuration for the VPC (Virtual Private Cloud) and NACL service using a terraform module.
    ```bash
    module "vpc" {
    source = "github.com/binbashar/terraform-aws-vpc.git?ref=v3.18.1"
    .
    .
    .
    manage_default_network_acl    = var.manage_default_network_acl
    public_dedicated_network_acl  = var.public_dedicated_network_acl  // use dedicated network ACL for the public subnets.
    private_dedicated_network_acl = var.private_dedicated_network_acl // use dedicated network ACL for the private subnets.
    .
    .
    .
    ```


1. Open `variable.tf` file:
  The module allows customization of Network Access Control Lists (NACLs) through specified variables
    ```bash
    variable "manage_default_network_acl" {
     description = "Manage default Network ACL"
     type        = bool
     default     = true
    }
    variable "public_dedicated_network_acl" {
      description = "Manage default Network ACL"
      type        = bool
      default     = false
    }
    variable "private_dedicated_network_acl" {
      description = "Manage default Network ACL"
      type        = bool
      default     = false
    }
    ```


## Key Points to kae into account for a robust and secure setup:
1. **Explicit Approval Process for NACL Enablement:**
Enabling NACLs should not be taken lightly. Users or tech leads wishing to enable NACLs must undergo an explicit approval process. This additional step ensures that the introduction of NACLs aligns with the overall security policies and requirements of the organization.

1. **Feedback Mechanisms for NACL Status and Permissions:**
Communication is key when it comes to security configurations. Feedback mechanisms should be in place to inform users of the status of NACLs and any associated permissions. This ensures transparency and allows for prompt resolution of any issues that may arise.

1. **Comprehensive Testing for Non-disruptive Integration:**
Before enabling NACLs, comprehensive testing should be conducted to ensure that the default disabling of NACLs does not introduce new issues. This includes testing in different environments and scenarios to guarantee a non-disruptive integration. Automated testing and continuous monitoring can be valuable tools in this phase.



## Conclusion
We prioritize operational simplicity to provide an efficient deployment process; however, it's essential for users to conduct a review process align with their specific security and compliance requirements.

This approach allows users to benefit from initial ease of use while maintaining the flexibility to customize and enhance security measures according to their unique needs and compliance standards

In this code, we ensure that default NACLs are enabled. Users can later seek approval and modify these variables if enabling **dedicated NACLs** becomes necessary.
