# Command: `terraform` | `tf`

The `terraform` command is a wrapper for a containerized installation of Terraform. It provides the Terraform executable with specific configuration values required by Leverage.

It transparently manages authentication, either Multi-Factor or Single Sign-On, on behalf of the user on commands that require it. SSO authentication takes precedence over MFA when both are active.

Some commands can only be run at **layer** level and will not run anywhere else in the project.

The command can also be invoked via its shortened version `tf`.

---
## `init`

### Usage
``` bash
leverage terraform init [option] [arguments]
```

Equivalent to `terraform init`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level if `--layers` is not set, or at **account** or **layers-container-directory** if it is.

[Layout validation](#validate-layout) is performed before actually initializing Terraform unless explicitly indicated against via the `--skip-validation` flag.

### Options
* `--skip-validation`: Skips layout validation.
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

!!! info "Regarding S3 backend keys"
    If the S3 backend block is set, and no key was defined, Leverage CLI will try to create a new one autoatically and store it in the `config.tf` file. It will be based on the layer path relative to the account.

---
## `plan`

### Usage
``` bash
leverage terraform plan [arguments]
```

Equivalent to `terraform plan`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level if `--layers` is not set, or at **account** or **layers-container-directory** if it is.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

---
## `apply`

### Usage
``` bash
leverage terraform apply [arguments]
```

Equivalent to `terraform apply`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level if `--layers` is not set, or at **account** or **layers-container-directory** if it is.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

---
## `destroy`

### Usage
``` bash
leverage terraform destroy [arguments]
```

Equivalent to `terraform destroy`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level if `--layers` is not set, or at **account** or **layers-container-directory** if it is.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

---
## `output`

### Usage
``` bash
leverage terraform output [arguments]
```

Equivalent to `terraform output`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level if `--layers` is not set, or at **account** or **layers-container-directory** if it is.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

---
## `version`

### Usage
``` bash
leverage terraform version
```

Equivalent to `terraform version`.

Print Terraform version.

---
## `shell`

### Usage
``` bash
leverage terraform shell [option]
```

Open a shell into the Terraform container in the current directory. An authenticated shell can only be opened at **layer** level.

!!! info "[:books: Terraform shell environment documentation](../shell.md)"

### Options
* `--mfa`: Authenticate via MFA upon launching shell.
* `--sso`: Authenticate via SSO upon launching shell.

_Note:_ When `--sso` flag is used, the `--mfa` flag status is ignored.

!!! example "What if I want to run a Terraform command that is not supported by the CLI?"
    One common error you could encounter is `"Error acquiring the state lock"`, where you might need to use `force-unlock`. You can do the following:

    1. `leverage terraform shell --sso`.       
    2.  Then from inside the container: `terraform force-unlock LOCK-ID`.

---
## `format`

### Usage
``` bash
leverage terraform format [arguments]
```

Equivalent to `terraform fmt -recursive`.

Recursively format all files in the architecture to the Terraform code style.

All arguments given are passed as received to Terraform.

---
## `validate`

### Usage
``` bash
leverage terraform validate
```

Equivalent to `terraform validate`.

Check the infrastructure definition's consistency.

---
## `validate-layout`

### Usage
``` bash
leverage terraform validate-layout
```

Check the Terraform backend configuration in the code definition.


!!! info "When you are setting up the backend layer for the very first time, the S3 bucket does not yet exist. When running validations, Leverage CLI will detect that the S3 Key does not exist or cannot be generated. Therefore, it is necessary to first create the S3 bucket by using the init `--skip-validation` flag in the initialization process, and then move the "tfstate" file to it."


Values checked:

* Environment name in account configuration
* S3 bucket key
* AWS CLI profile name prefix
* S3 Bucket name prefix
* DynamoDB locking table name prefix


---
## `import`

### Usage
``` bash
leverage terraform import ADDRESS ID
```

Equivalent to `terraform import`.

Import the resource with the given ID into the Terraform state at the given ADDRESS.

Can only be run at **layer** level.

!!! info "zsh globbing"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

    **Examples:**

    - Opt-1:  `leverage tf import module.s3_bucket.aws_s3_bucket.this\[0\] s3-bag-data-bucket`
    - Opt-2:  `noglob leverage tf import module.s3_bucket.aws_s3_bucket.this[0] s3-bag-data-bucket`  
