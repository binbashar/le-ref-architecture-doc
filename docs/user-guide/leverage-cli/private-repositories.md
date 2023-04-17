# Private Repositories

## Working with Terraform modules in private repos
If it is the case that the layer is using a module from a private repository read the following. E.g.:
```yaml
module "themodule" {
  source = "git@gitlab.com:some-org/some-project/the-private-repo.git//modules/the-module?ref=v0.0.1"
  ...
}
```
where `gitlab.com:some-org/some-project/the-private-repo.git` is a private repo.

## SSH accessed repository
To source a Terraform module from a private repository in a layer via an SSH connection these considerations have to be kept in mind.

Leverage CLI will mount the host's SSH-Agent socket into the Leverage Toolbox container, this way your keys are accessed in a secure way.

So, if an SSH private reporitory has to be accessed, the corresponding keys need to be loaded to the SSH-Agent.

If the agent is automatically started and the needed keys added in the host system, it should work as it is.

These steps should be followed otherwise:

- start the SSH-Agent:
```shell
$ eval "$(ssh-agent -s)"
```

- add the keys to it
```shell
$ ssh-add ~/.ssh/<private_ssh_key_file>
```
(replace `private_ssh_key_file` with the desired file, the process can request the passphrase if it was set on key creation step)
