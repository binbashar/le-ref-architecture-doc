![binbash-logo](../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# How it works

The objective of this document is to explain how the [**Binbash Leverage Reference AWS Cloud Solutions Architecture**](https://drive.google.com/file/d/1Z7VfioV6txbisv70cFIif2j6AnQ__fAc/view?usp=sharing)
works, in particular how the Reference Architecure model is built and why we need it.

## Overview
This repository contains all Terraform configuration files used to create Binbash 
Leverage Reference AWS Cloud Solutions Architecture that will be implemented on the 
Projects’s AWS infrastructure.

!!! info
    This documentation will provide a detailed reference of the tools and techs used, 
    the needs they address and how they fit with the multiple practices we will be implementing.

### Ref Architecture 

Reference AWS Cloud Solutions architecture designed under optimal configs for the most
popular modern web and mobile applications needs based on AWS “Well Architected Framework”.
With it's complete [**Leverage DevOps Automation Code Library**](./code-library/code-library.md) to rapidly implement it will solve your entire
infrastructure and will grant you complete control of the source code and of course you'll
be able to run it without us. 

### Ref Architecture model
!!! success "Characteristics"
    - [x] Faster updates (new features and bug fixes).
    - [x] Better code quality and modules maturity (proven and tested).
    - [x] Supported by Binbash, and Open ones even by Binbash + 1000’s of top talented Open Source community contributors.
    - [x] Development cost savings.
    - [x] Client keeps full rights to all commercial, modification, distribution, and private use of the code (No Lock-In) through forks inside their own Projects repos (open-source and commercially reusable via license MIT and Apache 2.0 - https://choosealicense.com/licenses/).
    - [x] Documented.
    - [x] Reusable, Supported  & Customizable.

### Reference Architecture Design

![leverage-aws-org](../assets/images/diagrams/aws-organizations.png "Leverage"){: style="width:750px"}

#### DevOps Workflow model

![leverage-devops](../assets/images/diagrams/ref-architecture-devops.png "DevOps"){: style="width:1000px"}


## Important Considerations

!!! info "Assumptions"
    *   [x] **AWS Regions:** Multi Region setup → 1ry: us-east-1 (N. Virginia) & 2ry: us-west-2 (Oregon).
        DevOps necessary repositories will be created. There will be feature branches (`ID-XXX` -> `master`) and either
        Binbash or the Client Engineers will be reviewers of each other and approvers (at least 1 approver).
    *   [x] After deployment via IaC (Terraform, Ansible & Helm) all subsequent changes will be performed via versioned
        controlled code, by modifying the corresponding repository and running the proper IaC Automation execution. 
        Will start the process via Local Workstations. Afterwards full exec automation will be considered via: Jenkins, 
        CircleCI or Terraform Cloud Jobs (GitOps). 
        - :ledger: **Consideration:** Note that any change manually performed will generate inconsistencies on the deployed resources 
          (which left them out of governance and support scope).
    *   [x] All AWS resources will be deployed via **_Terraform_** and rarely occasional CloudFormation, Python SDK & AWS CLI
        when the resource is not defined by Terraform (almost none scenario). All code and scripts will be included in the 
        repository.
    *   [x] Provisioning via **_Ansible_** for resources that need to be provisioned on an OS.
    *   [x] Orchestration via **_Helm + Helmsfile_** for resources that need to be provisioned in Kubernetes
        (with **_Docker_** as preferred container engine).
    *   [x] Infra as code deployments should run from the new `ID-XXX` or `master` branch. `ID-XXX` branch must be merged 
        immediately (ASAP) via PR to the `master` branch. 
           - :ledger: **Consideration:** validating that the changes within the code will only affect the desired target resources
            is the responsibility of the executor (to ensure everything is OK please consider exec after review/approved PR).
    *   [x] All resources will be deployed in several new AWS accounts created inside the Client AWS Organization. 
        Except for the AWS Legacy Account invitation to the AWS Org and _OrganizationAccountAccessRole_ creation in it, 
        there will be no intervention whatsoever in current Client Legacy Production account, unless required by Client 
        authority and given a specific requirement.
        
!!! info 
    We will explore the details of all the relevant Client application stacks, CI/CD processes, 
    monitoring, security, target service level objective (SLO) and others in a separate document.