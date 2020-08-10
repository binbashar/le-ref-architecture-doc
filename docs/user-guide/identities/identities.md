# Identity and Access Management (IAM) Layer

!!! help "How it works"
    :books: [**documentation:** identities](../../how-it-works/identities/identities.md)
    
## User guide

Please follow the steps below to orchestrate your `base-identities` layer 1st in your
[`project-root`](https://github.com/binbashar/le-tf-infra-aws/tree/master/root/base-identities) AWS account and
afterwards in your [`project-security`](https://github.com/binbashar/le-tf-infra-aws/tree/master/security/base-identities) account.

!!! example "IAM user standard creation workflow"
    1. Pre-requisite add Public PGP Key following the [documentation](./gpg.md) 
    2. For steps 3. and 4. consider following 
    [Terraform `make` workflow](https://leverage.binbash.com.ar/user-guide/base-workflow/repo-le-tf-infra-aws/)
    3. Update (add | remove) your IAM Users associated code and deploy 
    [security/base-identities/users.tf](https://github.com/binbashibilitySRL/devops-tf-infra/blob/master/security/base-identities/users.tf)
        - :file_folder: Consider customizing your [account Alias and Password Policy](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/base-identities/account.tf)
    4. Update (add | remove | edit) your IAM Groups associated code and deploy 
    [security/base-identities/groups.tf](https://github.com/binbashibilitySRL/devops-tf-infra/blob/master/security/base-identities/groups.tf)
    5. Get and share the IAM Users AWS Console user id and its OTP associated password from the 
    [`make apply` outputs](https://github.com/binbashar/le-tf-infra-aws/blob/master/security/base-identities/outputs.tf)
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
        - [shared/base-identities](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/base-identities)
        - [apps-devstg/base-identities](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/base-identities)
        - [app-prd/base-identities](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/base-identities)


### Next Steps

:books: [Setup your AWS Credentials](credentials.md)

