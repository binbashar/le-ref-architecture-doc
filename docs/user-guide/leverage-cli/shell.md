# Shell environment

When launching a Terraform shell, Leverage provides the user with a completely isolated environment tailored to operate in the current project via a Docker container.

The whole project is mounted on a directory named after the value for `project_long` in the global configuration file, or simply named `"project"` if this value is not defined. A project named `myexample`, would be mounted in `/myexample`.

The `.gitconfig` user's file is mounted on `/etc/gitconfig` for convenience. If `ssh-agent` is running in the host, the socket stated in `SSH_AUTH_SOCK` is mounted on `/ssh-agent`, allowing easy ssh authentication to remote repositories if necessary. Lastly, the credentials files (`credentials` and `config`) found in the project AWS credentials directory (`~/.aws/myexample`), are mapped to the locations given by the environment variables `AWS_SHARED_CREDENTIALS_FILE` and `AWS_CONFIG_FILE` respectively within the container. 

## Authentication
Determining which credentials are needed to operate on a layer, and retrieving those credentials, may prove cumbersome for many complex layer definitions. In addition to that, correctly configuring them can also become a tedious an error prone process. For that reason Leverage automates this process upon launching the shell if requested by the user via the [`shell` command options](./reference/terraform.md#shell).

Bear in mind, that an authenticated shell session's credentials are obtained for the layer in which the session was launched. These credentials may not be valid for other layers in which different roles need to be assumed or require more permissions.

### Multi-Factor authentication

``` bash
leverage terraform shell --mfa
```

If MFA authentication is required, Leverage will prompt the user for the required tokens for the layer or use the cached credentials if still valid.

The user's programmatic keys must be configured beforehand via `leverage credentials configure` command.

### Single-Sign On

If authentication via SSO is required, the user will need to [configure](./reference/aws.md#configure-sso) or [login](./reference/aws.md#sso-login) into SSO before launching the shell via

``` bash
leverage terraform shell --sso
```


## Operations on the project's layer
In order to operate in a project's layer, Terraform commands such as `plan` or `apply` will need to receive extra parameters providing the location of the files that contain the definition of the variables required by the layer. Usually, these files are:

* the project global configuration file `common.tfvars`
* the account configuration file `account.tfvars`
* the terraform backend configuration file `backend.tfvars`

In this case these parameters should take the form:
``` bash
-var-file=/myexample/config/common.tfvars -var-file=/myexample/account/config/account.tfvars -var-file=/myexample/account/config/backend.tfvars`
```

Relative paths can prove useful when providing these locations. A layer definition may require more than just these files.

So, for example, to apply changes on a standard Leverage Reference Architecture layer, the complete command would be:
``` bash
terraform apply -var-file=../../../config/common.tfvars -var-file=../../config/account.tfvars -var-file=../../config/backend.tfvars
```
However, when initializing Terraform different parameters are needed, so it should be run as:
``` bash
terraform init -backend-config=../../config/backend.tfvars
```
