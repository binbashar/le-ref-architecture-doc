![binbash-logo](../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# How it works

The objective of this document is to explain how the **Binbash Leverage Reference AWS Cloud Solutions Architecture**
works, in particular how the Reference Architecure model is built and why we need it.

## Overview

This documentation contains all the guidelines to create Binbash 
Leverage Reference AWS Cloud Solutions Architecture that will be implemented on the 
Projects’s AWS infrastructure.

!!! check "Our Purpose"
    * [x] **Democratize advanced technologies:** As complex as it may sound, the basic idea behind this design principle is 
    simple. It is not always possible for a business to maintain a capable in-house IT department while staying up to
    date. It is entirely feasible to set up your own cloud computing ecosystem from scratch without experience, but that
    would take a considerable amount of resources; it is definitely not the most efficient way to go. 
    * [x] **An efficient business-minded** way to go is to employ AWS as a service allows organizations to benefit from
    the advanced technologies integrated into AWS without learning, researching, or creating teams specifically for
    those technologies.

!!! info
    This documentation will provide a detailed reference of the tools and techs used, 
    the needs they address and how they fit with the multiple practices we will be implementing.

### Reference Architecture 

A Reference AWS Cloud Solutions architecture designed under optimal configs for the most
popular modern web and mobile applications needs. 
Its design is fully based on AWS [“Well Architected Framework”](../work-with-us/support.md).

Reusing the [**Leverage Infrastructure as Code (IaC) Library**](./code-library/code-library.md) via 
[**leverage cli**](https://github.com/binbashar/leverage) to rapidly implement it. 

It will solve your entire infrastructure and will grant you complete control of the source 
code and of course you'll be able to run it without us. 

### Ref Architecture model
!!! check "Strengths"
    - [x] Faster updates (new features and bug fixes).
    - [x] Better code quality and modules maturity (proven and tested).
    - [x] Supported by Binbash, and public modules even by 1000's of top talented Open Source community 
        contributors.
    - [x] Increase development cost savings.
    - [x] Clients keep full rights to all commercial, modification, distribution, and private use of the code 
        (No Lock-In) through forks inside their own projects repos (open-source and commercially reusable via license MIT and Apache 2.0 https://lnkd.in/davBQD5).

### Reference Architecture Design

![leverage-aws-org](../assets/images/diagrams/aws-organizations.png "Leverage"){: style="width:750px"}

#### DevOps Workflow model

![leverage-devops](../assets/images/diagrams/ref-architecture-devops.png "DevOps"){: style="width:1000px"}

## Read More

!!! info "Related articles"
    * :ledger: [Don't get locked up into avoiding lock-in](https://martinfowler.com/articles/oss-lockin.html)
    * :ledger: [AWS Managed Services](https://aws.amazon.com/managed-services/)