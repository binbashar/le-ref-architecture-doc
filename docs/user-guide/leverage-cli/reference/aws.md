# Command: `aws`

Run AWS CLI commands with the proper credentials for the project. All commands are passed directly to the AWS CLI and you should expect the standard behavior from all of them, except for the few specific cases listed below.

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
leverage aws sso login [option]
```

It wraps `aws sso login` taking extra steps to allow `Leverage` to use the resulting token while is valid.

### Options
* `--refresh-all`: Once the login succeeds, refresh the temporary credentials of every account profile configured in the project, instead of waiting for each layer to request them on demand.

!!! info "Why refreshing all accounts at once"
    By default, credentials for a given account are only obtained the first time you run a command on a layer
    that needs them. With `--refresh-all` you get a single, up front refresh for all the accounts, which is
    handy when you need valid credentials for tooling that runs outside of Leverage, e.g. the AWS CLI itself,
    `kubectl`, or your IDE's AWS integration.

Accounts that already hold credentials valid for more than 30 minutes are skipped, and accounts on which your
user is not allowed to assume the configured role are reported and skipped too, so a single missing permission
does not abort the whole refresh.

!!! note "Prefer refreshing credentials per layer"
    Bulk refreshing is a convenience, not the recommended default. Whenever possible, use
    `leverage tf refresh-credentials` (also available as `leverage tofu refresh-credentials` and
    `leverage terraform refresh-credentials`) from within the layer you are working on. It only obtains
    credentials for the account that layer actually needs, which follows the principle of least privilege:
    you avoid keeping valid credentials for every account in the project lying around on your machine when
    you are only going to work with one or two of them.


---
## `sso refresh`

### Usage
``` bash
leverage aws sso refresh [option]
```

Refreshes the temporary credentials of every account profile configured in the project, reusing the current
SSO token. It performs the same bulk refresh as `leverage aws sso login --refresh-all`, but without going
through the login flow again, so it can be run at any moment while your SSO session is still valid.

Credentials that are still valid for more than 30 minutes are skipped, and a summary with the number of
refreshed, skipped and failed accounts is printed at the end.

### Options
* `--force`: Refresh the credentials of all accounts even if they have not expired yet.

!!! warn "Important"
    This command requires an active SSO session. If your token has expired or you never logged in, run
    `leverage aws sso login` first.

!!! note
    As with `--refresh-all`, prefer `leverage tf refresh-credentials` from within the layer you are working on
    whenever you can, so that only the credentials that layer needs are obtained, in line with the principle of
    least privilege. See [`sso login`](#sso-login) for more details.


---
## `sso logout`

### Usage
<pre><code>leverage aws sso logout</code></pre>

It wraps `aws sso logout` taking extra steps to make sure that all tokens and temporary credentials are wiped from the system. It also reminds the user to log out form the AWS SSO login page and identity provider portal. This last action is left to the user to perform.

!!! warn "Important"
    Please keep in mind that this command will not only remove temporary credentials but also the AWS config
    file. If you use such file to store your own configuration please create a backup before running the `sso
    logout` command.
