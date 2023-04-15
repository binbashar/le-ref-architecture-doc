# Terraform Remote State
In the `base-tf-backend` folder you should find the definition of the infrastructure that needs to be deployed before 
you can get to work with anything else.

**IMPORTANT:** THIS IS ONLY NEEDED IF THE BACKEND WAS NOT CREATED YET. IF THE BACKEND ALREADY EXISTS YOU JUST USE IT.

!!! info "Read More"
    * [x] [Terraform - S3 & DynamoDB for Remote State Storage & Locking](tf-state-workflow.md)
 
## Configuration

!!! tips "Config files can be found under each `config` folders"
    - :file_folder: **Global config file** 
    [`/config/common.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/config/common.tfvars.example) 
    contains global context TF variables that we inject to TF commands which are used by all sub-directories such as 
    `leverage terraform plan` or `leverage terraform apply` and which cannot be stored in `backend.config` due to TF.
    - :file_folder: **Account config files** 
        - [`backend.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/backend.tfvars)
         contains TF variables that are mainly used to configure TF backend but since
         `profile` and `region` are defined there, we also use them to inject those values into other TF commands.
        - [`account.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/account.tfvars)
         contains TF variables that are specific to an AWS account.
          
## AWS Profile
- File `backend.tfvars` will inject the profile name that TF will use to make changes on AWS.
- Such profile is usually one that relies on another profile to assume a role to get access to each corresponding account.
- Please follow to correctly setup your AWS Credentials
    - [user-guide/features/identities](../features/identities/identities.md)
    - [user-guide/features/identities/credentials](../features/identities/credentials.md) 
- Read the following page leverage doc to understand [how to set up a profile to assume 
a role](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)

