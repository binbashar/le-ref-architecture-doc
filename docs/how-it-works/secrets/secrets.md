# Secret and password mgmt tools

## Overview 

Ensure scalability, availability and persistence, as well as secure, hierarchical storage to manage configuration and secret data for:

!!! example "Secret Managers"
    * :lock: AWS KMS
    * :lock: AWS SSM Parameter Store
    * :lock: Ansible Vault
    * :lock: Hashicorp Vault

!!! check "Strengths"
    * [x] Improve the level of security by validating separation of environment variables and code secrets.
    * [x] Control and audit granular access in detail
    * [x] Store secure chain and configuration data in hierarchies and track versions.
    * [x] Configure integration with AWS KMS, Amazon SNS, Amazon CloudWatch, and AWS CloudTrail to notify, monitor, and audit functionality.

## Read more

!!! info "Related articles"
    * :ledger: [A Comparison of Secrets Managers for AWS](https://blog.scalesec.com/a-comparison-of-secrets-managers-for-aws-ba64e8029314)
    * :ledger: [Clean Up Your Secrets & Credential Management](https://www.hashicorp.com/resources/clean-up-your-secrets-and-credential-management-first-steps-with-hashicorp-vault/)