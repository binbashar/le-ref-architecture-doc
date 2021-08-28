# Command: `project`

The `project` command is used to execute global operations on the project.

---
## `init`

### Usage
``` bash
leverage project init
```

The `project init` subcommand initializes a Leverage project in the current directory. If not found, it also initializes the global config directory for Leverage CLI `~/.leverage/`, and fetches the template for the projects' creation.

It then proceeds to drop a template file for the project configuration called `project.yaml` and initializes a `git` repository in the directory.

---
## `create`

### Usage
``` bash
leverage project create
```

The `project create` subcommand creates the files structure for the architecture in the current directory and configures it based on the values set in the `project.yaml` file.

It will then proceed to make sure all files follow the standard Terraform code style.
