# Configure the Management account
Finally we reach the point in which you'll get to actually create the infrastructure in our AWS environment.

Some accounts and layers rely on other accounts or layers to be deployed first, which creates dependencies between them and establishes an order in which all layers should be deployed. We will go through these dependencies in order.

The **management** account is used to configure and access all the accounts in the AWS Organization. Consolidated Billing and Cost Management are also enforced though this account.

!!! success "Costs associated with this solution"
    By default this AWS Reference Architecture configuration should not incur in any costs.

## Deploy the Management account's layers
To begin, place yourself in the `management` account directory.
``` bash
cd management
```

### Terraform backend layer
Move into the `us-east-1/base-tf-backend` directory and run:
``` bash
leverage terraform init --skip-validation
leverage terraform apply
```

All `apply` commands will prompt for confirmation, answer `yes` when this happens.

!!! info "More information on [`terraform init`](/user-guide/leverage-cli/reference/terraform#init) and [`terraform apply`](/user-guide/leverage-cli/reference/terraform#apply)"

Now, the infrastructure for the Terraform state management is created. The next step is to push the local `.tfstate` to the bucket. To do this, uncomment the `backend` section for the `terraform` configuration in `management/base-tf-backend/config.tf`

``` terraform
  backend "s3" {
    key = "management/tf-backend/terraform.tfstate"
  }
```

And run once more:
``` bash
leverage terraform init
```

When prompted, answer `yes`. Now you can safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files created during the `apply` step.

!!! info "Terraform backend"
    More information regarding what is the Terraform backend and Terraform state management:

    * [Terraform backend](https://www.terraform.io/docs/language/settings/backends/index.html)
    * [How to manage Terraform state](https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa)

### Organizations layer
Next, in the same fashion as in the previous layer, move into the `global/organizations` directory and run:
``` bash
leverage terraform init
leverage terraform apply
```

The AWS account that you created manually is the `management` account itself, so to prevent Terraform from trying to create it and error out, this account definition is commented by default in the code. Now you need to make the Terraform state aware of the link between the two. To do that, uncomment the `management` organizations account resource in `accounts.tf`

``` terraform
resource "aws_organizations_account" "management" {
  name  = "${var.project_long}-management"
  email = local.management_account.email
}
```

Grab the management account id that previously was automatically filled in for us in the `project.yaml` file

``` yaml
...
organization:
  accounts:
    - name: management
      email: myexample-aws@example.com
      id: '000123456789'
...
```

And run:
``` bash
leverage terraform import aws_organizations_account.management 000123456789
```

!!! info "More information on [`terraform import`](/user-guide/leverage-cli/reference/terraform#import)"

!!! info "Getting errors with zsh?"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

### Security layer
Change directory to `us-east-1/security-base` and run this:
``` bash
leverage terraform init
leverage terraform apply
```

## Update the bootstrap credentials
Now that the `management` account has been deployed, and more specifically, all Organizations accounts have been created (in the [organizations layer](#organizations-layer)) you need to update the credentials for the bootstrap process before proceeding to deploy any of the remaining accounts.

This will fetch the organizations structure from the AWS environment and create individual profiles associated with each account for the AWS CLI to use. So, run:
``` bash
$ leverage credentials configure --type BOOTSTRAP --skip-access-keys-setup
[09:08:44.762] INFO     Loading configuration file.
[09:08:44.785]     Loading project environment configuration file.
[09:08:44.791]     Loading Terraform common configuration.
[09:08:53.247]     Configuring assumable roles.
[09:08:53.248]     Fetching organization accounts.
[09:08:55.193]     Backing up account profiles file.
[09:08:55.761]             Configuring profile me-management-oaar
[09:08:59.977]             Configuring profile me-security-oaar
[09:09:04.081]             Configuring profile me-shared-oaar
[09:09:08.305]     Account profiles configured in: /home/user/.aws/me/config
[09:09:08.307] INFO     Updating project's Terraform common configuration.
```

!!! info "More information on [`credentials configure`](/user-guide/leverage-cli/reference/credentials#configure)"

### SSO layer
Before working on the SSO layer you have to navigate to the [AWS IAM Identity Center page](https://console.aws.amazon.com/singlesignon/), set the region to the primary region you've chosen and enable Single Sign-On (SSO) by clicking on the `Enable` button.

Now back to the terminal. The SSO layer is deployed in two steps. First, switch to the `global/sso` directory and run the following:
``` bash
leverage terraform init
leverage terraform apply
```

Secondly, open the `account_assignments.tf` file and uncomment the entire section that starts with this line:
```
# module "account_assignments" {
#   source = "github.com/binbashar/terraform-aws-sso.git//modules/account-assignments?ref=0.7.1"

[REDACTED]

#   ]
# }
```

After that, run these commands:
``` bash
leverage terraform init
leverage terraform apply
```

## Next steps
You have successfully orchestrated the `management` account for your project and configured the credentials for the next steps.

Now, let's enable SSO for the rest of the process.
