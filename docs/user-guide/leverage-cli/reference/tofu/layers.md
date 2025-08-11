# Layers parameter

This parameter can be used with the following Leverage CLI OpenTofu/Terraform commands:

* `init`
* `plan`
* `apply`
* `output`
* `destroy`

Value:

| Parameter  | Type   | Description                                       |
|:-----------|:-------|:--------------------------------------------------|
| `--layers` | string | A comma separated list of layer's relative paths |

## Common workflow

When using the `--layers` parameter, these commands should be run from `account` or `layers-container-directory` directories.

**Example:**

For this structure:

```

 home
 ├── user
 │   └── project
 │       └── management
 │           ├── global
 │           |   └── security-base
 │           |   └── sso
 │           └── us-east-1
 │               └── terraform-backend

```

...any of the aforementioned commands, combined with `--layers`, can be called from `/home/user/project/management/`, `/home/user/project/management/global/` or `/home/user/project/management/us-east-1/`.

The value for this parameter is a comma separated list of layer's relative paths.

Leverage CLI will iterate through the layer's relative paths, going into each one, executing the command and going back to the original directory.

**Example:**

For this command, from `/home/user/project/management/`:

```bash
leverage tofu plan --layers us-east-1/terraform-backend,global/security-base
```

...the Leverage CLI will:

* check each one of the layer's relative paths exists
* go into `us-east-1/terraform-backend` directory
* run the `plan` command
* go back to `/home/user/project/management/`
* go into `global/security-base` directory
* run the `plan` command
* go back to `/home/user/project/management/`

## The `init` case

When running `init` Leverage CLI runs a [validation](../tofu/#validate-layout).

When using the `--layers` option, the validation is run for every layer before the command itself is run.

**Example:**

For this command, from `/home/user/project/management/`:

```bash
leverage tofu init --layers us-east-1/terraform-backend,global/security-base
```

...the Leverage CLI will:

* check each one of the layer's relative paths exists
* go into `us-east-1/terraform-backend` directory
* run the `validate-layout` command
* go back to `/home/user/project/management/`
* go into `global/security-base` directory
* run the `validate-layout` command
* go back to `/home/user/project/management/`
* go into `us-east-1/terraform-backend` directory
* run the `init` command
* go back to `/home/user/project/management/`
* go into `global/security-base` directory
* run the `init` command
* go back to `/home/user/project/management/`

This is done this way to prevent truncated executions. Meaning, if any of the validation fails, the user will be able to fix whatever has to be fixed and run the command again as it is.

!!! info "Skipping the validation"
    The `--skip-validation` flag still can be used here with `--layers`.

## OpenTofu/Terraform parameters and flags

OpenTofu/Terraform parameters and flags can still be passed when using the `--layers` parameter.

**Example:**


```bash
leverage tofu apply --layers us-east-1/terraform-backend,global/security-base -auto-approve
```
