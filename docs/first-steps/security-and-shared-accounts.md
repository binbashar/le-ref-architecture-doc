# Orchestrate the Security and Shared accounts

## Deploy the Security account's layers

The next account to orchestrate is the **security** account.

This account is intended for centralized user management via a IAM roles based cross organization authentication approach. This means that most of the users for your organization will be defined in this account and those users will access the different accounts through this one.

First, place yourself in the `security` directory.

``` bash
cd security
```

### Terraform backend layer

Move into the `base-tf-backend` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```

Now, to push the local `.tfstate` to the bucket, uncomment the `backend` section for the `terraform` configuration in `security/base-tf-backend/config.tf`

``` terraform
  backend "s3" {
    key = "security/tf-backend/terraform.tfstate"
  }
```

And run again:

``` bash
leverage terraform init
```

When prompted, answer `yes`.

Now you can safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files created during the `apply` step.

### Identities layer

Now, move into the `base-identities` directory and run:

``` bash
leverage terraform init
```

Copy the files fo this accounts' users into the `keys` subdirectoy. For this guide's case we need the keys files for `natasha.romanoff`, `kit.walker`, `edward.stark` and `john.wick`.

To prevent Terraform from erroring out you need to import the role `OrganizationAccountAccessRole` that was already created in the [`management`'s account identities layer](../management-account/#identities-layer) before deploying this layer.

``` bash
leverage terraform import module.iam_assumable_role_oaar.aws_iam_role.this[0] OrganizationAccountAccessRole
leverage terraform apply
```

!!! info "zsh globbing"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

### Security layer

The last layer for the `security` account is the security layer. Move into the `security-base` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```

## Deploy the Shared account's layers

The last account in this deployment is the `shared` account.

The account's objective is managing infrastructure for shared services and resources like directory services, DNS, VPN, monitoring tools or centralized logging solutions.

Place yourself in the `shared` directory.

``` bash
cd shared
```

### Terraform backend layer

Move into the `base-tf-backend` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```

Now, to push the local `.tfstate` to the bucket, uncomment the `backend` section for the `terraform` configuration in `shared/base-tf-backend/config.tf`

``` terraform
  backend "s3" {
    key = "shared/tf-backend/terraform.tfstate"
  }
```

And run a second time:

``` bash
leverage terraform init
```

When prompted, answer `yes`.

Now you can safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files created during the `apply` step.

### Identities layer

Now move into the `base-identities` directory and run:

``` bash
leverage terraform init
```

You also need to import the role `OrganizationAccountAccessRole` in this layer.

``` bash
leverage terraform import module.iam_assumable_role_oaar.aws_iam_role.this[0] OrganizationAccountAccessRole
leverage terraform apply
```

!!! info "zsh globbing"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

### Security layer

Next, move into the `security-base` directory:

``` bash
leverage terraform init
leverage terraform apply
```

### Network layer

The last layer for the `shared` account is the network layer, so move into the `base-network` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```

## Next steps
You have now a fully deployed landing zone configuration for the Leverage Reference Architecture for AWS, with its three accounts `management`, `security` and `shared` ready to be used.

Next, you are going to tackle de last steps configuring the credentials for a user to interact with your Leverage project securely.
