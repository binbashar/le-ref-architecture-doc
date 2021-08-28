# Command: `credentials`

The `credentials` command is used to set up and manage the AWS CLI credentials required to interact with the AWS environment.

All `credentials`'s subcommands feed off the `project.yaml` configuration file to obtain the information they need. In case this information is not found, or it is not provided explicitly through the available arguments, the subcommands will prompt the user for it.

---
## `create`

### Usage
``` bash
leverage credentials create [options]
```

The `credentials create` subcommand initializes the `bootstrap` credentials, required to perform the initial deployment of the architecture. It checks the credentials validity against AWS and updates the `project.yaml` file with the id of the main AWS account.

If the `bootstrap` credentials are already configured the command will prompt the user regarding whether the existing configuration should be overwritten or left as is.

### Options
* `--file`: path to a `.csv` access keys file containing the credentials as produced by AWS console when generating the programmatic keys. If not given, the user will be prompted for the credentials.
* `--force`: if `bootstrap` credentials are already configured, do not prompt the user, overwrite the existing configuration.

---
## `update`

### Usage
``` bash
leverage credentials update [options]
```

The `credentials update` subcommand is used to set up or update any of the credentials needed to interact with the AWS environment.

It will try to fetch the structure of the organization in the architecture in order to generate all the [AWS CLI profiles required to interact with the environment](../../../identities/credentials.md) and update the `project.yaml` file with the id of all accounts.

This command will create backups of the previous credentials configuration before attempting to modify the current one.

### Options
* `--profile`: credentials to be set/updated. It can take `boostrap`, `management` or `security`.
* `--file`: path to a `.csv` access keys file containing the credentials as produced by AWS console when generating the programmatic keys. If not given, the user will be prompted for the credentials.
* `--only-accounts-profiles`: skip credentials setting, only fetch the organization structure and update the required profiles for the accounts.