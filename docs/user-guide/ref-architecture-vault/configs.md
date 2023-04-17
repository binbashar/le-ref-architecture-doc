# Project Configurations

!!! tips "Config files can be found under each `config` folders"
    - :file_folder: **Global config file** 
    [`/config/common.tfvars`](https://github.com/binbashar/le-tf-vault/blob/master/config/common.tfvars.example) 
    contains global context TF variables that we inject to TF commands which are used by all sub-directories such as 
    `leverage terraform plan` or `leverage terraform apply` and which cannot be stored in `backend.tfvars` due to TF.
    - :file_folder: **Account config files** 
        - [`backend.tfvars`](https://github.com/binbashar/le-tf-vault/blob/master/hcp/config/backend.tfvars)
         contains TF variables that are mainly used to configure TF backend but since
         `profile` and `region` are defined there, we also use them to inject those values into other TF commands.
        - [`account.tfvars`](https://github.com/binbashar/le-tf-vault/blob/master/hcp/config/account.tfvars)
         contains TF variables that are specific to an AWS account.
          
## AWS Profile
- File `backend.tfvars` will inject the profile name that TF will use to make changes on AWS.
- Such profile is usually one that relies on another profile to assume a role to get access to each corresponding account.
- Please follow to correctly setup your AWS Credentials
    - [user-guide/user-guide/identities](../user-guide/identities/identities.md)
    - [user-guide/user-guide/identities/credentials](../user-guide/identities/credentials.md) 
- Read the following page leverage doc to understand [how to set up a profile to assume 
a role](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)

