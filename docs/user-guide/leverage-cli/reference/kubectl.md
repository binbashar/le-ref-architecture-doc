# Command: `kubectl`

!!! info "Regarding Leverage Toolbox versions"
    For using this feature Leverage Toolbox versions `1.2.7-0.1.7` and up, or `1.3.5-0.1.7` and up must be used.

The `kubectl` command is a wrapper for a containerized installation of [kubectl](https://kubernetes.io/docs/reference/kubectl/). It provides the kubectl executable with specific configuration values required by Leverage.

It transparently handles authentication, whether it is Multi-Factor or via Single Sign-On, on behalf of the user in the commands that require it. SSO Authentication takes precedence over MFA when both are active. 

The sub-commands can only be run at **layer** level and will not run anywhere else in the project.
The sub-command `configure` can only be rut at an **EKS cluster layer** level. Usually called `cluster`.

The command can also be invoked via its shortened version `kc`.

---
## `run`

### Usage
``` bash
leverage kubectl [commands] [arguments]
```

Equivalent to `kubectl`.

All arguments given are passed as received to kubectl. 

**Example:**

```bash
leverage kubectl get pods --namespace monitoring
```

---
## `shell`

### Usage
``` bash
leverage kubectl shell
```

Open a shell into the Kubectl container in the current directory.

---
## `configure`

### Usage
``` bash
leverage kubectl configure
```

Automatically add the cluster from the EKS layer into your kubectl config file.
Equivalent to `aws eks update-kubeconfig ...`.
