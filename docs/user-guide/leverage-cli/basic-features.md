# Basic CLI features

To view a list of all the available commands and options in your current Leverage version simply run `leverage` or `leverage --help`. You should get an output similar to this:
``` bash
$ leverage
Usage: leverage [OPTIONS] COMMAND [ARGS]...

  Leverage Reference Architecture projects command-line tool.

Options:
  -v, --verbose  Increase output verbosity.
  --version      Show the version and exit.
  --help         Show this message and exit.

Commands:
  aws          Run AWS CLI commands in the context of the current project.
  credentials  Manage AWS cli credentials.
  kc           Run Kubectl commands in the context of the current project.
  kubectl      Run Kubectl commands in the context of the current project.
  project      Manage a Leverage project.
  run          Perform specified task(s) and all of its dependencies.
  terraform    Run Terraform commands in the context of the current project.
  tf           Run OpenTofu commands in the context of the current project.
  tfautomv     Run TFAutomv commands in the context of the current project.`
  tofu         Run OpenTofu commands in the context of the current project.
```

Similarly, subcommands provide further information by means of the `--help` flag. For example `leverage tf --help`.

## Global options
* `-v` | `--verbose`: Increases output verbosity.  
