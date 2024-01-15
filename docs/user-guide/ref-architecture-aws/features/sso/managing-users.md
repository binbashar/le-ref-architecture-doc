# Managing users

## Onboarding Users and Groups

### Add/remove users
1. Open this file: `management/global/sso/locals.tf`
2. Locate the users map within the local variables definition
3. Add an entry to the users map with all the required data, including the groups the user should belong to
4. Apply your changes
5. Additional steps are required when creating a new user:
    1. The user's email needs to be verified. Find the steps for that in [this section](#trigger-user-email-activation).
    2. After the user has verified his/her email he/she should be able to use the Forgot Password flow to generate its password. The steps for that can be found in [this section](#reset-a-user-password).

### Add/remove groups
1. Open this file: `management/global/sso/locals.tf`
2. Find the groups variable within the local variables definition
3. Add an entry to the groups variable with the group name and description
4. Apply your changes

### Edit user/group membership
1. Open this file: `devops-tf-infra/management/global/sso/locals.tf`
2. Find the users map within the local variables definition
3. Update the groups attribute to add/remove groups that user belongs to
4. Apply your changes

## Trigger user email activation
1. Log in to management account through the AWS console
2. Go to AWS IAM Identity Center
3. Go to the users section
4. Locate the user whose email you want to active
5. Click on the user to view the user details
6. There should be a "Send verification email" or "Send email verification link" button at the top. Click on it.
7. Notify the user, confirm that he/she got the email and that he/she clicked on the activation link.

## Reset a user password
Follow the steps in the [official documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/resetpassword-accessportal.html)
