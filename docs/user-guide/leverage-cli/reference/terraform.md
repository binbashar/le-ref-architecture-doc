# Command: `terraform` | `tf`

The `terraform` command is a wrapper for a containerized installation of Terraform. It provides the Terraform executable with specific configuration values required by Leverage.

It transparently handles authentication whether it is Multi-Factor or via Single Sign-On on behalf of the user in the commands that require it. SSO Authentication takes precedence over MFA when both are active. 

Some commands can only be run at **layer** level and will not run anywhere else in the project.

The command can also be invoked via its shortened version `tf`.

---
## `init`

### Usage
``` bash
leverage terraform init [arguments]
```

Equivalent to `terraform init`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level.

---
## `plan`

### Usage
``` bash
leverage terraform plan [arguments]
```

Equivalent to `terraform plan`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level.

---
## `apply`

### Usage
``` bash
leverage terraform apply [arguments]
```

Equivalent to `terraform apply`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level.

---
## `destroy`

### Usage
``` bash
leverage terraform destroy [arguments]
```

Equivalent to `terraform destroy`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level.

---
## `output`

### Usage
``` bash
leverage terraform output [arguments]
```

Equivalent to `terraform output`.

All arguments given are passed as received to Terraform.

Can only be run at **layer** level.

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

    1 - `leverage terraform shell --sso` 

    2 - Then from inside the container: `terraform force-unlock LOCK-ID`


---
## `format`

### Usage
``` bash
leverage terraform format [option]
```

Equivalent to `terraform fmt -recursive`.

Recursively format all files in the architecture to the Terraform code style.

### Options
* `--check`: Only perform format checking, do not overwrite the files.

---
## `validate`

### Usage
``` bash
leverage terraform validate
```

Equivalent to `terraform validate`.

Checks the infrastructure definition's consistency. 

---
## `import`

### Usage
``` bash
leverage terraform import ADDRESS ID
```

Equivalent to `terraform import`.

Import the resource with the given ID into the Terraform state at the given ADDRESS. 

Can only be run at **layer** level.
