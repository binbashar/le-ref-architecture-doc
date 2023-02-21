# Command: `kubectl`

!!! info "Regarding Leverage Toolbox versions"
    For using this feature Leverage Toolbox versions `<define>` and up, or `<define>` and up must be used.

The `kubectl` command is a wrapper for a containerized installation of [kubectl](https://kubernetes.io/docs/reference/kubectl/). It provides the kubectl executable with specific configuration values required by Leverage.

It transparently handles authentication, whether it is Multi-Factor or via Single Sign-On, on behalf of the user in the commands that require it. SSO Authentication takes precedence over MFA when both are active. 

This command can only be run at **layer** level and will not run anywhere else in the project.

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
