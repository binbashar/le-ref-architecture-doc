# Command: `shell`

Run a shell in a generic container.
It supports mounting local paths and injecting arbitrary environment variables.
It also supports AWS credentials injection via mfa/sso.

```bash
>> leverage shell --help

Usage: leverage shell [OPTIONS]

  Run a shell in a generic container. It supports mounting local paths and
  injecting arbitrary environment variables. It also supports AWS credentials
  injection via mfa/sso.

  Syntax: leverage shell --mount <local-path> <container-path> --env-var <name> <value>
  Example: leverage shell --mount /home/user/bin/ /usr/bin/ --env-var env dev

  Both mount and env-var parameters can be provided multiple times.
  Example: leverage shell --mount /home/user/bin/ /usr/bin/ --mount /etc/config.ini /etc/config.ini --env-var init 5 --env-var env dev

Options:
  --mount <TEXT TEXT>...
  --env-var <TEXT TEXT>...
  --mfa                     Enable Multi Factor Authentication upon launching shell.
  --sso                     Enable SSO Authentication upon launching shell.
  --help                    Show this message and exit.
```
