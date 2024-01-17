# Creating your AWS Management account

## Create the first AWS account
First and foremost you'll need to [create an AWS account](/user-guide/ref-architecture-aws/features/organization/configuration/) for your project (note your management account should be called `<project-name>-management`). This will be the management account of your [AWS Organization](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_getting-started_concepts.html) and the email address you use for signing up will be the [root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html) of this account -- you can see this user represented in the [architecture diagram](../#leverage-landing-zone).

Since the root user is the main access point to your account it is strongly recommended that you keep its credentials (email, password) safe by following [AWS best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html).

!!! tip
        To protect your management account, [enabling Multi Factor Authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html#id_root-user_manage_mfa) is **highly** encouraged. Also, reviewing the [account's billing setup](https://console.aws.amazon.com/billing/home?#/account) is always a good idea before proceeding.

!!! info "For more details on setting up your AWS account: [:books: Organization account setup guide](/user-guide/ref-architecture-aws/features/organization/configuration/)"

## Create a bootstrap user with temporary administrator permissions
Leverage needs a user with temporary administrator permissions in order to deploy the initial resources that will form the foundations you will then use to keep building on. That initial deployment is called the bootstrap process and thus the user required for that is called "the bootstrap user".

To create that user, navigate to the [IAM page](https://console.aws.amazon.com/iam/) and create a user named `mgmt-org-admin` [following steps 2 and 3 of this leverage doc](/user-guide/ref-architecture-aws/features/organization/configuration/#reference-aws-organization-init-workflow).

!!! info
        Bear in mind that the page for creating users may change from time to time but the key settings for configuring the bootstrap user are the following:

        * It must be an IAM user (we won't be using IAM Identity Center for this)
        * Password can be auto-generated
        * It requires admin privileges which you can achieve by directly attaching the `AdministratorAccess` policy to it
        * There's no need to add the user to any group as it is only a temporary user

Usually the last step of the user creation should present you the following information:

- Console sign-in URL
- User name
- Console password

Make a note of all of these and keep them in a safe place as you will need them in the following steps.

!!! info
        If you are only getting the bootstrap user credentials for someone else in your team or
        in Binbash's team, then please share that using a secure way (e.g. password management
        service, GPG keys, etc).

!!! info
        If user was set up with the option "Force to change password on first login", you should log into the console to do so.

## Next steps
You have successfully created and configured the AWS account for your Leverage project. From now on, almost all interactions with the AWS environment (with few notable exceptions) will be performed via Leverage.

Next, you will setup all required dependencies to work on a Leverage project in your local machine.
