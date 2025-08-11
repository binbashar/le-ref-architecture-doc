# IAM Access Analyzer

## Overview
Access Analyzer analyzes the resource-based policies that are applied to AWS resources in the 
Region where you enabled Access Analyzer. Only resource-based policies are analyzed. 

Supported resource types:

- [x] Amazon Simple Storage Service buckets
- [x] AWS Identity and Access Management roles
- [x] AWS Key Management Service keys
- [x] AWS Lambda functions and layers
- [x] Amazon Simple Queue Service queues
- [x] AWS Secrets Manager secrets

![leverage-vpn](/assets/images/diagrams/aws-iam-access-analyzer.png "Leverage"){: style="width:650px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS IAM access analysis features.
(Source: AWS, 
<a href="https://aws.amazon.com/iam/user-guide/analyze-access/">
"How it works - monitoring external access to resources"</a>,
AWS Documentation, accessed June 11th 2021).
</figcaption>

## AWS Organizations
!!! important "CONSIDERATION: AWS Organization integration"
    In order to enable ***AccessAnalyzer*** with the Organization at the zone of
    of trust in the **Security** account, this account needs to be set as a *delegated
    administrator*. 

    Such step cannot be performed by Terraform yet so it was set
    up manually as described below:
    [https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-settings.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-analyzer-settings.html)

    If you're configuring AWS IAM Access Analyzer in your AWS Organizations management account, 
    you can add a member account in the organization as the delegated administrator to manage 
    Access Analyzer for your organization. The delegated administrator has permissions to create 
    and manage analyzers with the organization as the zone of trust. Only the management account 
    can add a delegated administrator.

## Reference Architecture implementation code
!!! summary "Reference Architecture Code: [le-tf-infra-aws/security/security-base/iam_access_analizer.tf](https://github.com/binbashar/le-tf-infra-aws/blob/03b282c483eb65eab05912adc98744415e83aa00/security/security-base/iam_access_analizer.tf)"
    <!-- TODO: Update -->
    ```
    resource "aws_accessanalyzer_analyzer" "default" {
        analyzer_name = "ConsoleAnalyzer-bc3bc4d6-09cb-XXXX-XXXX-XXXXXXXXXX"
        type          = "ORGANIZATION"
        tags          = local.tags
    }
    ```

## AWS Web Console 
![leverage-security-iam](/assets/images/screenshots/aws-iam-access-analyzer.png "Leverage"){: style="width:950px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Web Console screenshot.
(Source: binbash, "IAM access analyzer service", accessed June 11th 2021).
</figcaption>
