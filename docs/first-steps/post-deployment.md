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

## Next steps
Now you not only have a fully functional landing zone configuration deployed, but also are able to interact with it using your own AWS SSO credentials.

For more detailed information, visit the links below.

- [X] :books: [How it works](../how-it-works/ref-architecture/index.md)
- [X] :books: [User guides](../user-guide/index.md)
