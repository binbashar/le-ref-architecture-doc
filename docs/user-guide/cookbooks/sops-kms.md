# Encrypt and decrypt SOPS files with AWS KMS

## Goal

Using a SOPS file to store secrets in the git repository.

Encrypting the SOPS file with a KMS key.

### Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was created and a region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

### Prerequisites

- you need SOPS installed
     - to avoid dependencies when using the [**binbash Leverage**](https://leverage.binbash.co/) [shell](http://localhost:8000/user-guide/leverage-cli/reference/shell/#overview) command, we recommend to download the binary from [here](https://github.com/getsops/sops/releases).
- a KMS key created, we have done this using the [**binbash Leverage**](https://leverage.binbash.co/) [security-keys](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/security-keys) layer.

## SOPS

To know more about SOPS read [here](https://github.com/getsops/sops).

---

---

## How to

We will be using [**binbash Leverage**](https://leverage.binbash.co/) [shell](http://localhost:8000/user-guide/leverage-cli/reference/shell/#overview) command to achieve this.

### The source file

First, in the layer where you need the SOPS file, create a sample yaml, e.g. a file `secrets.yaml`:

```yaml
topic:
  subtopic: value
```

## Access the shell

First, be sure your credentials are up to date. You can run a `leverage tf plan` and they will be updated.

Run the shell command:

```shell
leverage shell --mount /{path-to-your-tools-directory}/sops/ /extrabin
```

## Encrypt the file

Note for encrypting you need to specify an AWS Profile. In the [**binbash Leverage**](https://leverage.binbash.co/) context profiles are like this: `{short-project-name}-{account}-{role}`.
For example, for my `apps-devstg` account, using the role `devops`, in my project `bb`, the profile is: `bb-apps-devstg-devops`.

From the new shell encrypt your file:

```shell
AWS_PROFILE=bb-apps-devstg-devops /extrabin/sops --encrypt --kms {your-kms-arn-here} secrets.yaml > secrets.enc.yaml
```

!!! info
    Since [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is being used, the default key for the account+region has an alias: `${var.project}_${var.environment}_${var.kms_key_name}_key`, in this case is `vp_apps-devstg_default_key`, so `arn:aws:kms:<region>:<account>:alias/vp_apps-devstg_default_key` should be used.
    
!!! info
    To use this file with OpenTofu, edit the `secrets.enc.yaml` and at the bottom, edit the line with `aws_profile` and set there the AWS Profile you've used to encrypt the file.

##  Decrypt the file

From the shell decrypt your file:

```shell
AWS_PROFILE=bb-apps-devstg-devops /extrabin/sops --decrypt secrets.enc.yaml
```

## How to use it with Leverage

Now that the secret is stored in a secure file, it can be used.

The example here is pretty simple, just getting the value and sending it to an output. But it can be used in any other resource.

First your user (the one used to run [**binbash Leverage**](https://leverage.binbash.co/) ) needs access to the used KMS key.

Then, open the file:

```terraform
data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}
```

...and use it:
```terraform
output "thevalue" {
    value = data.sops_file.secrets.data["topic.subtopic"]
}
```
