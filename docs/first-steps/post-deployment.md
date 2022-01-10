# Post-deployment steps

The whole landing zone is already deployed, and with it, all defined users were created. From now on, each user should generate their personal programmatic keys and enable Multi Factor Authentication for their interactions with the AWS environment. Let's take a look at the steps required to accomplish this.

## Get the temporary password to access AWS console

We'll take the place of `natasha.romanoff` to exemplify the process.

When Natasha's user was created, an initial random password was also created alongside it. That password was encrypted using her GPG key, as it was shown in the [management account's](../management-account/#identities-layer) and in the [security account's](../security-and-shared-accounts/#identities-layer) identities layers.

As Natasha, you need to access that password so that you can create your programmatic keys to interact with the environment through Leverage.

First, for the `management` account, change the value `sensitive` to `true` in the output block `user_natasha_romanoff_login_profile_encrypted_password` of `management/global/base-identities/outputs.tf`:

``` terraform
output "user_natasha_romanoff_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = module.user["natasha.romanoff"].iam_user_login_profile_encrypted_password
  sensitive   = true
}
```

Then, in the `global/base-identities` directory, run:

``` bash
leverage terraform apply
leverage terraform output
```
```
...
user_natasha_romanoff_login_profile_encrypted_password = "SipVOzVtNTI0Ml...EZmJFxxQSteYQ=="
user_natasha_romanoff_name = "natasha.romanoff"
...
```

Extract the value of the password field form the output and [decrypt it](../../user-guide/features/identities/gpg#how-to-manage-your-gpg-keys).

Now, log in the [AWS Console](https://console.aws.amazon.com/) using the `management` account id: `000123456789`, which can be extracted from the `project.yaml` or `config/common.tfvars` files, your IAM user name: `natasha.romanoff`, and your recently decrypted password. This password should be changed during this procedure.

Proceed to [enable a virtual MFA device for your user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user), and [generate programmatic keys for it](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey). Make sure to keep these keys in a safe location.

As Natasha also has an IAM user for the `security` account besides the one in `management`, these steps should be repeated for that account, making sure of logging in the AWS console with the proper account id. Keep in mind that these are **two different IAM users** in **two different accounts**, so their credentials **are not interchangeable**.

## Configure the new credentials

To be able to use the generated programmatic keys, you need to configure them in your local environment. To do that, run:

``` bash
leverage credentials configure --type MANAGEMENT # or `SECURITY` depending on the credentials to configured
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
<span class="fsg-timestamp">[12:28:34.993]</span> INFO     Fetching organization accounts.
<span class="fsg-timestamp">[12:28:37.060]</span> INFO     Fetching MFA device serial.
<span class="fsg-timestamp">[12:28:39.299]</span> INFO     Backing up account profiles file.
<span class="fsg-timestamp">[12:28:39.941]</span> INFO             Configuring profile <b>me-management-oaar</b>
<span class="fsg-timestamp">[12:28:45.205]</span> INFO             Configuring profile <b>me-security-oaar</b>
<span class="fsg-timestamp">[12:28:50.526]</span> INFO             Configuring profile <b>me-shared-oaar</b>
<span class="fsg-timestamp">[12:28:55.953]</span> INFO     <b>Account profiles configured in:</b> <span class="fsg-path">/home/user/.aws/me/config</span>
<span class="fsg-timestamp">[12:28:55.956]</span> INFO     Updating project's Terraform common configuration.
</code></pre>

!!! note
    Both of these credentials (management and security) require an MFA device to be enabled. Once either credential is configured, the next step ([Enable MFA](#enable-mfa)) becomes mandatory. If MFA is not enabled, any action on the project will be executed using the bootstrap credentials.

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

## Next steps

Now you not only have a fully functional landing zone configuration deployed, but also the users to interact with it are correctly configured in both the AWS and local environment.

This concludes this first steps guide for the Leverage Reference Architecture for AWS. For more detailed information, visit the links below.

- [X] :books: [How it works](../how-it-works/ref-architecture/index.md)
- [X] :books: [User guides](../user-guide/index.md)
