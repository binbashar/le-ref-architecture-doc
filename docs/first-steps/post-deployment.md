# Post-deployment steps

The whole landing zone is already deployed, and with it, all defined users were created. From now on, each user should generate their personal programmatic keys and enable Multi Factor Authentication for their interactions with the AWS environment. Let's take a look at the steps required to accomplish this.

## Get the temporary password to access AWS console

We'll take the place of `natasha.romanoff` to exemplify the process.

When Natasha's user was created, an initial random password was also created alongside it. That password was encrypted using her GPG key, as it was shown in the [management account's](../management-account/#identities-layer) and in the [security account's](../security-and-shared-accounts/#identities-layer) identities layers.

As Natasha, you need to access that password so that you can create your programmatic keys to interact with the environment through Leverage.

First, for the `management` account, check that the value `sensitive` is set to `true` in the output block `user_natasha_romanoff_login_profile_encrypted_password` of `management/global/base-identities/outputs.tf`:

``` terraform
output "user_natasha_romanoff_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = module.user["natasha.romanoff"].iam_user_login_profile_encrypted_password
  sensitive   = true
}
```

Then, in the `global/base-identities` directory, run the output command with the `-json` flag:

``` bash
leverage terraform output -json
```
```
...
"user_natasha_romanoff_name": {
  "sensitive": false,
  "type": "string",
  "value": "natasha.romanoff"
},
"user_natasha_romanoff_login_profile_encrypted_password": {
  "sensitive": true,
  "type": "string",
  "value": "wcDMAyRZJTaxw5v1AQwAy6c...............2mBIbNFxF1Tp/ilvyk8eEHvAA="
}
...
```

Extract the value of the password field form the output and [decrypt it](../../user-guide/features/identities/gpg#how-to-manage-your-gpg-keys).

Now, log in the [AWS Console](https://console.aws.amazon.com/) using the `management` account id: `000123456789`, which can be extracted from the `project.yaml` or `config/common.tfvars` files, your IAM user name: `natasha.romanoff`, and your recently decrypted password. This password should be changed during this procedure.

Proceed to [enable a virtual MFA device for your user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user), and [generate programmatic keys for it](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey). Make sure to keep these keys in a safe location.

As Natasha also has an IAM user for the `security` account besides the one in `management`, these steps should be repeated for that account, making sure of logging in the AWS console with the proper account id. Keep in mind that these are **two different IAM users** in **two different accounts**, so their credentials **are not interchangeable**.

## Configure the new credentials

To be able to use the generated programmatic keys, you need to configure them in your local environment. To do that, run:

``` bash
leverage credentials configure --type MANAGEMENT # or `SECURITY` depending on the credentials to be configured
```
<pre><code><span class="fsg-timestamp">[12:28:12.111]</span> INFO     Loading configuration file.
<span class="fsg-timestamp">[12:28:12.132]</span> INFO     Loading project environment configuration file.
<span class="fsg-timestamp">[12:28:12.139]</span> INFO     Loading Terraform common configuration.
<span class="fsg-timestamp">[12:28:13.237]</span> INFO     Configuring management credentials.
<span class="fsg-prompt">></span> <b>Select the means by which you'll provide the programmatic keys: <span class="fsg-userinput">Manually</span></b>
<span class="fsg-prompt">></span> <b>Key: <span class="fsg-userinput">AKIAUH0FAB7QVEXAMPLE</span></b>
<span class="fsg-prompt">></span> <b>Secret: <span class="fsg-userinput">****************************************</span></b>
<span class="fsg-timestamp">[12:28:30.739]</span> INFO     <b>Management credentials configured in:</b> <span class="fsg-path">/home/user/.aws/me/credentials</span>
<span class="fsg-timestamp">[12:28:34.991]</span> INFO     Configuring assumable roles.
<span class="fsg-timestamp">[12:28:39.299]</span> INFO     Backing up account profiles file.
<span class="fsg-timestamp">[12:28:39.941]</span> INFO             Configuring profile <b>me-management-oaar</b>
<span class="fsg-timestamp">[12:28:45.205]</span> INFO             Configuring profile <b>me-security-oaar</b>
<span class="fsg-timestamp">[12:28:50.526]</span> INFO             Configuring profile <b>me-shared-oaar</b>
<span class="fsg-timestamp">[12:28:55.953]</span> INFO     <b>Account profiles configured in:</b> <span class="fsg-path">/home/user/.aws/me/config</span>
<span class="fsg-timestamp">[12:28:55.956]</span> INFO     Updating project's Terraform common configuration.
</code></pre>

!!! note
    Both of these credentials (management and security) require an MFA device to be enabled. Once either credential is configured, the next step ([Enable MFA](#enable-mfa)) becomes mandatory. If MFA is not enabled, any action on the project will be executed using the bootstrap credentials.

!!! note
    If a layer was already set with BOOTSTRAP credentials, when changing the credential type Terraform has to be reconfigured: `leverage tf init -reconfigure`.

## Enable MFA

The last step is to enable Multi Factor Authentication locally. The procedure is slightly different for a `management` IAM user and `security` IAM user, so we'll walk through both of them.

### Management user

To enable MFA for a `management` account user, you need to enable this feature individually for the role `OrganizationAccountAccessRole` in all accounts of the infrastructure. So first, we'll take care of the `management` account:

Move into the account's identities layer:

``` bash
cd management/global/base-identities
```

Change the value `role_requires_mfa` for the role `iam_assumable_role_oaar` in `roles.tf` to `true`. By default this value is `false`, that is to say, MFA is disabled for the role.

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

You now should repeat these steps for the remaining accounts, in this guide's case, the `security` and `shared` accounts.

Once the change is applied in all layers, change the value of `profile` in `management/config/backend.tfvars`

``` terraform
#
# Backend Configuration
#

# AWS Profile (required by the backend but also used for other resources)
profile = "me-bootstrap"
...
```

To `<short project name>-management-oaar`, which in the case of this guide, would result in:

* `me-bootstrap` --> `me-management-oaar`

By doing this, you are effectively switching from using the bootstrap credentials to the management credentials profile for this specific account.

Lastly, set `MFA_ENABLED` in the file `build.env`, located in the project's root directory, to `true`.

### Security user

To enable MFA for a `security` account user, the procedure is simpler but it has to be performed in all accounts **but `management`**. In the case of this guide, you need to make changes in the `security` account as well as in the `shared` account.

Set `profile` in `config/backend.tfvars` for each account to `<short project name>-<account>-devops`. That is:

* `me-security-oaar` --> `me-security-devops` for the `security` account
* `me-shared-oaar` --> `me-shared-devops` for the `shared` account

Similarly to the management user's MFA enabling step, you are switching from using bootstrap credentials to the respective profile for each account of the security credentials.

As a last step you need to make sure that `MFA_ENABLED` is set to `true` in the `build.env` file.

## Re-Configure profiles  MFA

For everything to work as expected, you need to set the aws configuration profiles to the corresponding mfa-device configuration.

Then run `leverage credentials configure` again with the `--fetch-mfa-device` flag and select the `skip credentials configuration` option.

As an alternative, the flag [--skip-access-keys-setup](https://leverage.binbash.com.ar/user-guide/leverage-cli/reference/credentials/#options) could be used to avoid the interactive step.

``` bash
leverage credentials configure --fetch-mfa-device --type MANAGEMENT
leverage credentials configure --fetch-mfa-device --type SECURITY
```
<pre><code>
<span class="fsg-timestamp">[10:10:11.033]</span> INFO     Loading configuration file.
<span class="fsg-timestamp">[10:10:11.092]</span> INFO     Loading project environment configuration file.
<span class="fsg-timestamp">[10:10:11.093]</span> INFO     Loading Terraform common configuration.
<span class="fsg-prompt">></span> <b> Credentials already configured for ld-management: <span class="fsg-userinput">Skip credentials configuration. Continue on with assumable roles setup.</span></b>
<span class="fsg-timestamp">[10:10:30.345]</span> INFO     Attempting to fetch organization accounts.
<span class="fsg-timestamp">[10:10:33.928]</span> INFO     Configuring assumable roles.
<span class="fsg-timestamp">[10:10:33.932]</span> INFO     <b>Fetching MFA device serial.</b>
<span class="fsg-timestamp">[10:10:37.473]</span> INFO     Backing up account profiles file.
<span class="fsg-timestamp">[10:10:38.913]</span> INFO             Configuring profile <b>me-management-oaar</b>
<span class="fsg-timestamp">[10:10:53.088]</span> INFO             Configuring profile <b>me-security-oaar</b>
<span class="fsg-timestamp">[10:11:08.229]</span> INFO             Configuring profile <b>me-shared-oaar</b>
<span class="fsg-timestamp">[10:11:23.185]</span> INFO     <b>Account profiles configured in:</b> <span class="fsg-path">/home/user/.aws/me/config</span>
</code></pre>

!!! note
    If a layer was already set with BOOTSTRAP credentials, when changing the credential type Terraform has to be reconfigured: `leverage tf init -reconfigure`.


## Add New AWS Accounts

If  necessary you can easily add new AWS accounts to your Leverage project by following these steps.

For this example `apps-prd` will be created.

#### Create the account in your Organization

1. Go to `management/global/organizations`.

2. Edit the `locals.tf` file to add the account to the local `accounts` variable.
    ```yaml
        accounts = {

        [...]

            apps-prd = {
            email     = "aws+apps-prd@yourcompany.com",
            parent_ou = "apps"
            }
        }
    ```

    Note `apps` organizational unit (OU) is being used as parent OU. If a new OU has to be used here, it has to be created be adding it to `organizational_units` structure in the same file.

3. Run the [Terraform workflow](https://leverage.binbash.com.ar/user-guide/ref-architecture-aws/workflow/) to apply the new changes.

    Basically:

    ```shell
    leverage terraform apply
    ```

4. Add the new account to the `config/common.tfvars` file.

    The new account ID should be got from the previous step.

    Using it update the file:

    ```shell
        accounts = {

        [...]

            apps-prd = {
                email = "aws+apps-prd@yourcompany.com",
                id    = "<here-the-account-id>"
            }
        }
    ```

5. If SSO is being used in this project.

    Permissions for SSO access have to be granted before we can step forward.

    Add the right permissions in file `management/global/sso/account_assignments.tf`.

    For the example:

    ```yaml
        {
          account             = var.accounts.apps-prd.id,
          permission_set_arn  = module.permission_sets.permission_sets["Administrator"].arn,
          permission_set_name = "Administrator",
          principal_type      = "GROUP",
          principal_name      = "AWS_Administrators"
        },

        {
          account             = var.accounts.apps-prd.id,
          permission_set_arn  = module.permission_sets.permission_sets["DevOps"].arn,
          permission_set_name = "DevOps",
          principal_type      = "GROUP",
          principal_name      = "AWS_DevOps"
        },

        {
          account             = var.accounts.apps-prd.id,
          permission_set_arn  = module.permission_sets.permission_sets["Developer_FullAccess"].arn,
          permission_set_name = "Developer_FullAccess",
          principal_type      = "GROUP",
          principal_name      = "AWS_Developers"
        },

    ```

    Note that your needs can vary, and these permissions are just an example. Please be careful with what you are granting here.

    Apply changes:
    ```shell
    leverage terraform apply
    ```

    Now you need to get the new permissions locally:

    ```shell
    leverage aws configure sso
    ```

From here, to make sure it integrates correctly, you will most likely want to create the initial directory structure for this new account, *as explained below*.

#### Create the initial directory structure for a new account

  For this example, we will set up the `apps-prd` account by using the `apps-devstg` as a template:

1. Ensure you are at the root of this repository

2. Create the initial directory structure for the new account:

    ```
    mkdir -p apps-prd/{global,us-east-1}
    ```

3. Set up the config files:

    1. Create the config files for this account: `cp -r apps-devstg/config apps-prd/config`

    2. Open `apps-prd/config/backend.tfvars` and replace any occurrences of `devstg` with `prd`.

        (basically, `apps-devstg` is being replaced with the new name `apps-prd`)


    3. Do the same with `apps-prd/config/account.tfvars`

    4. If **no SSO** is implemented in the project (i.e. OAAR is being used):

        1. Open up `apps-prd/config/backend.tfvars` again and replace this:
            ```
            profile = "bb-apps-prd-devops"
            ```
            with this:
            ```
            profile = "bb-apps-prd-oaar"
            ```

        2. In the step above, we are switching to the OAAR (OrganizationalAccountAccessRole) role because we are working with a brand new account that is empty, so, the only way to access it programmatically is through the OAAR role.

        3. Now it's time to configure your OAAR credentials (if haven't already done so). For that you can follow the steps in [this section](https://leverage.binbash.com.ar/first-steps/management-account/#update-the-bootstrap-credentials) of the official documentation.

4. Create the `base-tf-backend` layer:

    1. Copy the layer from an existing one:

        From the repository root run:
        ```shell
        cp -r apps-devstg/us-east-1/base-tf-backend apps-prd/us-east-1/base-tf-backend
        ```

        !!! info
            If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory.

    2. Go to the `apps-prd/us-east-1/base-tf-backend` directory and open the `config.tf` file and comment the the S3 backend block:

        E.g.:
        ```
        #backend "s3" {
        #    key = "apps-devstg/tf-backend/terraform.tfstate"
        #}
        ```

    3. Now run the [Terraform workflow](https://leverage.binbash.com.ar/user-guide/ref-architecture-aws/workflow/) to initialize and apply this layer.

        The flag `--skip-validation` is needed here since the bucket does not yet exist.

        ```shell
        leverage terraform init --skip-validation
        leverage terraform apply
        ```

    4. Open the `config.tf` file again uncommenting the block commented before and replacing `devstg` with `prd`:

        E.g.:
        ```
        backend "s3" {
            key = "apps-prd/tf-backend/terraform.tfstate"
        }
        ```

    5. To finish with the backend layer, re-init to move the `tfstate` to the new location.

        Run:
        ```shell
        leverage terraform init
        ```

        Terraform will detect that you are trying to move from a local to a remote state and will ask for confirmation.

        ```shell
        Initializing the backend...
        Acquiring state lock. This may take a few moments...
        Do you want to copy existing state to the new backend?
          Pre-existing state was found while migrating the previous "local" backend to the
          newly configured "s3" backend. No existing state was found in the newly
          configured "s3" backend. Do you want to copy this state to the new "s3"
          backend? Enter "yes" to copy and "no" to start with an empty state.

          Enter a value:

        ```

        Enter `yes` and hit enter.

5. Create the `base-identities` layer:

    1. Copy the layer from an existing one:

        From the repository root run:
        ```shel
        cp -r apps-devstg/global/base-identities apps-prd/global/base-identities`
        ```

        !!! info
            If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory.

    2. Go to the `apps-prd/global/base-identities` directory and open the `config.tf` file. Replace any occurrences of `devstg` with `prd`

        E.g. this line should be:
        ```yaml
        backend "s3" {
          key = "apps-prd/identities/terraform.tfstate"
        }
        ```

    3. Init the layer

        ```shell
        leverage terraform init
        ```

    4. Import the OAAR role

        Run this command:
        ```shell
        leverage terraform import module.iam_assumable_role_oaar.aws_iam_role.this OrganizationAccountAccessRole
        ```

    5. Finally apply the layer

        ```shell
        leverage terraform apply
        ```

6. Create the `security-base` layer:

    1. Copy the layer from an existing one:

        From the repository root run:
        ```shell
        cp -r apps-devstg/us-east-1/security-base apps-prd/us-east-1/security-base
        ```

        !!! info
            If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory.

    2. Go to the `apps-prd/us-east-1/security-base` directory and open the `config.tf` file replacing any occurrences of `devstg` with `prd`

        E.g. this line should be:
        ```yaml
        backend "s3" {
          key = "apps-prd/security-base/terraform.tfstate"
        }
        ```

    3. Init and apply the layer

        ```shell
        leverage tf init
        leverage tf apply
        ```

7. If no SSO is implemented in the project (i.e. OAAR is being used), switch back from OAAR to DevOps role.

    1. Open up `apps-prd/config/backend.tfvars`

        Replace this:
        ```yaml
        profile = "bb-apps-prd-oaar"
        ```

        with this:

        ```yaml
        profile = "bb-apps-prd-devops"
        ```

        !!! info
            This is needed because we only want to use the OAAR role for exceptional cases, not on a daily basis.

    2. Now, let's configure your DevOps credentials (if you haven't already done so).

        1. Log into your security account, create programmatic access keys, and enable MFA.

        2. Then run: `leverage credentials configure --fetch-mfa-device --type SECURITY`

        3. The command above should prompt for your programmatic keys and, with those, Leverage should be able to configure your AWS config and credentials files appropriately.

8.  That should be it. At this point you should have the following:

    1. A brand-new AWS account.

    2. Configuration files that are needed for any layer that is created under this account.

    3. A Terraform State Backend for this new account.

    4. Roles and policies (base identities) that are necessary to access the new account.


## Next steps

Now you not only have a fully functional landing zone configuration deployed, but also the users to interact with it are correctly configured in both the AWS and local environment.

This concludes this first steps guide for the Leverage Reference Architecture for AWS. For more detailed information, visit the links below.

- [X] :books: [How it works](../how-it-works/ref-architecture/index.md)
- [X] :books: [User guides](../user-guide/index.md)
