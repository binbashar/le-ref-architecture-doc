# Troubleshooting credentials issues

!!! info "Make sure you read [general troubleshooting](../general) page before trying out anything else."

## Are you using IAM or SSO?
Leverage supports two methods for getting AWS credentials: IAM and SSO. We are progressively favoring SSO over IAM, only using the latter as a fallback option.

SSO is enabled through the [common.tfvars](https://github.com/binbashar/le-tf-infra-aws/blob/master/config/common.tfvars.example) file on this line:
```
sso_enabled   = true
```
If that is set to true, then you are using SSO, otherwise it's IAM.

## Why should I care whether I am using IAM or SSO?
Well, because even though both methods will try to get temporary AWS credentials, each method will use a different way to do that. In fact, Leverage relies on the AWS CLI to get the credentials and each method requires completely different commands to achieve that.

## Do you have MFA enabled?
MFA is optionally used via the IAM method. It can be enabled/disabled in the [build.env](https://github.com/binbashar/le-tf-infra-aws/blob/master/build.env) file.

!!! info "Keep in mind that MFA should only be used with the IAM method, not with SSO."

## Identify which credentials are failing
Since Leverage actually relies on Terraform and, since most of the definitions are AWS resources, it is likely that you are having issues with the Terraform AWS provider, in other words, you might be struggling with AWS credentials. Now, bear in mind that Leverage can also be used with other providers such as Gitlab, Github, Hashicorp Cloud Platform, or even SSH via Ansible; so the point here is to understand what credentials are not working for you in order to focus the troubleshooting on the right suspect.

## Determine the AWS profile you are using
When you are facing AWS credentials issues it's important to understand what is the AWS profile that might be causing the issue. [Enabling verbose mode](../general/#gathering-more-information) should help with that. The suspect profile is likely to show right above the error line and, once you have identified that, you can skip to the next section.

If the above doesn't make the error evident yet, perhaps you can explore the following questions:

1. Is it a problem with the Terraform remote state backend? The profile used for that is typically defined in the backend.tfvars file, e.g. [this one](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/config/backend.tfvars#L6), or [this other one](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/backend.tfvars).
2. Is it a problem with another profile used by the layer? Keep in mind that layers can have multiple profile definitions in order to be able to access resources in different accounts. For instance, this is a [simple provider definition that uses a single profile](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/security-base/config.tf#L4-L7), but here's [a more complex definition with multiple provider blocks](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/base-network/config.tf#L1-L43).
3. Can the problematic profile be found in the AWS config file? Or is the profile entry in the AWS config file properly defined? Read the next sections for more details on that.

## Check the profiles in your AWS config file
Once you know what AWS profile is giving you headaches, you can open the AWS config file, typically under `~/.aws/[project_name_here]/config`, to look for and inspect that profile definition.

Things to look out for:

- Is there a profile entry in that file that matches the suspect profile?
- Are there repeated profile entries?
- Does the profile entry include all necessary fields (e.g. region, role_arn, source_profile; mfa_serial if MFA is enabled)?
- Keep in mind that profiles change depending on if you are using SSO or IAM for getting credentials so please refer to the corresponding section below in this page to find specific details about your case.

## Configure the AWS CLI for Leverage
These instructions can be used when you need to test your profiles with the AWS CLI, either to verify the profiles are properly set up or to validate the right permissions were granted.

Since Leverage stores the AWS config and credentials file under a non-default path, when using the AWS CLI you'll need to point it to the right locations:
```
export AWS_CONFIG_FILE=~/.aws/[project_name_here]/config
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/[project_name_here]/credentials
```

!!! info "Get shell access to the Leverage Toolbox Docker Image"
    Another alternative, if you can't or don't want to install the AWS CLI on your machine, is to use the one included in the Leverage Toolbox Docker image. You can access it by running `leverage tf shell`

## Test the failing profile with the AWS CLI
Once you have narrowed down your investigation to a profile what you can do is test it.
For instance, let's assume that the suspect profile is `le-shared-devops`. You can run this command: `aws sts get-caller-identity --profile le-shared-devops` in order to mimic the way that AWS credentials are generated in order to be used by Terraform, so if that command succeeds then that's a good sign.

Note: if you use the AWS CLI installed in your host machine, you will need to configure the environment variables in the section "Configure the AWS CLI for Leverage" below.

!!! info "AWS CLI Error Messages"
    The AWS CLI has been making great improvements to its error messages over time so it is important
    to pay attention to its output as it can reveal profiles that have been misconfigured with the
    wrong roles or missing entries.

## Regenerating the AWS config or credentials files
If you think your AWS config file has misconfigured or missing profile entries (which could happen due to manual editing of that file, or when AWS accounts have been added or remove) you can try regenerating it via Leverage CLI. But before you do that make sure you know which authentication method you are using: SSO or IAM.

When using IAM, regenerating your AWS config file can be achieved through the `leverage credentials` command. Check the [command documentation here](/user-guide/leverage-cli/reference/credentials/).

When using SSO, the command you need to run is `leverage aws configure sso`. Refer to [that command's documentation](/user-guide/leverage-cli/reference/aws/#configure-sso) for more details.

## Logging out of your SSO session
Seldom times, when using SSO, we have received reports of strange behaviors while trying to run Terraform commands via the Leverage CLI. For instance, users would try to run a `leverage tf init` command but would get an error saying that their session is expire; so they would try to log in via `leverage aws sso login` as expected, which would proceed normally so they would try the init command again just to get the same error as before.
In these cases, which we are still investigating as they are very hard to reproduce, what has worked for most users is to log out from the SSO session via `leverage aws sso logout`, even log out from your SSO session through the AWS console running your browser, then try logging back in via `leverage aws sso login`, and then try the init command again.
