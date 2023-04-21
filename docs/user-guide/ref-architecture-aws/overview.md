# AWS Reference Architecture

## Overview
The AWS Reference Architecture was created on a set of opinionated definitions and conventions on:

* [how to organize files/folders](dir-structure.md),
* where to store [configuration files](configuration.md),
* how to handle [credentials](configuration.md#setting-credentials-for-terraform-via-aws-profiles),
* how to [set up](tf-state.md) and [manage state](workflow.md),
* which [commands and workflows](workflow.md) to run in order to perform different tasks,
* and more.

!!! info "Key Concept"
    Although the **Reference Architecture for AWS** was initially designed to be compatible with web, mobile and microservices application stacks, it can also accommodate other types of workloads such as machine learning, blockchain, media, and more.

It was designed with modularity in mind. A multi-accounts approach is leveraged in order to improve security isolation and resources separation. Furthermore each account infrastructure is divided in smaller units that we call **layers**. Each layer contains all the required resources and definitions for a specific service or feature to function.

!!! info "Key Concept"
    The design is strongly based on the [AWS Well Architected Framework](../../work-with-us/support.md).

Each individual configuration of the Reference Architecture is referred to as a **project**. A Leverage project is comprised of all the relevant accounts and layers.

## Core Strengths
- [x] Faster updates (new features and bug fixes).
- [x] Better code quality and modules maturity (proven and tested).
- [x] Supported by binbash, and public modules even by 1000's of top talented Open Source community 
    contributors.
- [x] Increase development cost savings.
- [x] Clients keep full rights to all commercial, modification, distribution, and private use of the code 
    (No Lock-In) through forks inside their own projects' repositories (open-source and commercially reusable via [license MIT and Apache 2.0](https://choosealicense.com/licenses/).

## A More Visual Example
The following diagram shows the type of AWS multi-account setup you can achieve by using this Reference Architecture:
![leverage-aws-org](../../../assets/images/diagrams/ref-architecture-aws.png "Leverage"){: style="width:950px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Organization multi-account reference architecture diagram. (Source: binbash Leverage, "Leverage Reference Architecture components", binbash Leverage Doc, accessed August 4th 2021).
</figcaption>

!!! info "Read more"
    * :ledger: [Don't get locked up into avoiding lock-in](https://martinfowler.com/articles/oss-lockin.html)
    * :ledger: [AWS Managed Services](https://aws.amazon.com/managed-services/)
