# Configure the Security and Shared accounts
Just a couple more accounts to get ready. Let's go!

## Deploy the Security account's layers
The next account to orchestrate is the **security** account.

This account is intended for centralized user management via a IAM roles based cross organization authentication approach. This means that most of the users for your organization will be defined in this account and those users will access the different accounts through this one.

First, go to the `security` directory.
``` bash
cd security
```

### Terraform backend layer
Move into the `us-east-1/base-tf-backend` directory and run:
``` bash
leverage terraform init --skip-validation
leverage terraform apply
```
!!! info "More information on [`terraform init`](../../user-guide/leverage-cli/reference/terraform#init) and [`terraform apply`](../../user-guide/leverage-cli/reference/terraform#apply)"

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
Now, move into the `global/base-identities` directory, and run:
``` bash
leverage terraform init
leverage terraform apply
```

### Security layer
The last layer for the `security` account is the security layer. Move into the `us-east-1/security-base` directory and run:
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
Move into the `us-east-1/base-tf-backend` directory and run:
``` bash
leverage terraform init --skip-validation
leverage terraform apply
```
!!! info "More information on [`terraform init`](../../user-guide/leverage-cli/reference/terraform#init) and [`terraform apply`](../../user-guide/leverage-cli/reference/terraform#apply)"

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
Now move into the `global/base-identities` directory and run:
``` bash
leverage terraform init
```

### Security layer
Next, move into the `us-east-1/security-base` directory:
``` bash
leverage terraform init
leverage terraform apply
```

### Network layer
The last layer should be the network layer, so switch to that `us-east-1/base-network` and run:
``` bash
leverage terraform init
leverage terraform apply
```

## Next steps
You have now a fully deployed landing zone configuration for the Leverage Reference Architecture for AWS, with its three accounts `management`, `security` and `shared` ready to be used.

Next, you are going to tackle de last steps configuring the credentials for a user to interact with your Leverage project securely.
