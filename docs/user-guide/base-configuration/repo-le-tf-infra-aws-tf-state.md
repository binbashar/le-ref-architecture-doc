# Terraform - S3 & DynamoDB for Remote State Storage & Locking

## Overview
Use this terraform configuration files to create the **S3 bucket** & **DynamoDB** table needed to use Terraform Remote
State Storage & Locking.

## Prerequisites
- Ensure you have `make` installed in your system
- Refer to [Configuration Pre-requisites](../base-configuration/repo-le-tf-infra-aws.md) to understand how to set up the
  configuration files required for this layer.

## Set up
- Run `make init`
- Run `make apply`, review the output and type `yes` if you are okay with that
- This should create a `terraform.tfstate` file in this directory but we don't want to push that to the repository so 
  let's push the state to the backend we just created
- Open `config.tf` and uncomment the following lines:
```
  # backend "s3" {
  #   key = "root/tf-backend/terraform.tfstate"
  # }
```
- Run `make init` and type `yes` when Terraform asks if you want to import the state to the S3 backend
- Done. You can remove `terraform.tfstate` now (and also `terraform.tfstate.backup` if available)

