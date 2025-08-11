# Troubleshooting general issues

## Gathering more information
Trying to get as much information about the issue as possible is key when troubleshooting.

If the issue happens while you are working on a layer of the reference architecture and you are using OpenTofu, you can use the `--verbose` flag to try to get more information about the underlying issue.
For instance, if the error shows up while running a tofu plan command, you can enable a more verbose output like follows:
```
leverage --verbose tf plan
```

The `--verbose` flag can also be used when you are working with the Ansible Reference Architecture:
```
leverage --verbose run init
```

## Understanding how Leverage gets the AWS credentials for OpenTofu/Terraform and other tools
Firstly, you need to know that OpenTofu/Terraform doesn't support AWS authentication methods that require user interaction. For instance, logging in via SSO or assuming roles that require MFA. That is why Leverage made the following two design decisions in that regard:

1. Configure OpenTofu/Terraform to use AWS profiles via OpenTofu/Terraform AWS provider and local [AWS configuration files](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).
2. Leverage handles the user interactivity during the authentication phase in order to get the credentials that OpenTofu/Terraform needs through AWS profiles.

So, Leverage runs simple bash scripts to deal with 2. and then passes the execution flow to OpenTofu/Terraform which by then should have the AWS profiles ready-to-use and in the expected path.

## Where are those AWS profiles stored again?
They are stored in 2 files: `config` and `credentials`.
By default, the AWS CLI will create those files under this path: `~/.aws/` but Leverage uses a slightly different convention, so they should actually be located in this path: `~/.aws/[project_name_here]/`.

So, for instance, if your project name is `acme`, then said files should be found under: `~/.aws/acme/config` and `~/.aws/acme/credentials`.

## SSH reiterative confirmation

If you get a reiterative dialog for confirmation while running a `leverage tofu init` :
```
Warning: the ECDSA host key for 'YYY' differs from the key for the IP address 'ZZZ.ZZZ.ZZZ.ZZZ'
Offending key for IP in /root/.ssh/known_hosts:xyz
Matching host key in /root/.ssh/known_hosts:xyw
Are you sure you want to continue connecting (yes/no)?
```
You may have more than 1 key associated to the `YYY` host. Remove the old or incorrect one, and the dialog should stop.

## Leverage CLI can't find the Docker daemon

The Leverage CLI talks to the Docker API which usually runs as a daemon on your machine. Here's an example of the error:
```
$ leverage tf shell
[17:06:13.754] ERROR    Docker daemon doesn't seem to be responding. Please check it is up and running correctly before re-running the command.
```

### MacOS after Docker Desktop upgrade

We've seen this happen after a Docker Desktop upgrade. Defaults are changed and the Docker daemon no longer uses Unix sockets but TCP, or perhaps it does use Unix sockets but under a different path or user.

What has worked for us in order to fix the issue is to make sure the following setting is enabled:
![docket-daemon-not-responding](/assets/images/screenshots/leverage-docket-desktop-daemon-issue.png "Docker daemon not responding")

Note: that setting can be accessed by clicking on the Docker Desktop icon tray, and then clicking on "Settings...". Then click on the "Advanced" tab to find the checkbox.

### Linux and Docker in Rootless mode

First make sure the user is added to the docker group: 

```bash
$ sudo usermod -aG docker $USER
$ newgrp docker
```

