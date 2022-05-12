# Shell environment

When launching a Terraform shell, Leverage provides the user with a completely isolated environment tailored to operate in the current project **layer** via a Docker container.

## Authentication
Determining which credentials are needed to operate on a layer, and retrieving those credentials, may prove cumbersome for many complex layer definitions. In addition to that, correctly configuring them can also become a tedious an error prone process. For that reason Leverage automates this process upon launching the shell if requested by the user via the [`shell` command options](./reference/terraform.md#shell).

### Multi-Factor authentication
If MFA authentication is required, Leverage will prompt the user for the required tokens for the layer or use the cached credentials if still valid.

The user's programmatic keys must be configured beforehand via `leverage credentials configure` command.

### Single-Sign On
If authentication via SSO is required, the user will need to [configure](./reference/aws.md#configure-sso) or [login](./reference/aws.md#sso-login) into SSO before launching the shell.

## Operations on the project's layer
In order to operate in a project's layer, Terraform commands such as `plan` or `apply` will need to receive extra parameters providing the location of the files that contain the definition of the variables required by the layer. These files are:

* the project global configuration file `common.tfvars`
* the account configuration file `account.tfvars`
* the terraform backend configuration file `backend.tfvars`


These parameters take the shape `-var-file=/common-config/common.tfvars -var-file=/config/account.tfvars -var-file=/config/backend.tfvars`


So, for example, to apply changes in a layer, the complete command would be:
``` bash
terraform apply -var-file=/common-config/common.tfvars -var-file=/config/account.tfvars -var-file=/config/backend.tfvars
```
