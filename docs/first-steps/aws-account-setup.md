# Set Up your AWS Management account

## Create an AWS account
First and foremost you'll need to [create an AWS account](../user-guide/organization/organization-init.md) for your project's deployment. This will become the management account of your [AWS Organization](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_getting-started_concepts.html). During the creation of the AWS account, a user will be created for you, the [root user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html). This user will take the email and password you provided as login credentials and it will be the main access point of your account.<!--(you can see this user represented in the [architecture iagram]())-->

The account's name will be given by your project's name followed by `-management`, since Leverage uses a suffix naming system to differentiate between the multiple accounts of a project. For this guide we'll stick to calling the project `MyExample` and so, the account name will be `myexample-management`. 

Along the same line, we'll use the `example.com` domain for the email address used to register the account. Adding a `-aws` suffix to the project's name to indicate that this email address is related to the project's AWS account, we end up with a registration email that looks like `myexample-aws@example.com`.

!!! info "Email addresses for AWS accounts."
        Each AWS account requires having a unique email address associated to it. The Leverage Reference Architecture for AWS makes use of multiple accounts to better manage the infrastructure, as such, you will need different addresses for each one. Creating a new email account for each AWS is not a really viable solution to this problem, a better approach is to take advantage of mail services that support aliases. For information regarding how this works: [:books: Email setup for your AWS account.](../../user-guide/organization/organization-init/#pre-requisites)

!!! tip
        To protect your project's management account, [enabling Multi Factor Authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html#id_root-user_manage_mfa) is **highly** encouraged, also, reviewing the [account's billing setup](https://console.aws.amazon.com/billing/home?#/account) is always a good idea before proceeding.

## Create an Admin user for the management account
To be able to interact with and manage the AWS environment you will need an IAM user with administrator privileges.

To accomplish this, sign in to the [IAM Console](https://console.aws.amazon.com/iam/) with your recently created account and [create a user](https://docs.aws.amazon.com/mediapackage/latest/ug/setting-up-create-iam-user.html) named `mgmt-org-admin`. Setting a password is not necessary, since you won't use this user to log into the web console. Give it admin privileges by attaching the `AdministratorAccess` policy to it, there's no need to add the user to any group.


## Generate programmatic access keys for the Admin user
Lastly, [generate programmatic access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey) for the `mgmt-org-admin` user, and then either copy them or download the `.csv` file that AWS generates for you. In both cases, store the credentials in a secure location.

!!! info "For more detailed information on setting up your AWS account: [:books: Organization account setup guide](../user-guide/organization/organization-init#user-guide)"

## Next steps
You have successfully created and configured the AWS account for your Leverage project. From now on, almost all interactions with the AWS environment (with few notable exceptions) will be performed via Leverage.

Next, you will setup all required dependencies to work on a Leverage project in your local machine.
