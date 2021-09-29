# Orchestrate the Management account

Finally we reach the point in which you'll get to actually create the infrastructure in our AWS environment.

Some accounts and layers rely on other accounts/layers being already deployed, creating dependencies between each other and establishing an order in which all layers should be deployed. We will go through these dependency chains in order.

!!! success "Basic Landing Zone AWS Expenses"
    By default this AWS Reference Architecture configuration should not incur in any costs.

The **management** account is used to configure and access all AWS Organizations managed accounts, also, billing and financial decisions are enforced though this account.

## Deploy the Management account's layers

To begin, place yourself in the `management` account directory.

``` bash
cd management
```

### Terraform backend layer

Move into the `base-tf-backend` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```

All `apply` commands will prompt for confirmation, answer `yes` when this happens.

!!! info "More information on [`terraform init`](../../user-guide/base-workflow/leverage-cli/reference/terraform#init) and [`terraform apply`](../../user-guide/base-workflow/leverage-cli/reference/terraform#apply)"
!!! note
    The `apply` command may result in an error similar to:

    ```
    Error: error creating public access block policy for S3 bucket (ex-security-terraform-backend): 
    OperationAborted: A conflicting conditional operation is currently in progress against this resource. 
    Please try again.
    ```

    If this happens, please re-run the command.

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

### Identities layer

Move into the `base-identities` directory and run:

``` bash
leverage terraform init
```

To securely manage the users credentials, all members of the organization that are bound to interact with the AWS environment, and are therefore listed in the `project.yaml` configuration file, should create GPG keys of their own. Then, they should export them and share their public key files with whoever is in charge of the project infrastructure in order to be able to create their respective IAM users. In this guide's case, that person it is you.

!!! info "[:books: How to create and manage GPG keys](../../user-guide/features/identities/gpg/)"

Once you get hold of the keys files, copy them to the `keys` subdirectory, respecting the user's configured name. For the `management` account in this guide, we need the keys for `kit.walker` and `natasha.romanoff`.

Finally, run:

``` bash
leverage terraform apply
```

### Organizations layer

Next, move into the `organizations` directory and run:

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

!!! info "More information on [`terraform import`](../../user-guide/base-workflow/leverage-cli/reference/terraform#import)"

### Security layer

The last layer for the `management` account is the security layer. So, move into the `security-base` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```

## Update the bootstrap credentials

Now that the `management` account has been deployed, and more specifically, all Organizations accounts have been created (in the [organizations layer](#organizations-layer)) you need to update the credentials for the bootstrap process before proceeding to deploy any of the remaining accounts.

This will fetch the organizations structure from the AWS environment and create individual profiles associated with each account for the AWS CLI to use. So, run:

``` bash
leverage credentials update --profile bootstrap --only-accounts-profiles
```
<pre><code><span class="fsg-timestamp">[10:24:36.030]</span> INFO     Loading configuration file.
<span class="fsg-timestamp">[10:24:40.265]</span> INFO     Configuring accounts' profiles.
<span class="fsg-timestamp">[10:24:40.268]</span> INFO     Fetching organization accounts.
<span class="fsg-timestamp">[10:24:42.383]</span> INFO     Backing up account profiles file.
<span class="fsg-timestamp">[10:24:42.938]</span> INFO             Configuring profile <b>me-management-oaar</b>
<span class="fsg-timestamp">[10:24:45.051]</span> INFO             Configuring profile <b>me-security-oaar</b>
<span class="fsg-timestamp">[10:24:47.164]</span> INFO             Configuring profile <b>me-shared-oaar</b>
<span class="fsg-timestamp">[10:24:49.278]</span> INFO     <b>Account profiles configured in:</b> <span class="fsg-path">/home/user/.aws/me/config</span>
<span class="fsg-timestamp">[10:24:49.281]</span> INFO     Updating project configuration file.
<span class="fsg-timestamp">[10:24:49.345]</span> INFO     Finished updating <b>bootstrap</b> credentials.
</code></pre>

!!! info "More information on [`credentials update`](../../user-guide/base-workflow/leverage-cli/reference/credentials#update)"

## Next steps
You have successfully orchestrated the `management` account for your project and configured the credentials for the following steps.

Next, you will orchestrate the remaining accounts, `security` and `shared`.