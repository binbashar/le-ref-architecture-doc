# Installation

To use Leverage CLI you need to install it from the Python Package Index (Pypi). Currently, only Linux and Mac OS are supported operative systems.

!!! done "Requirements"
    * [x] **Python** `>= 3.8`
    * [x] **Git** `>= 2.25`
    * [x] **Docker engine** `>= 20.x.y`

###Install Pip

=== "Ubuntu/Debian"

    ``` bash
    $ sudo apt install python3-pip
    ```

=== "CentOS/RHEL"

    ``` bash
    $ sudo yum install python3-pip
    ```

=== "Fedora"

    ``` bash
    $ sudo dnf install python3-pip
    ```

=== "MacOS"

    Pip should already be installed alongside your Python 3 installation. If for whatever reason this is not the case:
    ``` bash
    $ brew install python3
    ```

###Install Leverage CLI

``` bash
$ pip3 install leverage
```

###Update Leverage CLI from previous versions

Upgrade to a specific [version](https://github.com/binbashar/leverage/releases).
``` bash
$ pip3 install -Iv leverage==1.9.1
```

Upgrade to the latest stable version
``` bash
$ pip3 install --upgrade leverage
```

###Verify your Leverage installation

Verify that your Leverage installation was successful by running
``` bash
$ leverage --help
Usage: leverage [OPTIONS] COMMAND [ARGS]...

  Leverage Reference Architecture projects command-line tool.

Options:
  -f, --filename TEXT  Name of the build file containing the tasks
                       definitions.  [default: build.py]
  -l, --list-tasks     List available tasks to run.
  -v, --verbose        Increase output verbosity.
  --version            Show the version and exit.
  --help               Show this message and exit.

Commands:
  aws          Run AWS CLI commands in a custom containerized environment.
  credentials  Manage AWS cli credentials.
  kubectl      Run Kubectl commands in a custom containerized environment.
  project      Manage a Leverage project.
  run          Perform specified task(s) and all of its dependencies.
  terraform    Run Terraform commands in a custom containerized...
  tf           Run Terraform commands in a custom containerized...
  tfautomv     Run TFAutomv commands in a custom containerized...
```

##Installation in an isolated environment

If you prefer not to install the Leverage package globally and would like to limit its influence to only the directory of your project, we recommend using tools like [Pipenv](https://pipenv.pypa.io/en/latest/) or [Poetry](https://python-poetry.org/). These tools are commonly used when working with python applications and help manage common issues that may result from installing and using such applications globally.

##Shell completion

To enable autocompletion for Leverage in your shell, do the following:

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

Or to avoid invoking `eval` every time a shell starts:

=== "Bash"

    Save the script:
    ``` bash
    _LEVERAGE_COMPLETE=bash_source leverage > ~/.leverage-complete.bash
    ```
    Source the script in `~/.bashrc`:
    ``` bash
    . ~/.leverage-complete.bash
    ```

=== "Zsh"

    Save the script:
    ``` bash
    _LEVERAGE_COMPLETE=zsh_source leverage > ~/.leverage-complete.zsh
    ```
    Source the script in `~/.zshrc`:
    ``` bash
    . ~/.leverage-complete.zsh
    ```

=== "Fish"

    Save the script to `~/.config/fish/completions/leverage.fish`:
    ``` bash
    _LEVERAGE_COMPLETE=fish_source leverage > ~/.config/fish/completions/leverage.fish
    ```

Start a new shell in order to load any changes made to the shell config.
