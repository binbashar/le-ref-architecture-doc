# Leverage CLI used to operate Binbash Leverage stack.

## Overview

In order to get the full automated potential of the
[Binbash Leverage Infrastructure as Code (IaC) Library](https://leverage.binbash.com.ar/how-it-works/code-library/code-library/)
and the [Reference Architecture for AWS](https://leverage.binbash.com.ar/how-it-works/) you should 
install and use the [leverage cli](https://github.com/binbashar/leverage). 

!!! faq "How?"
    For all supported modules and infra components you could use the cli helper `leverage` command at any context
    
    ```shell
    ╭─    ~/B/r/L/r/le-tf-infra-aws  on   master ·········· ✔  at 11:57:03 
    ╰─ leverage
    [DEBUG] Found config file: /Users/exequielbarrirero/Binbash/repos/Leverage/ref-architecture/le-tf-infra-aws/build.env
    Tasks in build file build.py:
    apply                          Build or change the Terraform infrastructre in this layer. For instance:
    > leverage apply
    > leverage apply["-auto-approve"]
    decrypt                        Decrypt secrets.tf file.
    destroy                        Destroy terraform infrastructure in this layer.
    encrypt                        Encrypt secrets.dec.tf file.
    format                         Rewrite all Terraform files to meet the canonical format.
    format_check                   Check if Terraform files do not meet the canonical format.
    init                           Initialize Terraform in this layer. For instance:
    > leverage init
    > leverage init["-reconfigure"]
    output                         Show all terraform output variables of this layer. For instance:
    > leverage output
    > leverage output["-json"]
    plan                           Generate a Terraform execution plan for this layer.
    shell                          Open a shell into the Terraform container in this layer.
    state                          Perform Terraform state operations.
    validate_layout                Validate the layout convention of this Terraform layer.
    version                        Print terraform version.
    
    Powered by Leverage 0.0.18 - A Lightweight Python Build Tool based on Pynt.
    ```

!!! faq "Why?"
    You'll get all the necessary commands to automatically operate this module via a dockerized approach,
    example shown below for the different tech stack components 

### Terraform 

!!! tip "![leverage-terraform](../../assets/images/logos/terraform.png "Leverage"){: style="width:20px"}"
    ```shell
    ╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
    ╰─⠠⠵ leverage terraform
    ```

### Ansible

!!! tip  "![leverage-ansible](../../assets/images/logos/ansible.png "Leverage"){: style="width:20px"}"    
    ```shell
    ╭─delivery at delivery-ops
    ╰─⠠⠵ leverage ansible
    ```