# Command: `terraform` | `tf`

The `terraform` command is a wrapper for a containerized installation of Terraform. It provides the Terraform executable with specific configuration values required by Leverage.

It transparently handles MFA on behalf of the user in the commands that require it. Some commands can only be run at **layer** level and will not run anywhere else in the project.

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

Open a shell into the Terraform container in the current directory. An MFA-authenticated shell can only be opened at **layer** level.

### Options
* `--mfa`: Authenticate via MFA upon launching shell to allow for ease of use when MFA is required.

---
## `format`

### Usage
``` bash
leverage terraform format [option]
```

Equivalent to `terraform fmt -recursive`.

Recursively format all files in the architecture to the Terraform code style.

Does not require MFA.

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

Does not require MFA.

---
## `import`

### Usage
``` bash
leverage terraform import ADDRESS ID
```

Equivalent to `terraform import`.

Import the resource with the given ID into the Terraform state at the given ADDRESS. 

Can only be run at **layer** level.

---
## `aws`

### Usage
``` bash
leverage terraform aws AWS_CLI_COMMAND
```

Utility command to run AWS CLI commands directly on the Terraform container. AWS_CLI_COMMAND takes the form of any arbitrary valid AWS CLI command without the executable name. For example for the command `aws --output json sts get-caller-identity`, AWS_CLI_COMMAND is `--output json sts get-caller-identity`.
