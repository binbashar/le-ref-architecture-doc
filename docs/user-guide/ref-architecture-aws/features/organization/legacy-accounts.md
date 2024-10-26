# Managing legacy (pre-existing) accounts
!!! help "How it works"
    :books: [**documentation:** organization](../..//how-it-works/user-guide/organization/organization/)
    
    :books: [**documentation:** organization accounts](../..//how-it-works/user-guide/organization/accounts/)

## User guide

### Pre-requisites
You must have your AWS Organization deployed and access to your Management account as 
described in the [/user-guide/user-guide/organization/organization-init](./configuration.md) section.

## Invite AWS pre-existing (legacy) accounts to your AWS Organization

#### Step 1: Add the Account to the New Organization
  - Via AWS Web Console: from your `project-management` account
 [invite](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_invites.html) the 
pre-existing `project-legacy` (1 to n accounts). 
  - Enter the Account ID of the account to be linked and send the invitation.
  - Accept the invitation from the account being migrated.
  - Associate the account with the Organizational Unit (OU) and apply the required policies.

#### Step 2: Update Terraform Code in  [`management/global/organizations/locals.tf`](https://github.com/binbashar/le-tf-infra-aws/blob/master/management/global/organizations/locals.tf)
Ensure the account to be imported is defined in [`management/global/organizations/locals.tf`](https://github.com/binbashar/le-tf-infra-aws/blob/master/management/global/organizations/locals.tf). For example, to import 
an account called "existing," add the corresponding entry:

```hcl
locals {
  accounts = {
    ...
    existing = {
      email     = "existing-account@example.com",
      parent_ou = "apps"
    }
  }
}
```

#### Step 3: Import the Existing Account
- Initialize Terraform if not already done:
  ```
  leverage terraform init
  ```
- Import the existing account. Replace `ACCOUNT_ID` with the ID of the new account being migrated:
  ```
  leverage terraform import aws_organizations_account.accounts["existing"] ACCOUNT_ID
  ```

#### Step 4: Apply the Terraform Configuration
Apply the Terraform configuration:
```
leverage terraform apply
```

### Terraform Command Summary

- **Initialize Terraform**:
  ```
  terraform init
  ```

- **Import the Existing Account**:
  ```
  terraform import aws_organizations_account.accounts["existing"] ACCOUNT_ID
  ```

- **Apply Terraform Configuration**:
  ```
  terraform apply
  ```