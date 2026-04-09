# Command: `tofu` | `tf`

The `tofu` command provides the OpenTofu executable with specific configuration values required by Leverage.

It transparently manages authentication, either Multi-Factor or Single Sign-On, on behalf of the user on commands that require it. SSO authentication takes precedence over MFA when both are active.

Some commands can only be run at **layer** level and will not run anywhere else in the project.

The command can also be invoked via its shortened version `tf`.

---
## `init`

### Usage
``` bash
leverage tofu init [option] [arguments]
```

Equivalent to `tofu init`.

All arguments given are passed as received to OpenTofu.

Can only be run at **layer** level if `--layers` is not set, or at **account** level otherwise.

[Layout validation](#validate-layout) is performed before actually initializing OpenTofu unless explicitly indicated against via the `--skip-validation` flag.

### Options
* `--skip-validation`: Skips layout validation.
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

!!! info "Regarding S3 backend keys"
    If the S3 backend block is set, and no key was defined, Leverage CLI will try to create a new one automatically and store it in the `config.tf` file. It will be based on the layer path relative to the account.

---
## `plan`

### Usage
``` bash
leverage tofu plan [arguments]
```

Equivalent to `tofu plan`.

All arguments given are passed as received to OpenTofu.

Can only be run at **layer** level if `--layers` is not set, or at **account** level otherwise.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

!!! info "using indexes"
    When using `-target` flag with resources using indexes, it is possible you need to escape chars like this:

    **Example:**

    - For target:  `aws_route53_record.main["*.binbash.com.ar"]`
    - Use:  `leverage tf plan -target='aws_route53_record.main[\"*.binbash.com.ar\"]'`

    Note the single and double quotes. 
    This is valid for ZSH and BASH.

---
## `apply`

### Usage
``` bash
leverage tofu apply [arguments]
```

Equivalent to `tofu apply`.

All arguments given are passed as received to OpenTofu.

Can only be run at **layer** level if `--layers` is not set, or at **account** level otherwise.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

!!! info "using indexes"
    When using `-target` flag with resources using indexes, it is possible you need to escape chars.

    See notes for `plan` [here](#plan).

---
## `destroy`

### Usage
``` bash
leverage tofu destroy [arguments]
```

Equivalent to `tofu destroy`.

All arguments given are passed as received to OpenTofu.

Can only be run at **layer** level if `--layers` is not set, or at **account** level otherwise.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

!!! info "using indexes"
    When using `-target` flag with resources using indexes, it is possible you need to escape chars.

    See notes for `plan` [here](#plan).


---
## `output`

### Usage
``` bash
leverage tofu output [arguments]
```

Equivalent to `tofu output`.

All arguments given are passed as received to OpenTofu.

Can only be run at **layer** level if `--layers` is not set, or at **account** level otherwise.

### Options
* `--layers`: Applies command to layers listed in this option. (see more info [here](./layers))

---
## `version`

### Usage
``` bash
leverage tofu version
```

Equivalent to `tofu version`.

Print OpenTofu version.

---
## `format`

### Usage
``` bash
leverage tofu format [arguments]
```

Equivalent to `tofu fmt -recursive`.

Recursively format all files in the architecture to the OpenTofu code style.

All arguments given are passed as received to OpenTofu.

---
## `validate`

### Usage
``` bash
leverage tofu validate
```

Equivalent to `tofu validate`.

Check the infrastructure definition's consistency.

---
## `validate-layout`

### Usage
``` bash
leverage tofu validate-layout
```

Check the OpenTofu backend configuration in the code definition.


!!! info "When you are setting up the backend layer for the very first time, the S3 bucket does not yet exist. When running validations, Leverage CLI will detect that the S3 Key does not exist or cannot be generated. Therefore, it is necessary to first create the S3 bucket by using the init `--skip-validation` flag in the initialization process, and then move the "tfstate" file to it."


Values checked:

* Environment name in account configuration
* S3 bucket key
* AWS CLI profile name prefix
* S3 Bucket name prefix
* DynamoDB locking table name prefix
Can only be run at **layer** level if `--layers` is not set, or at **account** otherwise.

---
## `import`

### Usage
``` bash
leverage tofu import ADDRESS ID
```

Equivalent to `tofu import`.

Import the resource with the given ID into the OpenTofu state at the given ADDRESS.

Can only be run at **layer** level.

!!! info "zsh globbing"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

    **Examples:**

    - Opt-1:  `leverage tf import module.s3_bucket.aws_s3_bucket.this\[0\] s3-bag-data-bucket`
    - Opt-2:  `noglob leverage tf import module.s3_bucket.aws_s3_bucket.this[0] s3-bag-data-bucket`  
