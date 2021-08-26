![binbash-logo](../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# How it works

The objective of this document is to explain how the **Binbash Leverage Reference AWS Cloud Solutions Architecture**
works, in particular how the Reference Architecture model is built and why we need it.

## Overview

This documentation contains all the guidelines to create Binbash 
Leverage Reference AWS Cloud Solutions Architecture that will be implemented on the 
Projects’ AWS infrastructure.

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

A Reference AWS Cloud Solutions Architecture designed under optimal configs for the most
popular modern web and mobile applications needs. 
Its design is fully based on AWS [“Well Architected Framework”](../work-with-us/support.md).

Reusing the [**Leverage Infrastructure as Code (IaC) Library**](code-library/code-library.md) via 
[**leverage cli**](https://github.com/binbashar/leverage) to rapidly implement it. 

It will solve your entire infrastructure and will grant you complete control of the source 
code and of course you'll be able to run it without us.

#### Structural concepts
The Reference Architecture is designed with modularity in mind. A multi-accounts approach is leveraged in order to improve security isolation and resources separation. Furthermore each account infrastructure is divided in smaller units that we call **layers**. Each layer contains all the required resources and definitions for a specific service or feature to function.

Each individual configuration of the Reference Architecture is referred to as a **project**. A Leverage project is comprised of all the relevant accounts and layers.

### Reference Architecture Model
!!! check "Strengths"
    - [x] Faster updates (new features and bug fixes).
    - [x] Better code quality and modules maturity (proven and tested).
    - [x] Supported by Binbash, and public modules even by 1000's of top talented Open Source community 
        contributors.
    - [x] Increase development cost savings.
    - [x] Clients keep full rights to all commercial, modification, distribution, and private use of the code 
        (No Lock-In) through forks inside their own projects' repositories (open-source and commercially reusable via license MIT and Apache 2.0 https://lnkd.in/davBQD5).

### Reference Architecture Design

#### AWS Organizations multi-account diagram
![leverage-aws-org](../assets/images/diagrams/aws-organizations.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Organization multi-account architecture diagram.
(Source: Binbash Leverage,
"Leverage Reference Architecture components",
Binbash Leverage Doc, accessed August 4th 2021).
</figcaption>

#### AWS Apps & Services K8s EKS accounts diagram
![leverage-aws-demoapps](../assets/images/diagrams/aws-k8s-eks-demoapps-components.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">
<b>Figure:</b> K8S EKS reference architecture components diagram.
(Source: Binbash Leverage Confluence Doc, 
<a href="https://binbash.atlassian.net/wiki/external/2001403925/ZjY5ZGU3NDYyODNhNDQzYTkxZDdkYTliNzczODRkY2M?atlOrigin=eyJpIjoiYjNmMzYwMTg2YmMyNDc3ODg4YTAwNDM5MjBiYWQ5ZGUiLCJwIjoiYyJ9">
"Implementation Diagrams"</a>,
Binbash Leverage Doc, accessed August 4th 2021).
</figcaption>

#### DevOps Workflow model

![leverage-devops](../assets/images/diagrams/ref-architecture-devops.png "DevOps"){: style="width:1000px"}

## Read More

!!! info "Related articles"
    * :ledger: [Don't get locked up into avoiding lock-in](https://martinfowler.com/articles/oss-lockin.html)
    * :ledger: [AWS Managed Services](https://aws.amazon.com/managed-services/)