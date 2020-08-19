# AWS Organizations Billing

## Overview

Each month AWS charges your payer **Root Account** for all the linked accounts in a consolidated bill. 
The following illustration shows an example of a consolidated bill.

![leverage-aws-org](../../assets/images/diagrams/aws-organizations-scp.png "Leverage"){: style="width:750px"}
<figcaption>
**Figure:** AWS Organization Multi-Account structure(just as reference). 
- [ :ledger: **Source:** cloudnout.io ](https://cloudonaut.io/images/2020/04/aws-organizations-1.png)
</figcaption>

![leverage-aws-org](../../assets/images/diagrams/aws-organizations-billing.png "Leverage"){: style="width:750px"}
<figcaption>
**Figure:** AWS Organization Multi-Account structure(just as reference). 
- [ :ledger: **Source:** docs.aws.amazon.com ](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/useconsolidatedbilling-procedure.html)
</figcaption>

!!! info "Reference Architecture [**AWS Organizations**](https://aws.amazon.com/organizations/) features"
    - [x] [**AWS Multiple Account Billing Strategy:**](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/useconsolidatedbilling-procedure.html)
    consolidated billing for all your accounts within organization, enhanced per account cost 
    filtering and [RI usage](https://aws.amazon.com/about-aws/whats-new/2019/07/amazon-ec2-on-demand-capacity-reservations-shared-across-multiple-aws-accounts/)  
    - [x] A single monthly bill accumulates the spending among many AWS accounts.
    - [x] Benefit from volume pricing across more than one AWS account. 

!!! question "AWS Organizations Billing FAQs"
    * :moneybag: **What does AWS Organizations cost?**
    
        _AWS Organizations is offered at no additional charge._

    * :moneybag: **Who pays for usage incurred by users under an AWS member account in my organization?**
    
        _The owner of the master account is responsible for paying for all usage, data, and resources used by the 
        accounts in the organization._

   
    * :moneybag: **Will my bill reflect the organizational unit structure that I created in my organization?**
        
        _No. For now, your bill will not reflect the structure that you have defined in your organization. 
        You can use cost allocation tags in individual AWS accounts to categorize and track your AWS costs, and this
        allocation will be visible in the consolidated bill for your organization._
        
    ---
    :ledger: Source | [AWS Organizations FAQs](https://aws.amazon.com/organizations/faqs/#)


## Read more

!!! info "Reference links"
    Consider the following extra links as reference:
         
    - :blue_book: [Cloudnout.io | AWS Account Structure](https://cloudonaut.io/aws-account-structure-think-twice-before-using-aws-organizations/)
    - :orange_book: [AWS Ramp-Up Guide: Cost Management](https://d1.awsstatic.com/training-and-certification/ramp-up_guides/Ramp-Up_Guide_Cost_Management.pdf)