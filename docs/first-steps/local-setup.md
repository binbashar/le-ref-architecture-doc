# Install Leverage CLI
Leverage-based projects are better managed via the [Leverage CLI](../../how-it-works/leverage-cli/) which is a companion tool that simplifies your daily interactions with Leverage. This page will guide you through the installation steps.

## Prerequisites
In order to install the CLI you should have the following installed in your system:

- [X] [Git](https://git-scm.com/)
- [X] [Python 3](https://www.python.org/) `version 3.8 and up`
- [X] [Docker](https://docs.docker.com/engine/install/)

## Install [Leverage CLI](../../how-it-works/leverage-cli/)
Leverage CLI is distributed as a python package that you can install it via `pip` as follows:
``` bash
pip install leverage
```

!!! info "For further details on installing Leverage CLI: [:books: Install Leverage CLI](../../user-guide/base-workflow/leverage-cli/install-leverage-cli/)"

## Verify your Leverage CLI installation
Verify that your Leverage CLI installation was successful by running the following command:
``` bash
$ leverage --version
leverage, version 1.9.2
```

!!! info "It is generally recommended to install the latest stable version of the CLI"

## Enable tab completion
If you use Bash, Zsh or Fish, you can enable shell completion for Leverage commands.

=== "Bash"

    Add to `~/.bashrc`:
    ``` bash
    eval "$(_LEVERAGE_COMPLETE=bash_source leverage)"
    ```

=== "Zsh"

    Add to `~/.zshrc`:
    ``` bash
    eval "$(_LEVERAGE_COMPLETE=zsh_source leverage)"
    ```

=== "Fish"

    Add to `~/.config/fish/completions/leverage.fish`:
    ``` bash
    eval (env _LEVERAGE_COMPLETE=fish_source leverage)
    ```

Now you need to restart your shell.

## Next steps
Now you have your system completely configured to work on a Leverage project.

Next, you will setup and create your Leverage project.
