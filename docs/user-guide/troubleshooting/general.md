# Troubleshooting general issues

## Gathering more information
Trying to get as much information about the issue as possible is key when troubleshooting.

If the issue happens while you are working on a layer of the reference architecture and you are using Terraform, you can use the `--verbose` flag to try to get more information about the underlying issue.
For instance, if the error shows up while running a Terraform plan command, you can enable a more verbose output like follows:
```
leverage --verbose tf plan
```

The `--verbose` flag can also be used when you are working with the Ansible Reference Architecture:
```
leverage --verbose run init
```

## Understanding how Leverage gets the AWS credentials for Terraform and other tools
Firstly, you need to know that Terraform doesn't support AWS authentication methods that require user interaction. For instance, logging in via SSO or assuming roles that require MFA. That is why Leverage made the following two design decisions in that regard:

1. Configure Terraform to use AWS profiles via Terraform AWS provider and local [AWS configuration files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
2. Leverage handles the user interactivity during the authentication phase in order to get the credentials that Terraform needs through AWS profiles.

So, Leverage runs simple bash scripts to deal with 2. and then passes the execution flow to Terraform which by then should have the AWS profiles ready-to-use and in the expected path.

## Where are those AWS profiles stored again?
They are stored in 2 files: `config` and `credentials`.
By default, the AWS CLI will create those files under this path: `~/.aws/` but Leverage uses a slightly different convention, so they should actually be located in this path: `~/.aws/[project_name_here]/`.

So, for instance, if your project name is `acme`, then said files should be found under: `~/.aws/acme/config` and `~/.aws/acme/credentials`.
