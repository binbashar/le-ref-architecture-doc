# Project Configurations

!!! tips "Config files can be found under each `config` folders"
    - :file_folder: **Global config file** 
    [`/config/common.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/config/common.config.example) 
    contains global context TF variables that we inject to TF commands which are used by all sub-directories such as 
    `make plan` or `make apply` and which cannot be stored in `backend.config` due to TF.
    - :file_folder: **Account config files** 
        - [`backend.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/backend.config)
         contains TF variables that are mainly used to configure TF backend but since
         `profile` and `region` are defined there, we also use them to inject those values into other TF commands.
        - [`account.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/account.config)
         contains TF variables that are specific to an AWS account.
          
## AWS Profile
- File `backend.tfvars` will inject the profile name that TF will use to make changes on AWS.
- Such profile is usually one that relies on another profile to assume a role to get access to each corresponding account.
- Please follow to correctly setup your AWS Credentials
    - [user-guide/features/identities](../features/identities/identities.md)
    - [user-guide/features/identities/credentials](../features/identities/credentials.md) 
- Read the following page leverage doc to understand [how to set up a profile to assume 
a role](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)

