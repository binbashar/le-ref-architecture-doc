# Credentials

## Overview
Currently the following two methods are supported:

1. [x] **AWS IAM:** this is essentially using on-disk, permanent programmatic credentials that are tied to a given IAM User. This method can optionally support MFA which is highly recommended since using permanent credentials is discouraged, so at least with MFA you can counter-balance that. [Keep reading...](./features/sso/configuration.md)
2. [x] **AWS IAM Identity Center (formerly known as AWS SSO):** this one is more recent and it's the method recommeded by AWS since it uses roles (managed by AWS) which in turn enforce the usage of temporary credentials. [Keep reading...](./features/identities/identities.md)

## Next Steps
If you are planning to choose SSO (highly recommended), check out [this section](./features/sso/overview.md).

If you are instead interested in using IAM + MFA, refer to [this other section](./features/identities/overview.md) instead.
