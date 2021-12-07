# Command: `credentials`

The `credentials` command is used to set up and manage the AWS CLI credentials required to interact with the AWS environment.

All `credentials`'s subcommands feed off the `project.yaml`, `build.env`, and Terraform configuration files to obtain the information they need. In case the basic required information is not found, the subcommands will prompt the user for it.

---
## `configure`

### Usage
``` bash
leverage credentials configure --type [BOOTSTRAP|MANAGEMENT|SECURITY] [options]
```

The `credentials configure` command sets up the credentials needed to interact with the AWS environment, from the initial deployment process (`BOOTSTRAP`) to everyday management (`MANAGEMENT`) and development or use (`SECURITY`) of it.

It attempts to retrieve the structure of the organization in order to generate all the [AWS CLI profiles required to interact with the environment](../../../features/identities/credentials.md) and update the terraform configuration with the id of all relevant accounts.

Backups of the previous configured credentials files are always created when overwriting or updating the current ones.

### Options
* `--type`: Type of the credentials to set. Can be any of `BOOTSTRAP`, `MANAGEMENT` or `SECURITY`. This option is case insensitive. This option is required.
* `--credentials-file`: Path to a `.csv` credentials file, as produced by the AWS Console, containing the user's programmatic access keys. If not given, the user will be prompted for the credentials.
* `--overwrite-existing-credentials`: If the type of credentials being configured is already configured, overwrite current configuration. Mutually exclusive option with `--skip-access-keys-setup`.
* `--skip-access-keys-setup`: Skip the access keys configuration step. Continue on to setting up the accounts profiles. Mutually exclusive option with `--overwrite-existing-credentials`.
* `--skip-assumable-roles-setup`: Don't configure each account profile to assume their specific role.

If neither of `--overwrite-existing-credentials` or `--skip-access-keys-setup` is given, the user will be prompted to choose between both actions when appropriate.
