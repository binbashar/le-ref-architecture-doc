# Reference Architecture: Terraform AWS Organizations Account Baseline

!!! help "How it works"
    :books: [**documentation:** organization](../../how-it-works/organization/organization.md)
    
    :books: [**documentation:** organization accounts](../../how-it-works/organization/accounts.md)

## User guide

### Pre-requisites

You'll need an email to [create and register your AWS Organization Root Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).
For this purpose we recommend to avoid using an individual nominated email user. 
Instead, whenever possible, it should ideally be associated, with a **distribution list email** such as a 
[**GSuite Group**](https://support.google.com/a/answer/2727156?hl=en) to ensure the proper admins member's team 
(DevOps | SecOps | Cloud Engineering Team) to manage its notifications avoiding a single point of contact (constraint).

#### Email setup example
**GSuite Group Email address:** `aws@domain.com` (to which admins / owners belong), and then using the `+` we generate
the aliases automatically implicitly when running Terraform's Leverage code.

* :e-mail: `aws+security@binbash.com.ar`
* :e-mail: `aws+shared@binbash.com.ar`
* :e-mail: `aws+apps-devstg@binbash.com.ar`
* :e-mail: `aws+apps-prd@binbash.com.ar`

!!! important Reference Code as example
    ```terraform
    #
    # Project Prd: services and resources related to production are placed and
    #  maintained here.
    #
    resource "aws_organizations_account" "apps_prd" {
      name      = "apps-prd"
      email     = "aws+apps-prd@doamin.ar"
      parent_id = aws_organizations_organizational_unit.apps_prd.id
    }
    ```

### Example

!!! example "Steps"
    1. Create a brand [new AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/),
     intended to be our AWS Organization Root Account  
    2. Via AWS Web Console: in `project-root` create the `root-org` IAM user with Admin privileges, which will be use
     for the initial AWS Org bootstrapping. After it’s 1st execution only nominated Org admin users will persist in the
     `project-root` account.
    3. The AWS Org will be orchestrated -> [Leverage Ref Code](https://github.com/binbashar/le-tf-infra-aws/tree/master/root/organizations)
    4. Via AWS Web Console: from your `project-root` acconunt
     [invite](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_invites.html) the 
    pre-existing `project-legacy` (1 to n accounts).
    5. Via AWS Web Console: in `project-legacy` create the `OrganizationAccountAccessRole` IAM Role with Admin
     permissions.
        - :orange_book: Should follow
        [Creating the OrganizationAccountAccessRole in an invited member account](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)
        section.
    6. Import your `project-legacy` account as code.
        - Update the following variables in `./@bin/makefiles/terraform12/Makefile.terraform12-import-rm`
        ```
        TF_IMPORT_RESOURCE                := "aws_organizations_organizational_unit.bbl_apps_devstg"
        TF_IMPORT_RESOURCE_ID             := "ou-oz9d-yl3npduj"
        TF_RM_RESOURCE                    := "aws_organizations_organizational_unit.bbl_apps_devstg"
        ```   
        - Then from the root context -> `cd ./root/organizaton make import`
    7. Recommended following configurations [Identities](../identities/identities.md)
    8. Switch to the `project-security` account for consolidated and centralized User Mgmt and access to the AWS Org.