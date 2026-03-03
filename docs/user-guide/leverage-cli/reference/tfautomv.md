# Command: `tfautomv`

The `tfautomv` command  provides the [tfautomv](https://tfautomv.dev/) executable with specific configuration values required by Leverage.

It transparently handles authentication, whether it is Multi-Factor or via Single Sign-On, on behalf of the user in the commands that require it. SSO Authentication takes precedence over MFA when both are active. 

This command can only be run at **layer** level and will not run anywhere else in the project.

If the binary is not installed in the system the CLI will prompt the user to do so.

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