If that does not solve it, then the same problem might come from missing env variable `DOCKER_HOST`. `leverage` looks for Docker socket at `unix:///var/run/docker.sock` unless `DOCKER_HOST` is provided in environment. If you installed Docker in [Rootless mode](https://docs.docker.com/engine/security/rootless/), you need to remember to add `DOCKER_HOST` in you rc files:
```bash
export DOCKER_HOST=unix:///run/user/1000/docker.sock
```
or prefix the leverage tool with the env var:
```bash
$ DOCKER_HOST=unix:///run/user/1000/docker.sock leverage tf shell
```

## Leverage CLI fails to mount the SSH directory

### Possible Cause 1: Operation Not Supported
The Leverage CLI mounts the `~/.ssh` directory in order to make the pulling of private OpenTofu/Terraform modules work. The error should look similar to the following:
```
[18:26:44.416] ERROR    Error creating container:
                        APIError: 400 Client Error for http+docker://localhost/v1.43/containers/create: Bad Request ("invalid mount config for type "bind": stat /host_mnt/private/tmp/com.apple.launchd.CWrsoki5yP/Listeners: operation not supported")
```

The problem happens because of the file system virtualization that is used by default and can be fixed by choosing the "osxfs (Legacy)" option as shown below:
![docket-daemon-not-responding](/assets/images/screenshots/leverage-docket-desktop-file-system.png "Docker daemon not responding")

Note: that setting can be accessed by clicking on the Docker Desktop icon tray, and then clicking on "Settings...". The setting should be in the "General" tab.

### Possible Cause 2: Source Path Does Not Exist
This happens because the CLI tries to mount the SSH socket path but such path does not exist.
The error looks similar to this:
```
[16:09:47.818] ERROR    Error creating container:                                                                                                                                          
                        APIError: 400 Client Error for http+docker://localhost/v1.48/containers/create: Bad Request ("invalid mount config for type "bind": bind source path does not      
                        exist: /socket_mnt/private/tmp/com.apple.launchd.wA4586wza6/Listeners")  
```
That typically happens because the CLI gets the SSH socket path from the `SSH_AUTH_SOCK` environment variable, which might be outdated or simply wrong. You should be able to fix the issue by unsetting said environment variable as follows:
```
unset env SSH_AUTH_SOCK
```


## Leverage CLI fails because of missing .gitconfig

The Leverage CLI might fail when setting up for the first time if there is no `~/.gitconfig` in your home directory or if it is misconfigured. You will see something similar to: 

```
[17:13:43.514] ERROR    Error creating container:
                        APIError: 400 Client Error for http+docker://localhost/v1.43/containers/create: ... ("could not find .gitconfig")
```

In order to fix this, just configure git globally: 

```bash
$ git config --global user.name "Name Lastname"
$ git config --global user.email "name.lastname@email.com"
```
## Leverage CLI targeting specific resources with indexes

Sometimes you want to target a specific resource, eg. when importing:

```shell
leverage tofu import aws_organizations_account.management 999999999999
```

But the real issue comes when indexes have to be used.

To do this escape the target string like this:

```shell
leverage tf import 'aws_organizations_account.accounts[\"accountalias\"]' 99999999999
```

For more info on escaping indexes for `import` see [here](../../leverage-cli/reference/tofu/#import)

The same applies to other commands such as `plan`, `destroy` or `apply` when using `-target` with indexes.

E.g.:

```shell
leverage tf plan -target='aws_route53_record.main[\"*.binbash.com.ar\"]'
```

Note the use of single quotes and double quotes.

For more info on escaping indexes for `plan`, `destroy` and `apply` see [here](../../leverage-cli/reference/tofu/#plan)

## OpenTofu State Lock Errors

Issue: Error Acquiring the State Lock.

When running OpenTofu operations, you may encounter an error message similar to:

```
Error: Error acquiring the state lock

Error message: operation error DynamoDB: PutItem, https response error StatusCode: 400, RequestID: [REQUEST-ID]
ConditionalCheckFailedException: The conditional request failed
Lock Info:
  ID:        9c340c13-2308-122f-603c-66c0e72abaf3
  Path:      bb-apps-devstg-terraform-backend/apps-devstg/k8s-eks-demoapps/network/terraform.tfstate
  Operation: OperationTypeApply
  Who:       leverage@6af9e3efd01f
  Version:   1.6.0
  Created:   2025-02-15 16:44:48.04410067 +0000 UTC
  Info:      

OpenTofu acquires a state lock to protect the state from being written
by multiple users at the same time. Please resolve the issue above and try
again. For most commands, you can disable locking with the "-lock=false"
flag, but this is not recommended.
```

This error occurs when OpenTofu cannot acquire a lock on the state file because another process already has it locked, or a previous process did not properly release the lock.

Solution Procedure

1. Navigate to the directory of the OpenTofu configuration that's experiencing the lock issue
1. Access the OpenTofu shell using Leverage:
```shell
leverage tofu shell
```
1. Run the `force-unlock` command with the `lock ID` shown in the error message:
```shell
tofu force-unlock 9c340c13-2308-122f-603c-66c0e72abaf3
```
1. Confirm the operation when prompted
1. Retry your original Leverage OpenTofu command

Alternatively, manually delete the lock entry from DynamoDB table.

1. Go to the AWS console 
1. Navigate to DynamoDB service
1. Find the state lock table (typically named `terraform-state-lock`)
1. Locate and delete the record with the LockID matching the one in your error message
