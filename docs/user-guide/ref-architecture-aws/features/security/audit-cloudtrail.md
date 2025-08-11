# Audit | CloudTrail

## Overview
AWS CloudTrail monitors and records account activity across your AWS infrastructure, 
giving you control over storage, analysis, and remediation actions.

<figure markdown>
  ![Cloudtrail Diagram](/assets/images/diagrams/aws-cloudtrail.svg){ width="600" }
    <figcaption style="font-size:15px">
    <b>Figure:</b> CloudTrail Implementation Diagram (only for reference). Keep in mind that there will be only one trail in the Security account.
    (Source: binbash Leverage diagrams, accessed July 6th 2022).
    </figcaption>
</figure>

## How do we implement it?
CloudTrail will be configured to enable auditing of all AWS services in all accounts and all regions.
We start by delegating the administration of CloudTrail to the Security account. Then we create a single multi-region, organizational trail in that account and configure it to push events to a bucket in the same account.

That way, all the accounts of the organization (existing and new), and all regions (currently enabled or enabled in the future), will ship the events to that centralized trail.

The events will be available in CloudTrail's event history for 90 days whereas the S3 bucket will be configured with a longer retention time.

!!! info "Tip"
    The great thing about this setup is that whenever you create new accounts or enable new regions, you won't need to worry about performing additional configuration on CloudTrail.

!!! example "![leverage-tf](/assets/images/logos/opentofu.png "OpenTofu"){: style="width:25px"} IaC OpenTofu Codebase <>"
    - [x] `binbash-management` account | Cloudtrail Administrator Delegation
        - **Code:** [management/us-east-1/security-audit](https://github.com/binbashar/le-tf-infra-aws/blob/master/management/global/organizations/organization.tf)
    - [x] `binbash-security` account | Cloudtrail Trail & S3 Bucket
        - **Code:** [security/us-east-1/security-audit](https://github.com/binbashar/le-tf-infra-aws/tree/master/security/us-east-1/security-audit)
    - [x] `binbash-security` account | KMS Customer Managed Key Permissions
        - **Code:** [security/us-east-1/security-keys](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/us-east-1/security-keys/kms.tf#L30)

## Read more
!!! info "AWS reference links"
    Consider the following AWS official links as reference:
    
    * :orange_book: [AWS Cloudtrail Overview](https://aws.amazon.com/cloudtrail/)
