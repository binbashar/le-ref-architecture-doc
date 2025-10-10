# Credentials

## Overview
Currently the following two methods are supported:

1. [x] **AWS IAM:** this is essentially using on-disk, permanent programmatic credentials that are tied to a given IAM User. This method can optionally support MFA which is highly recommended since using permanent credentials is discouraged, so at least with MFA you can counter-balance that. [Keep reading...](./features/identities/identities.md)
2. [x] **AWS IAM Identity Center (formerly known as AWS SSO):** this one is more recent and it's the method recommended by AWS since it uses roles (managed by AWS) which in turn enforce the usage of temporary credentials. [Keep reading...](./features/sso/configuration.md)

## Switching between AWS IAM and AWS IAM Identity Center (AWS IIC)
Switching back and forth between AWS IAM and AWS IIC is supported but keep in mind these notes:

1. Switching to AWS IIC is simple, assuming that you already enabled and configured such service as explained [here](/user-guide/ref-architecture-aws/features/sso/configuration/). You'll need to set MFA to false in the [build.env](/user-guide/leverage-cli/extending-leverage/build.env) file, configure SSO variables in the common.tfvars file, plus other things to make it work.

2. Switching to AWS IAM, on the other hand, is about setting MFA to true in the [build.env](/user-guide/leverage-cli/extending-leverage/build.env) file and then going through [this guide](/user-guide/ref-architecture-aws/features/identities/identities/#setting-up-user-credentials) in order to create the IAM user required for the programmatic credentials needed. You'll also need to configure your AWS config and credentials files in order to define the profiles and roles that Leverage needs to reference each account of the organization.

!!! warning "Troubleshooting Credentials"
    If you face any issues while trying to make any of the above working, refer to [this troubleshooting](/user-guide/troubleshooting/credentials/) guide for help.

## Next Steps
If you are choosing SSO, which is highly recommended, check out [this section](./features/sso/overview.md) to learn more about it.

If you are instead interested in using IAM + MFA, refer to [this other section](./features/identities/overview.md).
