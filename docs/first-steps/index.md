---
hide:
    - navigation
---
![binbash-logo](../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# First Steps

The objective of this guide is to introduce the user to our [**Binbash Leverage Reference AWS Cloud Solutions Architecture**](../how-it-works/) workflow through the complete deployment of a basic landing zone configuration.

We'll walk through all steps involved, from initial considerations, to post deployment access credentials configuration, ending up with a fully usable Leverage Reference Architecture deployment. The user will gain an understanding of the structure of a Leverage project as well as familiarity with the tooling used to manage it.

## Preparation and initial considerations
---
For this guide's purposes we'll be in charge of creating and deploying the infrastructure for an *Example* product.

### Create an AWS account
First and foremost we need to [create an AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) for our project's deployment.

This will be the management (root) account for our project, so we'll call it `example-management` and register it under `example-aws@example.com`. To protect this account, [enabling Multi Factor Authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html#id_root-user_manage_mfa) is **highly** encouraged, also, reviewing the [account's billing setup](https://console.aws.amazon.com/billing/home?#/account) is always a good idea before proceeding.

!!! note
    The reason behind de name choice for the account will become apparent further down the line.

To be able to interact with the AWS environment we will need a special IAM user. For this, we'll log in the [AWS Web Console](https://console.aws.amazon.com/) with our recently created account and we'll [create the `mgmt-org-admin` IAM user](https://docs.aws.amazon.com/mediapackage/latest/ug/setting-up-create-iam-user.html) giving it admin privileges by attaching the `AdministratorAccess` policy to it.

Lastly we'll generate programmatic access keys for the `mgmt-org-admin` user, and then either copy them to a secure location or download the `.csv` file that AWS generates for us.

!!! info "More information regarding the AWS account creation and naming conventions used: [:books: Organization account setup guide](../user-guide/organization/organization-init#user-guide)."

### Install [Leverage CLI](../how-it-works/leverage-cli/index.md)
Now, to manage our Leverage project and operate the whole Leverage stack we'll need to install Leverage CLI, on a shell we run:

``` bash
pip3 install leverage
```
!!! info "More information regarding [Leverage CLI installation](../user-guide/base-workflow/leverage-cli/install-leverage-cli/) and [shell autocompletion](../user-guide/base-workflow/leverage-cli/install-leverage-cli#shell-completion)."

### Create the project's directory
Each Leverage project must be in its own working directory. So, we create one named `example` for it.

``` bash
mkdir example
cd example
```

## Project setup
---
Up until now we don't have any infrastructure to orchestrate in our project, it is empty. Let's take care of that.

### Initialize the project
When setting up a Leverage project we first need to initialize the directory where it will reside.

``` bash
leverage project init
```
<!--
NOTE: Custom coloring and formatting in a code block can be achieved by using pure html instead of relying in the triple backtick notation.
e.g:
<pre><code>This is normal text.
<b>This is bold text.</b>
<i><span style="color:blue;">This is blue italic text.</span></i>
</code></pre>
-->
```
[09:30:54.027] INFO     No .leverage directory found in user's home. Creating.
[09:30:54.030] INFO     No project template found. Cloning template.
[09:30:54.978] INFO     Finished cloning template.
[09:30:54.981] INFO     Initializing git repository in project directory.
[09:30:54.990] INFO     No project configuration file found. Creating an example config.
```
!!! info "More information on [`project init`](../user-guide/base-workflow/leverage-cli/reference/project#init)"

Initializing a project creates the global configurations directory for Leverage CLI and downloads the templates used to generate the project's files structure. It then initializes a `git` repository in the working directory, and creates a file called `project.yaml`. Leverage projects are by design repositories to leverage some of the capabilities of `git` and because it is assumed that the code in the project will be versioned.

Once the project is initialized we need to fill in the correct information in the configuration file. That is to say, the project name, a two-letter-long short version of the project name, users that will be registered, groups and so on.

After filling in the data we will end up with a configuration file similar to this one:

???+ note "`project.yaml` for *Example* project"
    ```yaml
    meta:
      enable_mfa: false

    project_name: example
    short_name: ex

    primary_region: us-east-1
    secondary_region: us-west-2

    organization:
      accounts:
      - name: management
        email: example-aws@example.com
      - name: security
        email: example-aws+security@example.com
      - name: shared
        email: example-aws+shared@example.com
      organizational_units:
      - name: security
        policy:
        - aws_organizations_policy.default
        accounts:
        - security
      - name: shared
        policy:
        - aws_organizations_policy.standard
        accounts:
        - shared

    accounts:
      management:
        groups:
        - name: admins
          users:
          - kit.walker
          - natasha.romanoff
          policies:
          - '"arn:aws:iam::aws:policy/AdministratorAccess"'
      security:
        groups:
        - name: admins
          users:
          - natasha.romanoff
        - name: auditors
          users:
          - kit.walker
          policies:
          - aws_iam_policy.assume_auditor_role.arn
        - name: devops
          users:
          - natasha.romanoff
          - edward.stark
          - john.wick
          policies:
          - aws_iam_policy.assume_devops_role.arn
      shared:
        networks:
        - cidr_block: "172.18.0.0/20"
          availability_zones: [a,b]
          private_subnets:
          - "172.18.0.0/23"
          - "172.18.2.0/23"
          public_subnets:
          - "172.18.6.0/23"
          - "172.18.8.0/23"
    ```

### Set up bootstrap credentials
To be able to interact with our AWS environment we first need to configure the credentials to enable AWS CLI to do so. Using the keys obtained in the previous [account creation step](#create-an-aws-account) we run:

``` bash
leverage credentials create
```
```
[09:37:17.530] INFO     Loading configuration file.
[09:37:18.477] INFO     Configuring default profile information.
[09:37:20.424] INFO     Default profile configured in: /home/user/.aws/ex/config
[09:37:20.426] INFO     Configuring bootstrap credentials.
> Select the means by which you'll provide the programmatic keys: Manually
> Key: AKIAU1OF18IXH2EXAMPLE
> Secret: ****************************************
[09:37:51.638] INFO     Bootstrap credentials configured in: /home/user/.aws/ex/credentials
[09:37:53.497] INFO     Fetching management account id.
[09:37:55.344] INFO     Updating project configuration file.
[09:37:55.351] INFO     Finished setting up bootstrap credentials.
```
!!! info "More information on [`credentials create`](../user-guide/base-workflow/leverage-cli/reference/credentials#create)"

And provide the key and secret when prompted. We could also provide a path to the access keys file with the `--file` option in case we would like to avoid the interactive bits.

During the credentials setup, the AWS account id is filled in for us in the project configuration file.

### Create the configured project
Now we will finally create all the infrastructure definition in our project, for that we run:

``` bash
leverage project create
```
```
[09:40:54.934] INFO     Loading configuration file.
[09:40:54.950] INFO     Creating project directory structure.
[09:40:54.957] INFO     Finished creating directory structure.
[09:40:54.958] INFO     Setting up common base files.
[09:40:54.964] INFO     Account: Setting up management.
[09:40:54.965] INFO             Layer: Setting up config.
[09:40:54.968] INFO             Layer: Setting up base-tf-backend.
[09:40:54.969] INFO             Layer: Setting up base-identities.
[09:40:54.984] INFO             Layer: Setting up organizations.
[09:40:54.989] INFO             Layer: Setting up security-base.
[09:40:54.990] INFO     Account: Setting up security.
[09:40:54.991] INFO             Layer: Setting up config.
[09:40:54.994] INFO             Layer: Setting up base-tf-backend.
[09:40:54.995] INFO             Layer: Setting up base-identities.
[09:40:55.001] INFO             Layer: Setting up security-base.
[09:40:55.002] INFO     Account: Setting up shared.
[09:40:55.003] INFO             Layer: Setting up config.
[09:40:55.006] INFO             Layer: Setting up base-tf-backend.
[09:40:55.007] INFO             Layer: Setting up base-identities.
[09:40:55.008] INFO             Layer: Setting up security-base.
[09:40:55.009] INFO             Layer: Setting up base-network.
[09:40:55.013] INFO     Project configuration finished.
               INFO     Reformatting terraform configuration to the standard style.
[09:40:55.743] INFO     Finished setting up project.
```
!!! info "More information on [`project create`](../user-guide/base-workflow/leverage-cli/reference/project#create)"

In this step, the directory structure for the project and all definition files are created using the information from the `project.yaml` file and checked for correct formatting.

We end up with something that looks like this:

???+ note "*Example* project file structure"
    <!--- TODO: Prettyfy --->
    ```
    example
    ├── build.env
    ├── config
    │   └── common.tfvars
    ├── management
    │   ├── base-identities
    │   │   ├── account.tf
    │   │   ├── config.tf
    │   │   ├── groups.tf
    │   │   ├── keys
    │   │   ├── locals.tf
    │   │   ├── outputs.tf
    │   │   ├── roles.tf
    │   │   ├── users.tf
    │   │   └── variables.tf
    │   ├── base-tf-backend
    │   │   ├── config.tf
    │   │   ├── locals.tf
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── config
    │   │   ├── account.tfvars
    │   │   └── backend.tfvars
    │   ├── organizations
    │   │   ├── accounts.tf
    │   │   ├── config.tf
    │   │   ├── delegated_administrator.tf
    │   │   ├── locals.tf
    │   │   ├── organizational_units.tf
    │   │   ├── organization.tf
    │   │   ├── policies_scp.tf
    │   │   ├── policy_scp_attachments.tf
    │   │   ├── service_linked_roles.tf
    │   │   └── variables.tf
    │   └── security-base
    │       ├── account.tf
    │       ├── config.tf
    │       └── variables.tf
    ├── project.yaml
    ├── security
    │   ├── base-identities
    │   │   ├── account.tf
    │   │   ├── config.tf
    │   │   ├── groups_policies.tf
    │   │   ├── groups.tf
    │   │   ├── keys
    │   │   ├── locals.tf
    │   │   ├── outputs.tf
    │   │   ├── role_policies.tf
    │   │   ├── roles.tf
    │   │   ├── users.tf
    │   │   └── variables.tf
    │   ├── base-tf-backend
    │   │   ├── config.tf
    │   │   ├── locals.tf
    │   │   ├── main.tf
    │   │   └── variables.tf
    │   ├── config
    │   │   ├── account.tfvars
    │   │   └── backend.tfvars
    │   └── security-base
    │       ├── account.tf
    │       ├── config.tf
    │       ├── iam_access_analizer.tf
    │       ├── locals.tf
    │       └── variables.tf
    └── shared
        ├── base-identities
        │   ├── account.tf
        │   ├── config.tf
        │   ├── locals.tf
        │   ├── policies.tf
        │   ├── roles.tf
        │   ├── service_linked_roles.tf
        │   └── variables.tf
        ├── base-network
        │   ├── account.tf
        │   ├── config.tf
        │   ├── locals.tf
        │   ├── network.tf
        │   ├── network_vpc_flow_logs.tf
        │   ├── outputs.tf
        │   └── variables.tf
        ├── base-tf-backend
        │   ├── config.tf
        │   ├── locals.tf
        │   ├── main.tf
        │   └── variables.tf
        ├── config
        │   ├── account.tfvars
        │   └── backend.tfvars
        ├─── security-base
        |   ├── account.tf
        |   ├── config.tf
        └── variables.tf
    ```
A structure comprised mainly of directories for each account containing all the definitions for each of the accounts respective layers.

!!! info "[:books: Accounts description and purpose.](../how-it-works/organization/accounts/)"

## Architecture orchestration
---
Finally we reach the point in which we'll get to actually create the infrastructure in our AWS environment. Some accounts and layers rely on other accounts/layers being already deployed, creating dependencies between each other and establishing an order in which all layers should be deployed.

The correct deployment order is as shown below.

!!! success "Basic Landing Zone AWS Expenses"
    By default this AWS Reference Architecture configuration should not incur in any costs.

### Management account
---
We begin with the `management` account.
``` bash
cd management
```

#### Terraform backend layer
We move into the `base-tf-backend` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```
!!! info "More information on [`terraform init`](../user-guide/base-workflow/leverage-cli/reference/terraform#init) and [`terraform apply`](../user-guide/base-workflow/leverage-cli/reference/terraform#apply)"
!!! note
    The `apply` command may result in an error similar to:

    ```
    Error: error creating public access block policy for S3 bucket (ex-security-terraform-backend): 
    OperationAborted: A conflicting conditional operation is currently in progress against this resource. 
    Please try again.
    ```

    If this happens, please re-run the command.

Now, to push the local `.tfstate` to the bucket, we uncomment the `backend` section for the `terraform` configuration in `management/base-tf-backend/config.tf`

``` terraform
  backend "s3" {
    key = "management/tf-backend/terraform.tfstate"
  }
```

And run once more:

``` bash
leverage terraform init
```

Now we can safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files created during the `apply` step.

#### Identities layer
Now we move into the `base-identities` directory:

``` bash
leverage terraform init
```

To securely manage the users credentials, all members of the organization that are bound to interact with the AWS environment, and are therefore listed in the `project.yaml` configuration file, should create GPG keys of their own. Then, they should export them and share their public key files with us so we can create their respective IAM users in this step.

!!! info "[:books: How to create and manage GPG keys](../user-guide/identities/gpg/)"

Once we get hold of the keys files we copy them to the `keys` subdirectory, respecting their configured name. In this case we need the keys for `kit.walker` and `natasha.romanoff`.

Finally, we run:

``` bash
leverage terraform apply
```

#### Organizations layer
Next, we move into the `organizations` directory:

``` bash
leverage terraform init
leverage terraform apply
```

The AWS account we created manually is the `management` account itself, so to prevent Terraform from trying to create it and error out, this account definition is commented by default in the code. Now we need to make the Terraform state aware of the link between the two. For that, we uncomment the `management` organizations account resource in `accounts.tf`

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
      email: example-aws@example.com
      id: '000123456789'
...
```

And run:

``` bash
leverage terraform import aws_organizations_account.management 000123456789
```
!!! info "More information on [`terraform import`](../user-guide/base-workflow/leverage-cli/reference/terraform#import)"

#### Security layer
The last layer for the `management` account is the security layer, so we move into the `security-base` directory:

``` bash
leverage terraform init
leverage terraform apply
```

### Security account
---
Before proceeding to deploy any of the remaining accounts we first need to update the credentials for the bootstrap process. This will fetch the organizations structure from the AWS environment and create individual profiles associated with each account for the AWS CLI to use. So we run:

``` bash
leverage credentials update --profile bootstrap --only-accounts-profiles
```
```
[10:24:36.030] INFO     Loading configuration file.
[10:24:40.265] INFO     Configuring accounts' profiles.
[10:24:40.268] INFO     Fetching organization accounts.
[10:24:42.383] INFO     Backing up account profiles file.
[10:24:43.278] INFO     Account profiles configured in: /home/user/.aws/aw/config
[10:24:43.281] INFO     Updating project configuration file.
[10:24:43.345] INFO     Finished updating bootstrap credentials.
```
!!! info "More information on [`credentials update`](../user-guide/base-workflow/leverage-cli/reference/credentials#update)"

Now we can proceed with the `security` account.
``` bash
cd security
```

#### Terraform backend layer
We move into the `base-tf-backend` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```
!!! note
    The `apply` command may result in an error similar to:

    ```
    Error: error creating public access block policy for S3 bucket (ex-security-terraform-backend): 
    OperationAborted: A conflicting conditional operation is currently in progress against this resource. 
    Please try again.
    ```

    If this happens, please re-run the command.

Now, to push the local `.tfstate` to the bucket, we uncomment the `backend` section for the `terraform` configuration in `security/base-tf-backend/config.tf`

``` terraform
  backend "s3" {
    key = "security/tf-backend/terraform.tfstate"
  }
```

And run again:

``` bash
leverage terraform init
```

Now we can safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files created during the `apply` step.

#### Identities layer
Now we move into the `base-identities` directory:

``` bash
leverage terraform init
```

Now we need to copy the keys files for `natasha.romanoff`, `kit.walker`, `edward.stark` and `john.wick` into the `keys` subdirectory.

To prevent Terraform from erroring out we need to import the role `OrganizationAccountAccessRole` that was already created in the `management`'s account identities layer before deploying this layer, so we run:

``` bash
leverage terraform import module.iam_assumable_role_oaar.aws_iam_role.this[0] OrganizationAccountAccessRole
leverage terraform apply
```
!!! info "zsh globbing"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

#### Security layer
The last layer for the `security` account is the security layer, so we move into the `security-base` directory:

``` bash
leverage terraform init
leverage terraform apply
```

### Shared account
---
Our last account in this deployment is the `shared` account.

``` bash
cd shared
```

#### Terraform backend layer
We move into the `base-tf-backend` directory and run:

``` bash
leverage terraform init
leverage terraform apply
```
!!! note
    The `apply` command may result in an error similar to:

    ```
    Error: error creating public access block policy for S3 bucket (ex-security-terraform-backend): 
    OperationAborted: A conflicting conditional operation is currently in progress against this resource. 
    Please try again.
    ```

    If this happens, please re-run the command.

Now, to push the local `.tfstate` to the bucket, we uncomment the `backend` section for the `terraform` configuration in `shared/base-tf-backend/config.tf`

``` terraform
  backend "s3" {
    key = "shared/tf-backend/terraform.tfstate"
  }
```

And run a second time:

``` bash
leverage terraform init
```

Now we can safely remove the `terraform.tfstate` and `terraform.tfstate.backup` files created during the `apply` step.

#### Identities layer
Now we move into the `base-identities` directory:

``` bash
leverage terraform init
```

We also need to import the role `OrganizationAccountAccessRole` in this layer, so we run:

``` bash
leverage terraform import module.iam_assumable_role_oaar.aws_iam_role.this[0] OrganizationAccountAccessRole
leverage terraform apply
```
!!! info "zsh globbing"
    Zsh users may need to prepend `noglob` to the import command for it to be recognized correctly, as an alternative, square brackets can be escaped as `\[\]`

#### Security layer
Next, we move into the `security-base` directory:

``` bash
leverage terraform init
leverage terraform apply
```

#### Network layer
The last layer for the `shared` account is the network layer, so we move into the `base-network` directory:

``` bash
leverage terraform init
leverage terraform apply
```

## Post-deployment steps
---
The whole landing zone is already deployed and with it, all defined users were created. From now on, each user should generate their personal programmatic keys and enable Multi Factor Authentication for their interactions with the AWS environment.

We'll take the place of `natasha.romanoff` to exemplify the process.

### Get the temporary password to access AWS console
When Natasha's user was created, an initial random password was also created alongside it. That password was encrypted using her GPG key, as we already saw previously.

Now we need to access that password so that she can create her programmatic keys to interact with the environment through Leverage.

First, for the `management` account, we change the value `sensitive` to `true` in the output block `user_natasha_romanoff_login_profile_encrypted_password` of `management/base-identities/outputs.tf`:

``` terraform
output "user_natasha_romanoff_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = module.user["natasha.romanoff"].iam_user_login_profile_encrypted_password
  sensitive   = true
}
```

While in the `base-identities` directory, we run:

``` bash
leverage terraform apply
leverage terraform output
```

We extract the value of the password field form the output and [decrypt it](../user-guide/identities/gpg#how-to-manage-your-gpg-keys).

Now we log in the [AWS Console](https://console.aws.amazon.com/) using the `management` account id: `000123456789`, which can be extracted from the `project.yaml` file, our IAM user name: `natasha.romanoff`, and our recently decrypted password. This password should be changed during this procedure.

We proceed to [enable a virtual MFA device for the user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user), and [generate programmatic keys for it](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey). Make sure to not keep these keys in a safe location.

As Natasha also has an IAM user for the `security` account besides the one in `management`, these steps should be repeated for that account, making sure of logging in the AWS console with the proper account id. These are **two different IAM users** in **two different accounts**, so their credentials **are not interchangeable**.

### Configure the new credentials
To be able to use the generated programmatic keys, we need to configure them in our local environment. For that we run:

``` bash
leverage credentials update --profile [management | security] # Choose the correct one
```
```
[12:25:57.502] INFO     Loading configuration file.
[12:25:59.343] INFO     Configuring management credentials.
> Select the means by which you'll provide the programmatic keys: Manually
> Key: AKIAUH0FAB7QVEXAMPLE
> Secret: ****************************************
[12:26:20.566] INFO     Management credentials configured in: /home/user/.aws/ex/credentials
[12:26:24.418] INFO     Configuring accounts' profiles.
[12:26:24.420] INFO     Fetching organization accounts.
[12:26:26.234] INFO     Fetching MFA device serial.
[12:26:28.265] INFO     Backing up account profiles file.
[12:26:28.849] INFO     Account profiles configured in: /home/user/.aws/ex/config
[12:26:28.856] INFO     Updating project configuration file.
[12:26:28.877] INFO     Loading configuration file.
[12:26:28.907] INFO     Finished updating management credentials.
```

!!! note
    Both of these credentials require an MFA device to be enabled. Once of them are configured, the next step ([Enable MFA](#enable-mfa)) becomes mandatory. If the enabling of MFA is not performed any action on the project will be executed using the bootstrap credentials.

### Enable MFA
The last step is to enable Multi Factor Authentication locally. The procedure is slightly different for Natasha's `management` IAM user and `security` IAM user, so we'll walk through both of them.

#### Management user
To enable MFA for a `management` account user, we need to enable this feature individually for the role `OrganizationAccountAccessRole` in all accounts of the infrastructure. So first, we'll take care of the `management` account:

We move into the account's identities layer:

``` bash
cd management/base-identities
```

We change the value for `role_requires_mfa` for the role `iam_assumable_role_oaar` in `roles.tf` to `true`. By default this value is `false`, that is to say, MFA is disabled for the role.

``` terraform
module "iam_assumable_role_oaar" {
  ...
  #
  # MFA setup
  #
  role_requires_mfa    = false -> true
  ...
}
```

And run:

``` bash
leverage terraform apply
```

We now the need to repeat the previous steps for the remaining accounts, in this guide's case, the `security` and `shared` accounts.

Once the change is applied in all layers, we change the value of `profile` in `management/config/backend.tfvars`

``` terraform
#
# Backend Configuration
#

# AWS Profile (required by the backend but also used for other resources)
profile = "ex-bootstrap"
...
```

To `<short project name>-management-oaar`, which in the case of this guide, would result in:

* `ex-bootstrap` --> `ex-management-oaar`

By doing this, we are switching from using the bootstrap credentials, to the management credentials profile for this specific account.

Lastly we set `MFA_ENABLED` in the file `build.env`, located in the project's root directory, to `true`.

#### Security user
To enable MFA for a `security` account user, we have to make changes in all accounts **but `management`**. In the case of this guide, we need to make changes in the `security` account as well as in the `shared` account.

We set `profile` in `config/backend.tfvars` for each account to `<short project name>-<account>-devops`. That is:

* `ex-security-oaar` --> `ex-security-devops` for the `security` account
* `ex-shared-oaar` --> `ex-shared-devops` for the `shared` account

Similarly to the management user's MFA enabling step, we are switching from using bootstrap credentials to the respective profile for each account of the security credentials.

As a last step we need to make sure that `MFA_ENABLED` is set to `true` in the `build.env` file.

## End result
---
Now we have a fully functional deployment of a basic landing zone ready to be used. We have gained an understanding of the structure and functionalities provided by Leverage as well as familiarity with the Leverage workflow.

</br></br>
## Next steps
To learn more about Leverage's inner workings, check out the following links:

- [X] [:books: How it works](../how-it-works/index.md)
- [X] [:books: User Guide](../user-guide/)
