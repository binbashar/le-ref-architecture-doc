# AWS Credentials

Three main sets of credentials are used to interact with the AWS environment. We called them `bootstrap`, `management` and `security` credentials.

### `bootstrap` credentials

These are temporary credentials used for the initial deployment of the architecture, and they should only be used for this purpose. Once this process is finished, `management` and `security` users should be the ones managing the environment.

### `management` credentials

`management` credentials are meant to carry the role of making all important administrative tasks in the environment (e.g. billing adjustments). They should be tied to a physical user in your organization.

A user with these credentials will assume the role `OrganizationAccountAccessRole` when interacting the environment.

### `security` credentials

These credentials are the ones to be used for everyday maintenance and interaction with the environment. Users in the role of DevOps | SecOps | Cloud Engineer in your organization should use these credentials.

A user with these credentials will assume te role `DevOps` when interacting with the environment.

## Read More

!!! info "AWS reference links"
    Consider the following AWS official links as reference:        
    
    * :orange_book: [Best practices for managing AWS access keys](https://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html)
    * :blue_book: [Cloud.gov | Secret key management - AWS credentials ](https://cloud.gov/docs/ops/secrets/)
