# Post-deployment steps
At this point the landing zone should be almost ready but there are still a few things that need to be changed. For instance, for the sake of simplicity you have been using the bootstrap user for every command. In this section you will make the necessary adjustments to start using your own user.

## Configure SSO settings

### Enable SSO
Let's start by configuring SSO settings. Open this file: `config/common.tfvars` and update the following lines:
```
sso_enabled   = false
sso_start_url = "https://bbleverage.awsapps.com/start"
```

Change `sso_enabled` to `true` as follows to enable SSO support:
```
sso_enabled   = true
```

Now you need to set the `sso_start_url` with the right URL. To find that, navigate here: `https://us-east-1.console.aws.amazon.com/singlesignon/home` -- you should be already logged in to the Management account for this to work. You should see a "Settings summary" panel on the right of the screen that shows the "AWS access portal URL". Copy that and use it to replace the value in the `sso_start_url` entry. Below is an example just for reference:
```
sso_start_url = "https://d-xyz01234567.awsapps.com/start"
```

!!! tip "Customize the AWS access portal URL"
    The 'AWS access portal URL' can be customized to use a more friendly name. Check the [official documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/howtochangeURL.html) for that.


!!! info "Further info on configuring SSO"
    There is more information on how to configure SSO [here](/user-guide/features/sso/sso/#preparing-the-project-to-use-aws-sso).

### Update backend profiles in the management account
It's time to set the right profile names in the backend configuration files. Open this file: `management/config/backend.tfvars` and change the `profile` value from this:
```
profile = "me-bootstrap"
```
To this:
```
profile = "me-management-oaar"
```
Please note that in the examples above my short project name is `me` which is used as a prefix and it's the part that doesn't get replaced.

### Update the backend profile in the security directory
One more files to update. Open `security/config/backend.tfvars` and modify the `profile` value from this:
```
profile = "me-security-oaar"
```
To this:
```
profile = "me-security-devops"
```
Note that in the examples above I only replaced `oaar` for `devops`.

### Update the backend profile in the shared directory
Now open `shared/config/backend.tfvars` and make the same update. For instance, your `profile` value should change from this:
```
profile = "me-shared-oaar"
```
To this:
```
profile = "me-shared-devops"
```

## Activate your SSO user and set up your password
The SSO users you created when you provisioned the SSO layer need to go through an email activation procedure. Find the [instructions here](/user-guide/features/sso/managing-users/#trigger-user-email-activation).

Once SSO user's have been activated, they will need to get their initial password so they are able to log in. Check out the [steps for that here](/user-guide/features/sso/managing-users/#reset-a-user-password).

## Configure the CLI for SSO
Almost there. Let's try the SSO integration now.

### Configure your SSO profiles
Since this is your first time using that you will need to configure it by running this: `leverage aws configure sso`

Follow the wizard to get your AWS config file created for you. There is [more info about that here](/user-guide/features/sso/sso/#1-configuring-aws-sso).

### Verify on a layer in the management account
To ensure that worked, let's run a few commands to verify:

1. We'll use `base-identities` for the purpose of this example
2. Move to the `management/global/base-identities` layer
3. Run: `leverage tf plan`
4. You should get this error: "Error: error configuring S3 Backend: no valid credential sources for S3 Backend found."
5. This happens because so far you have been running Terraform with a different AWS profile (the bootstrap one). Luckily the fix is simple, just run this: `leverage tf init -reconfigure`. Terraform should reconfigure the AWS profile in the `.terraform/terraform.tfstate` file.
6. Now try running that `leverage tf plan` command again
7. This time it should succeed.
8. Unfortunately, since through this guide we have deployed all the layers with the bootstrap profile you will face the same issue on every layer and thus you will have to repeat steps 5 and 6 to fix it.

### Verify on a layer in a non-management account
The previous steps provided you with the knowledge to move on with the rest of layers but, just to be sure, let's try on a layer of a non-management account:

1. Switch to the `security/global/base-identities` directory
2. Run: `leverage tf init -reconfigure`
3. And then run: `leverage tf plan`
4. If that works, that should validate your credentials have been configured successfully.

That's it! You are ready to roll on your own now! :raised_hand:

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
Now you not only have a fully functional landing zone configuration deployed, but also are able to interact with it using your own AWS SSO credentials.

For more detailed information, visit the links below.

- [X] :books: [How it works](../how-it-works/ref-architecture/index.md)
- [X] :books: [User guides](../user-guide/index.md)
