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

## SSH reiterative confirmation

If you get a reiterative dialog for confirmation while running a `leverage terraform init` :
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

The Leverage CLI mounts the `~/.ssh` directory in order to make the pulling of private Terraform modules work. The error should look similar to the following:
```
[18:26:44.416] ERROR    Error creating container:
                        APIError: 400 Client Error for http+docker://localhost/v1.43/containers/create: Bad Request ("invalid mount config for type "bind": stat /host_mnt/private/tmp/com.apple.launchd.CWrsoki5yP/Listeners: operation not supported")
```

The problem happes because of the file system virtualization that is used by default and can be fixed by choosing the "osxfs (Legacy)" option as shown below:
![docket-daemon-not-responding](/assets/images/screenshots/leverage-docket-desktop-file-system.png "Docker daemon not responding")

Note: that setting can be accessed by clicking on the Docker Desktop icon tray, and then clicking on "Settings...". The setting should be in the "General" tab.

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
