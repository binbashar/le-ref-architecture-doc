# Identity and Access Management (IAM) Layer
    
## Setting up user credentials
Please follow the steps below to orchestrate your `base-identities` layer 1st in your
[`project-root`](https://github.com/binbashar/le-tf-infra-aws/tree/master/root/global/base-identities) AWS account and
afterwards in your [`project-security`](https://github.com/binbashar/le-tf-infra-aws/tree/master/security/global/base-identities) account.

!!! example "IAM user standard creation workflow"
    1. Pre-requisite add Public PGP Key following the [documentation](./gpg.md) 
    2. For steps 3. and 4. consider following 
    [Leverage's Terraform workflow](../../../workflow/)
    3. Update (add | remove) your IAM Users associated code and deploy 
    [security/global/base-identities/users.tf](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/global/base-identities/users.tf)
        - :file_folder: Consider customizing your [account Alias and Password Policy](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/global/base-identities/account.tf)
    4. Update (add | remove | edit) your IAM Groups associated code and deploy 
    [security/global/base-identities/groups.tf](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/global/base-identities/groups.tf)
    5. Get and share the IAM Users AWS Console user id and its OTP associated password from the 
    [`make apply` outputs](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/global/base-identities/outputs.tf)
        * :warning: temporally set `sensitive   = false` to get the encrypted outputs in your prompt output.
    6. Each user will need to decrypt its AWS Console Password, you could share the [associated documentation](./gpg.md) with them.
    7. Users must login to the AWS Web Console (https://project-security.signin.aws.amazon.com/console) with their
     decrypted password and create new pass 
    8. Activate MFA for Web Console (Optional but strongly recommended)
    9. User should 
    [create his AWS ACCESS KEYS](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) 
    if needed 
    10. User could optionally set up `~/.aws/project/credentials` + `~/.aws/project/config` following the immediately
     below **AWS Credentials Setup** sub-section
    11. To allow users to 
    [Access AWS Organization member account](https://aws.amazon.com/premiumsupport/knowledge-center/organizations-member-account-access/)        
    consider repeating step 3. but for the corresponding member accounts:
        - [shared/global/base-identities](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/global/base-identities)
        - [apps-devstg/global/base-identities](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/global/base-identities)
        - [app-prd/global/base-identities](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/global/base-identities)

## Recommended Post-tasks
!!! attention "Deactivating AWS STS in not in use AWS Region"
    *When you activate STS endpoints for a Region, AWS STS can issue temporary credentials to users and roles in your
    account that make an AWS STS request. Those credentials can then be used in any Region that is enabled by default or
    is manually enabled. You must activate the Region in the account where the temporary credentials are generated. 
    It does not matter whether a user is signed into the same account or a different account when they make the request.*
    
    *To activate or deactivate AWS STS in a Region that is enabled by default (console)*
    
    1. *Sign in as a root user or an IAM user with permissions to perform IAM administration tasks.*
    2. *Open the IAM console and in the navigation pane choose Account settings.*
    3. *If necessary, expand Security Token Service (STS), find the Region that you want to activate, and then choose 
    Activate or Deactivate. For Regions that must be enabled, we activate STS automatically when you enable the Region. 
    After you enable a Region, AWS STS is always active for the Region and you cannot deactivate it. To learn how to 
    enable a Region, see Managing AWS Regions in the AWS General Reference.*
    
    ---
    :ledger: Source | :earth_americas: [AWS Documentation IAM User Guide | Activating and deactivating AWS STS in an AWS Region](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html)

![leverage-aws-iam-roles](/assets/images/screenshots/aws-iam-sts-regions.png "Leverage"){: style="width:900px"}

**Figure:** *Deactivating AWS STS in not in use AWS Region. Only in used Regions must have STS activated.*

## Next Steps
:books: [Setup your AWS Credentials](credentials.md)
