# Basic CLI features

To view a list of all the available commands and options in your current Leverage version simply run `leverage` or `leverage --help`. You should get an output similar to this:
``` bash
$ leverage
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

Similarly, subcommands provide further information by means of the `--help` flag. For example `leverage tf --help`.

## Global options
* `-f` | `--filename`:  Name of the file containing the tasks' definition. Defaults to `build.py`
* `-l` | `--list-tasks`: List all the tasks defined for the project along a description of their purpose (when available).
```
Tasks in build file `build.py`:

  clean                  	Clean build directory.
  copy_file              	
  echo                   	
  html                   	Generate HTML.
  images        [Ignored]	Prepare images.
  start_server  [Default]	Start the server
  stop_server            	

Powered by Leverage 1.9.0
```
