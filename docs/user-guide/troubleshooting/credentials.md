# Troubleshooting credentials issues

### Gathering more information
Trying to get as much information of the issue as possible is key when troubleshooting. Keep reading to find out typical scenarios and how you can gather more information about each.

If the issue happens while you are working on a layer of the reference architecture and you are using Terraform, you can use the `--verbose` flag to try to get more information about the underlying issue.
For instance, if the error shows up while running a Terraform plan command, you can enable a more verbose output like this: `leverage --verbose tf plan`

### Determine the profile you are using
When working with the reference architecture, it is important to understand what is the AWS profile that might be causing the issue. Enabling verbose mode should help with that. Read the above section to understand how it can be turned on.
The suspect profile is likely to show right above the error line.

### Test the failing profile with the AWS CLI
Assuming that the suspect profile is `le-shared-devops`, you can try this command: `aws sts get-caller-identity --profile le-shared-devops`.
Note: if you use the AWS CLI installed in your host machine, you will need to configure the environment variables in the section `Configure the AWS CLI for Leverage`

### Check the profiles in your AWS config file
Once you know what AWS profile is surfacing the issue you can open the AWS config file, typically under `~/.aws/[project_name_here]/config`, to inspect that profile definition.

Important: when using SSO, the profiles are actually created in the AWS credentials file

Things to look out for:
- Is there a profile entry in the AWS config file that matches the suspect profile?
- Does the profile entry include all necessary fields

### Configure the AWS CLI for Leverage
Since Leverage stores the AWS config and credentials file under a non-default path, when using the AWS CLI you'll need to point it to the right locations:
```
export AWS_CONFIG_FILE=~/.aws/[project_name_here]/config
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/[project_name_here]/credentials
```
