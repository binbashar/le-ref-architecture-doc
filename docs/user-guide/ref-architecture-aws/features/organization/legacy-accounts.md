# Managing legacy (pre-existing) accounts
!!! help "How it works"
    :books: [**documentation:** organization](../..//how-it-works/user-guide/organization/organization/)
    
    :books: [**documentation:** organization accounts](../..//how-it-works/user-guide/organization/accounts/)

## User guide

### Pre-requisites
You must have your AWS Organization deployed and access to your Management account as 
described in the [/user-guide/user-guide/organization/organization-init](./configuration.md) section.

## Invite AWS pre-existing (legacy) accounts to your AWS Organization
!!! example "AWS Org pre-existing accounts invitation"
    1. Via AWS Web Console: from your `project-root` account
     [invite](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_invites.html) the 
    pre-existing `project-legacy` (1 to n accounts).
    
    2. Via AWS Web Console: in `project-legacy` create the `OrganizationAccountAccessRole` IAM Role with Admin
     permissions.
        - :orange_book: Should follow
        [Creating the OrganizationAccountAccessRole in an invited member account](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)
        section.
    
    3. Import your `project-legacy` account as code.
        - Update the following variables in `./@bin/makefiles/terraform12/Makefile.terraform12-import-rm`
        ```
        TF_IMPORT_RESOURCE                := "aws_organizations_organizational_unit.bbl_apps_devstg"
        TF_IMPORT_RESOURCE_ID             := "ou-oz9d-yl3npduj"
        TF_RM_RESOURCE                    := "aws_organizations_organizational_unit.bbl_apps_devstg"
        ```   
        - Then from the root context -> `cd ./root/organization make import`
        - :ledger: **TODO** THIS STEP MUST BE UPDATED WITH THE `Leverage CLI` WORKFLOW
