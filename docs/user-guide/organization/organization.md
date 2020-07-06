# Reference Architecture: Terraform AWS Organizations Account Baseline

!!! help "How it works"
    :books: [**documentation:** organization](../../how-it-works/organization/organization.md)
    
    :books: [**documentation:** organization accounts](../../how-it-works/organization/accounts.md)

## User guide

!!! example "Steps"
    1. Create a brand [new AWS Account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/),
     intended to be our AWS Organization Root Account  
    2. Via AWS Web Console: from your `project-root` acconunt
     [invite](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_invites.html) the 
     pre-existing `project-legacy` (1 to n accounts).
    3. Via AWS Web Console: in `project-legacy` create the `OrganizationAccountAccessRole` IAM Role with Admin
     permissions.
        - :orange_book: Should follow
        [Creating the OrganizationAccountAccessRole in an invited member account](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html)
        section.
    4. Via AWS Web Console: in `project-root` create the `root-org` IAM user with Admin privileges, which will be use
     for the initial AWS Org bootstrapping. After it’s 1st execution only nominated Org admin users will persist in the
     `project-root` account.
    5. The AWS Org will be orchestrated -> [Leverage Ref Code](https://github.com/binbashar/le-tf-infra-aws/tree/master/root/organizations)
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