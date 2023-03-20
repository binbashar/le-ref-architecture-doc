# Working with modules in private repos

If it is the case that the layer is using a module from a private repository read the following.

## SSH accessed repository

To source a Terraform module from a private repository in a layer via an SSH connection these considerations have to be kept in mind.

Leverage CLI will mount the host's SSH-Agent socket into the Levarage Toolbox container, this way your keys are accessed in a secure way.

So, if an SSH private repo has to be reached the keys for such repo should be loaded in the SSH-Agent.

If the agent is automatically started and the needed keys added in the host system, it should work as it is.

These steps should be followed otherwise:

- start the SSH-Agent:
```shell
$ eval "$(ssh-agent -s)"
```

- add the keys to it
```shell
$ ssh-add ~/.ssh/id_ed25519
```
(add here the right file, the process can request the passphrase if it was set on key creation step)
