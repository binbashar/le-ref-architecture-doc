# Troubleshooting

## General

### Gathering more information
Trying to get as much information of the issue as possible is key when troubleshooting. Keep reading to find out typical scenarios and how you can gather more information about each.

If the issue happens while you are working on a layer of the reference architecture and you are using Terraform, you can use the `--verbose` flag to try to get more information about the underlying issue.
For instance, if the error shows up while running a Terraform plan command, you can enable a more verbose output like follows:
```
leverage --verbose tf plan
```

### How Leverage gets AWS credentials for Terraform and other tools
First, you need to know that Terraform doesn't support AWS authentication methods that require user interaction. E.g. logging in via SSO or assuming roles that require MFA.
That is why Leverage made two design decisions in that regard:

1. Configure Terraform to use AWS profiles via Terraform AWS provider and local [AWS configuration files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
2. Leverage handles the user interactivity during authentication in order to get the credentials Terraform needs through AWS profiles.

So, Leverage runs simple bash scripts to deal with 2. and then passes the execution flow to Terraform which by then should have the AWS profiles ready-to-use, in the expected path.

### Where are those AWS profiles stored again?
It's only 2 files: `config` and `credentials`. They should be located in this path: `~/.aws/[project_name_here]/`. So, for instance, if you project name is `acme`, then said files should be found in: `~/.aws/acme/`.


## Troubleshooting credentials issues

### Determine the profile you are using
When working with the reference architecture, it is important to understand what is the AWS profile that might be causing the issue. Enabling verbose mode should help with that. Read the above section to understand how it can be turned on.
The suspect profile is likely to show right above the error line.

### Test the failing profile with the AWS CLI
Once you have narrowed down your investigation to a profile what you can do is test it. For instance, assuming that the suspect profile is `le-shared-devops`, you can run this command: `aws sts get-caller-identity --profile le-shared-devops`.
Note: if you use the AWS CLI installed in your host machine, you will need to configure the environment variables in the section "Configure the AWS CLI for Leverage" below.

### Check the profiles in your AWS config file
Once you know what AWS profile is causing the issue you can open the AWS config file, typically under `~/.aws/[project_name_here]/config`, to inspect that profile definition.

Things to look out for:

- Is there a profile entry in that file that matches the suspect profile?
- Does the profile entry include all necessary fields?
- Keep in mind that profiles change depending on if you are using SSO or IAM for authentication so please refer to the corresponding section below in this page to find specific details about your case.

### Configure the AWS CLI for Leverage
Since Leverage stores the AWS config and credentials file under a non-default path, when using the AWS CLI you'll need to point it to the right locations:
```
export AWS_CONFIG_FILE=~/.aws/[project_name_here]/config
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/[project_name_here]/credentials
```

!!! info "Tip"
    Another alternative, if you can't to install the AWS CLI on your machine, is to use the one built-in in Leverage toolbox Docker image. You can access it by running `leverage tf shell`


### Investigating SSO credentials issues
TODO config file role and account id

TODO regenerate config file

### Investigating IAM credentials issues
TODO config file role_arn, mfa_serial, region and source_profile

TODO regenerate config file and credentials

