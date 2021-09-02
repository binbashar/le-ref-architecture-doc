# Post-deployment steps

The whole landing zone is already deployed, and with it, all defined users were created. From now on, each user should generate their personal programmatic keys and enable Multi Factor Authentication for their interactions with the AWS environment. Let's take a look at the steps required to accomplish this.

## Get the temporary password to access AWS console

We'll take the place of `natasha.romanoff` to exemplify the process.

When Natasha's user was created, an initial random password was also created alongside it. That password was encrypted using her GPG key, as it was shown in the [management account's](../first-steps/management-account/#identities-layer) and in the [security account's](../first-steps/security-and-shared-accounts/#identities-layer) identities layers.

As Natasha, you need to access that password so that you can create your programmatic keys to interact with the environment through Leverage.

First, for the `management` account, change the value `sensitive` to `true` in the output block `user_natasha_romanoff_login_profile_encrypted_password` of `management/base-identities/outputs.tf`:

``` terraform
output "user_natasha_romanoff_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = module.user["natasha.romanoff"].iam_user_login_profile_encrypted_password
  sensitive   = true
}
```

Then, in the `base-identities` directory, run:

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

Extract the value of the password field form the output and [decrypt it](../user-guide/identities/gpg#how-to-manage-your-gpg-keys).

Now, log in the [AWS Console](https://console.aws.amazon.com/) using the `management` account id: `000123456789`, which can be extracted from the `project.yaml` file, your IAM user name: `natasha.romanoff`, and your recently decrypted password. This password should be changed during this procedure.

Proceed to [enable a virtual MFA device for your user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user), and [generate programmatic keys for it](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey). Make sure to keep these keys in a safe location.

As Natasha also has an IAM user for the `security` account besides the one in `management`, these steps should be repeated for that account, making sure of logging in the AWS console with the proper account id. Keep in mind that these are **two different IAM users** in **two different accounts**, so their credentials **are not interchangeable**.

## Configure the new credentials

To be able to use the generated programmatic keys, you need to configure them in your local environment. To do that, run:

``` bash
leverage credentials update --profile management # or `security` depending on the credentials to configured
```
<pre><code><span style="color:grey;">[12:25:57.502]</span> INFO     Loading configuration file.
<span style="color:grey;">[12:25:59.343]</span> INFO     Configuring <b>management</b> credentials.
<span style="color:mediumseagreen;">></span> <b>Select the means by which you'll provide the programmatic keys: <span style="color:cornflowerblue;">Manually</span></b>
<span style="color:mediumseagreen;">></span> <b>Key: <span style="color:cornflowerblue;">AKIAUH0FAB7QVEXAMPLE</span></b>
<span style="color:mediumseagreen;">></span> <b>Secret: <span style="color:cornflowerblue;">****************************************</span></b>
<span style="color:grey;">[12:26:20.566]</span> INFO     <b>Management credentials configured in:</b> /home/user/.aws/ex/credentials
<span style="color:grey;">[12:26:24.418]</span> INFO     Configuring accounts' profiles.
<span style="color:grey;">[12:26:24.420]</span> INFO     Fetching organization accounts.
<span style="color:grey;">[12:26:26.234]</span> INFO     Fetching MFA device serial.
<span style="color:grey;">[12:26:28.265]</span> INFO     Backing up account profiles file.
<span style="color:grey;">[12:26:28.849]</span> INFO     <b>Account profiles configured in:</b> /home/user/.aws/ex/config
<span style="color:grey;">[12:26:28.856]</span> INFO     Updating project configuration file.
<span style="color:grey;">[12:26:28.877]</span> INFO     Loading configuration file.
<span style="color:grey;">[12:26:28.907]</span> INFO     Finished updating <b>management</b> credentials.
</code></pre>

!!! note
    Both of these credentials (management and security) require an MFA device to be enabled. Once either credential is configured, the next step ([Enable MFA](#enable-mfa)) becomes mandatory. If MFA is not enabled, any action on the project will be executed using the bootstrap credentials.

## Enable MFA

The last step is to enable Multi Factor Authentication locally. The procedure is slightly different for a `management` IAM user and `security` IAM user, so we'll walk through both of them.

### Management user

To enable MFA for a `management` account user, you need to enable this feature individually for the role `OrganizationAccountAccessRole` in all accounts of the infrastructure. So first, we'll take care of the `management` account:

Move into the account's identities layer:

``` bash
cd management/base-identities
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

- [X] :books: [How it works](../how-it-works/index.md)
- [X] :books: [User guides](../user-guide/index.md)
