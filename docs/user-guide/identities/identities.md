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


### AWS Credentials Setup

* :warning: **TODO:** This task will be automated via 
    * [x] [Makefile](https://github.com/binbashar/le-tf-infra-aws/blob/master/Makefile)
    * [x] [Script](https://github.com/binbashar/le-tf-infra-aws/tree/master/%40bin/scripts)

#### Example for: `~/.aws/leverage/credentials`

```
#================================================================#
# LEVERAGE credentials                                           #
#================================================================#
#------------------------------------#
# AWS OrganizationAccountAccessRole  #
#------------------------------------#
[binbash-root]
aws_access_key_id = AKIXXXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = cKJ2XXXXXXXXXXXXXXXXXXXXXXXXXXX
region = us-east-1

#------------------------------------#
# AWS DevOps Role                    #
#------------------------------------#
[binbash-security]
aws_access_key_id = AKXXXXXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = cKJ29HXXXXXXXXXXXXXXXXXXXXXXXXX
region = us-east-1 
```

#### Example for: `~/.aws/leverage/cofigs`

```
[default]
output = json
region = us-east-1

#================================================================#
# LEVERAGE config                                                #
#================================================================#
#------------------------------------#
# AWS OrganizationAccountAccessRole  #
#------------------------------------#
[profile binbash-security-oaar]
output = json
region = us-east-1
role_arn = arn:aws:iam::111111111111:role/OrganizationAccountAccessRole
source_profile = binbash-root

[profile binbash-shared-oaar]
output = json
region = us-east-1
role_arn = arn:aws:iam::222222222222:role/OrganizationAccountAccessRole
source_profile = binbash-root

[profile binbash-apps-devstg-oaar]
output = json
region = us-east-1
role_arn = arn:aws:iam::333333333333:role/OrganizationAccountAccessRole
source_profile = binbash-root

[profile binbash-apps-prd-oaar-replication]
output = json
region = us-east-2
role_arn = arn:aws:iam::444444444444:role/OrganizationAccountAccessRole
source_profile = binbash-root

[profile binbash-legacy-oaar]
output = json
region = us-east-1
role_arn = arn:aws:iam::555555555555:role/OrganizationAccountAccessRole
source_profile = binbash-root

#------------------------------------#
# AWS DevOps Role                    #
#------------------------------------#
[profile binbash-security-devops]
output = json
region = us-east-1
role_arn = arn:aws:iam::111111111111:role/DevOps
source_profile = binbash-security

[profile binbash-shared-devops]
output = json
region = us-east-1
role_arn = arn:aws:iam::222222222222:role/DevOps
source_profile = binbash-security

[profile binbash-apps-devstg-devops]
output = json
region = us-east-1
role_arn = arn:aws:iam::333333333333:role/DevOps
source_profile = binbash-security

[profile binbash-apps-prd-devops]
output = json
region = us-east-1
role_arn = arn:aws:iam::444444444444:role/DevOps
source_profile = binbash-security

[profile binbash-legacy-devops]
output = json
region = us-east-1
role_arn = arn:aws:iam::555555555555:role/DevOps
source_profile = binbash-security 
```

## Read More

!!! info "AWS reference links"
    Consider the following AWS official links as reference:        
    - :orange_book: [Best practices for managing AWS access keys](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html)

