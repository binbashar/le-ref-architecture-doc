# Project Credentials 

## AWS Profile
- File `backend.tfvars` will inject the profile name that TF will use to make changes on AWS.
- Such profile is usually one that relies on another profile to assume a role to get access to each corresponding account.
- Please follow to correctly setup your AWS Credentials
    - [user-guide/features/identities](../features/identities/identities.md)
    - [user-guide/features/identities/credentials](../features/identities/credentials.md) 
- Read the following page leverage doc to understand [how to set up a profile to assume 
a role](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)

