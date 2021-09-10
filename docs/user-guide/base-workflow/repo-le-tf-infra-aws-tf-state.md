# Terraform - S3 & DynamoDB for Remote State Storage & Locking

## Overview
Use this terraform configuration files to create the **S3 bucket** & **DynamoDB** table needed to use Terraform Remote
State Storage & Locking.

![leverage-ref-arch-tf](../../assets/images/diagrams/terraform-aws-s3-backend.png "Leverage"){: style="width:350px"}

<figcaption style="font-size:15px">
<b>Figure:</b> Terraform remote state store & locking necessary AWS S3 bucket and DynamoDB table components.
(Source: Binbash Leverage, 
<a href="https://registry.terraform.io/modules/binbashar/tfstate-backend/aws/latest">
"Terraform Module: Terraform Backend"</a>,
Terraform modules registry, accessed December 3rd 2020).
</figcaption>

## Prerequisites

!!! example "Terraform repo structure + state backend initialization"
    1. Ensure you have [`leverage cli`](../../how-it-works/leverage-cli/index.md) installed in your system
    2. Refer to [Configuration Pre-requisites](../../base-configuration/repo-le-tf-infra-aws/) to understand how to set up the
      configuration files required for this layer. Where you must build your
      [Terraform Reference Architecture account structure](../../how-it-works/features/organization/organization.md)
    3. Leveraged by the [Infrastructure as Code (IaC) Library](../../how-it-works/infra-as-code-library/infra-as-code-library.md) through the
     [terraform-aws-tfstate-backend module](https://registry.terraform.io/modules/binbashar/tfstate-backend/aws/latest)
        - [/management/base-tf-backend](https://github.com/binbashar/le-tf-infra-aws/tree/master/root/base-tf-backend)
        - [/security/base-tf-backend](https://github.com/binbashar/le-tf-infra-aws/tree/master/security/base-tf-backend)
        - [/shared/base-tf-backend](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/base-tf-backend)
        - [/apps-devstg/base-tf-backend](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/base-tf-backend)
        - [/apps-prd/base-tf-backend](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/base-tf-backend)

## Set up

!!! example "Steps to initialize your tf-backend"
    1. At the corresponding account dir, 
      eg: [/shared/base-tf-backend](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/base-tf-backend) then,
    2. Run `leverage terraform init`
    3. Run `leverage terraform plan`, review the output to understand the expected changes
    4. Run `leverage terraform apply`, review the output once more and type `yes` if you are okay with that
    5. This should create a `terraform.tfstate` file in this directory but we don't want to push that to the repository so 
      let's push the state to the backend we just created
        
        - Open `config.tf` and uncomment the following lines:
        ```
          # backend "s3" {
          #   key = "root/tf-backend/terraform.tfstate"
          # }
        ```
        - Run `leverage terraform init` and type `yes` when Terraform asks if you want to import the state to the S3 backend
        - Done. You can remove `terraform.tfstate` now (and also `terraform.tfstate.backup` if available)

## Expected workflow after set up 
:warning: this tape must be updated
[![asciicast](https://asciinema.org/a/377220.svg)](https://asciinema.org/a/377220)