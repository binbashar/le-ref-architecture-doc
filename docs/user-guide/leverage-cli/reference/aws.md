# Command: `aws`

The `aws` command is a wrapper for a containerized installation of AWS CLI 2.0. All commands are passed directly to the AWS CLI and you should expect the same behavior from all of them, except for the few exceptions listed below.

---
## `configure sso`

### Usage
``` bash
leverage aws configure sso
```

Extracts information from the project's OpenTofu configuration to generate the required profiles for AWS CLI to handle SSO.

In the process, you will need to log in via your identity provider. To allow you to do this, Leverage will attempt to open the login page in the system's default browser.


---
## `sso login`

### Usage
``` bash
leverage aws sso login
```

It wraps `aws sso login` taking extra steps to allow `Leverage` to use the resulting token while is valid.


---
## `sso logout`

### Usage
<pre><code>leverage aws sso logout</code></pre>

It wraps `aws sso logout` taking extra steps to make sure that all tokens and temporary credentials are wiped from the system. It also reminds the user to log out form the AWS SSO login page and identity provider portal. This last action is left to the user to perform.

!!! warn "Important"
    Please keep in mind that this command will not only remove temporary credentials but also the AWS config
    file. If you use such file to store your own configuration please create a backup before running the `sso
    logout` command.
