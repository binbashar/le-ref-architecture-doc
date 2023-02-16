# Set Up your local environment

A Leverage project is managed via our [Leverage CLI](../../how-it-works/leverage-cli/), which in turn, makes use of a couple of applications that should be installed in your system beforehand, as is explained in the [pre-requisites](../../user-guide/base-configuration/overview/#pre-requisites).

- [X] [Git](https://git-scm.com/)
- [X] [Python 3](https://www.python.org/) `version 3.8 and up`
- [X] [Docker](https://docs.docker.com/engine/install/)

So first, make sure these are installed in your system and the Docker daemon is up and running.

## Install [Leverage CLI](../../how-it-works/leverage-cli/)

As previously stated, to manage a Leverage project and operate the whole Leverage stack you will need to install Leverage CLI. binbash distributes Leverage CLI as a python package, so you can install it via `pip`.

``` bash
pip install leverage
```

!!! info "For more detailed information in installing Leverage CLI: [:books: Install Leverage CLI](../../user-guide/base-workflow/leverage-cli/install-leverage-cli/)"

## Verify your Leverage CLI installation

Verify that your Leverage CLI installation was successful by running
``` bash
leverage --help
```
```
Usage: leverage [OPTIONS] COMMAND [ARGS]...

  Leverage Reference Architecture projects command-line tool.

Options:
  -f, --filename TEXT  Name of the build file containing the tasks
                       definitions.  [default: build.py]
  -l, --list-tasks     List available tasks to run.
  -v, --verbose        Increase output verbosity.
  --version            Show the version and exit.
  -h, --help           Show this message and exit.

Commands:
  credentials  Manage AWS cli credentials.
  project      Manage a Leverage project.
  run          Perform specified task(s) and all of its dependencies.
  terraform    Run Terraform commands in a custom containerized...
  tf           Run Terraform commands in a custom containerized...
```

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
