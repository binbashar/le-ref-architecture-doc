# Troubleshooting general issues

## Gathering more information
Trying to get as much information of the issue as possible is key when troubleshooting. Keep reading to find out typical scenarios and how you can gather more information about each.

If the issue happens while you are working on a layer of the reference architecture and you are using Terraform, you can use the `--verbose` flag to try to get more information about the underlying issue.
For instance, if the error shows up while running a Terraform plan command, you can enable a more verbose output like follows:
```
leverage --verbose tf plan
```

!!! info "We are currently working on improvements to the logging functionality in order to make it more intuitive so that the different levels of information it presents can empower the user with the knowledge to at least understand what the problem is and quite possibly fix it."

## How Leverage gets AWS credentials for Terraform and other tools
First, you need to know that Terraform doesn't support AWS authentication methods that require user interaction. E.g. logging in via SSO or assuming roles that require MFA.
That is why Leverage made two design decisions in that regard:

1. Configure Terraform to use AWS profiles via Terraform AWS provider and local [AWS configuration files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
2. Leverage handles the user interactivity during the authentication phase in order to get the credentials that Terraform needs through AWS profiles.

So, Leverage runs simple bash scripts to deal with 2. and then passes the execution flow to Terraform which by then should have the AWS profiles ready-to-use, in the expected path.

## Where are those AWS profiles stored again?
It's only 2 files: `config` and `credentials`. They should be located under this path: `~/.aws/[project_name_here]/`. So, for instance, if your project name is `acme`, then said files should be found here: `~/.aws/acme/`.
