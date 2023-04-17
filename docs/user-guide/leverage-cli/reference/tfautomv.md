# Command: `tfautomv`

!!! info "Regarding Leverage Toolbox versions"
    For using this feature Leverage Toolbox versions `1.2.7-0.0.5` and up, or `1.3.5-0.0.1` and up must be used.

The `tfautomv` command is a wrapper for a containerized installation of [tfautomv](https://tfautomv.dev/). It provides the tfautomv executable with specific configuration values required by Leverage.

It transparently handles authentication, whether it is Multi-Factor or via Single Sign-On, on behalf of the user in the commands that require it. SSO Authentication takes precedence over MFA when both are active. 

This command can only be run at **layer** level and will not run anywhere else in the project.

---
## `run`

### Usage
``` bash
leverage tfautomv run [arguments]
```

Equivalent to `tfautomv`.

All arguments given are passed as received to tfautomv. 

**Example:**

```bash
leverage tfautomv run --show-analysis --dry-run
```

