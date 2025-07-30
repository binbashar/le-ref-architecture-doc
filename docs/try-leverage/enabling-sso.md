# Configure SSO settings

## Enable SSO
Let's start by configuring SSO settings. Open this file: `<your_project>/config/common.tfvars` and update the following lines:
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
    There is more information on how to configure SSO [here](/user-guide/ref-architecture-aws/features/sso/configuration/#preparing-the-project-to-use-aws-sso).

## Update backend profiles in the management account
It's time to set the right profile names in the backend configuration files. Open this file: `management/config/backend.tfvars` and change the `profile` value from this:
```
profile = "me-bootstrap"
```
To this:
```
profile = "me-management-oaar"
```
Please note that in the examples above my short project name is `me` which is used as a prefix and it's the part that doesn't get replaced.

## Activate your SSO user and set up your password
The SSO users you created when you provisioned the SSO layer need to go through an email activation procedure.

The user is the one you set in the `project.yaml` file at the beginning, in this snippet:

```yaml
users:
- first_name: the-name
  last_name: the-last-name
  email: user@domain.co
  groups:
  - administrators
  - devops
```

To activate the user find the [instructions here](/user-guide/ref-architecture-aws/features/sso/managing-users/#trigger-user-email-activation).

Once SSO user's have been activated, they will need to get their initial password so they are able to log in. Check out the [steps for that here](/user-guide/ref-architecture-aws/features/sso/managing-users/#reset-a-user-password).

Basically:

- Log into your `sso_start_url` address
- Ingress your username (the user email)
- Under Password, choose Forgot password.
- Type in the code shown in the screen
- A reset password email will be sent
- Follow the link and reset your password
- Now, in the same URL as before, log in with the new credentials
- You will be prompted to create an MFA, just do it.

## Configure the CLI for SSO
Almost there. Let's try the SSO integration now.

### Configure your SSO profiles
Since this is your first time using that you will need to configure it by running this: 

```bash
leverage aws configure sso
```

Follow the wizard to get your AWS config file created for you. There is [more info about that here](/user-guide/ref-architecture-aws/features/sso/configuration/#authentication-via-sso).

### Verify on a layer in the management account
To ensure that worked, let's run a few commands to verify:

1. We'll use `sso` for the purpose of this example
2. Move to the `management/global/sso` layer
3. Run: `leverage tf plan`
4. You should get this error: "Error: error configuring S3 Backend: no valid credential sources for S3 Backend found."
5. This happens because so far you have been running OpenTofu with a different AWS profile (the bootstrap one). Luckily the fix is simple, just run this: `leverage tf init -reconfigure`. Terraform should reconfigure the AWS profile in the `.terraform/terraform.tfstate` file.
6. Now try running that `leverage tf plan` command again
7. This time it should succeed, you should see the message: `No changes. Your infrastructure matches the configuration.`

**Note** if you still have the same error, try clearing credentials with:

```bash
leverage aws sso logout && leverage aws sso login
```


## Next steps
You successfully enabled SSO.

Next, you will orchestrate the remaining accounts, `security` and `shared`.

