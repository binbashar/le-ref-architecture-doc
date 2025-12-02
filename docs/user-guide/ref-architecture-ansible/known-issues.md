# Known issues

## SSH keys

When connecting to instances, Ansible uses an SSH Key to authenticate.

Usually, this key is set when the EC2 instance is being created.

Then, when running `leverage run appy`, a container is creater behind the scenes to run the command.

As it can be seen in the command output, the `~/.ssh/bb` directory is mounted in the container to make keys available in the container.

Here two common issues can arise.

## Key location

Some people creates the specific project keys in their very own directories.

In this case, the keys won't be available inside the container since they are not in the mounted directory.

!!! idea "Solution"
    The solution for this case is to copy the key into the `~/.ssh/bb` directory before running the command.

E.g. copy them to `~/.ssh/bb/me` and then set the `.host` file with something like this:

```yaml
[infra] vpn-pritunl     ansible_host='vpn.aws.domain.com' ansible_user='ubuntu' ansible_ssh_private
_key_file='~/.ssh/bb/me/aws-instance-ssh-key' ansible_python_interpreter='/usr/bin/python3'
```

## Passphrase

Some people creates the keys with a passphrase. Then use the `ssh-agent` to make the key available in the shell.

When running `leverage run appy`, the `ssh-agent` is not mounted in the container, making the key (with passphrase) unavailble in the container.

!!! idea "Solution"
    The solution is to use, for the EC2 machines, SSH keys with no passphrase.