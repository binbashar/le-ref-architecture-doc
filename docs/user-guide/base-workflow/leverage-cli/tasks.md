# Custom tasks

The same way we needed to automate or simplify certain tasks or jobs for the user, you may need to do the same in your project.

Leverage CLI does not limit itself to provide only the core functionality required to create and manage your Leverage project, but also allows for the definition of custom tasks that can be used to add capabilities that are outside of Leverage CLI's scope.

By implementing new auxiliary Leverage tasks you can achieve consistency and homogeneity in the experience of the user when interacting with your Leverage project and simplify the usage of any other tool that you may require.

## Tasks
Tasks are simple python functions that are marked as such with the use of the `@task()` decorator. We call the file where all tasks are defined a 'build script', and by default it is assumed to be named `build.py`. If you use any other name for your build script, you can let Leverage know through the [global option `--filename`](../leverage-cli/reference/basic-features.md).

```python
from leverage import task

@task()
def copy_file(src, dst):
    """Copy src file to dst"""
    print(f"Copying {src} to {dst}")

```

The contents in the task's docstring are used to provide a short description of what's the task's purpose when [listing all available tasks](../leverage-cli/reference/basic-features.md) to run.

``` bash
$ leverage --list-tasks
Tasks in build file `build.py`:

  copy_file               Copy src file to dst

Powered by Leverage 1.0.10
```

Any argument that the task may receive are to be given when [running the task](../leverage-cli/reference/run.md). The syntax for passing arguments is similar to that of Rake.

``` bash
$ leverage run copy_file["/path/to/foo","/path/to/bar"]
[09:25:59.002] [ build.py - ➜ Starting task copy_file]
Copying /path/to/foo to /path/to/bar
[09:25:59.005] [ build.py - ✔ Completed task copy_file ]
```

Keyworded arguments are also supported.

``` bash
$ leverage run copy_file["/path/to/foo", dst="/path/to/bar"]
```


### Dependencies

The `task` decorator allows for the definition of dependencies. These are defined as positional arguments in the decorator itself. Multiple dependencies can be defined for each task.

``` python
from leverage import task
@task()
def html(target="."):
    """Generate HTML."""
    print(f"Generating HTML in directory \"{target}\"")

@task()
def images():
    """Prepare images."""
    print("Preparing images...")

@task(html, images)
def start_server(host="localhost", port="80"):
    """Start the server"""
    print(f"Starting server at {host}:{port}")
```

We can see how the task `start_server` depends on both `html` and `images`. This means that both `html` and `images` will be executed before `start_server` and in that same order.

``` bash
$ leverage run start_server
[09:34:54.848] [ build.py - ➜ Starting task html ]
Generating HTML in directory "."
[09:34:54.851] [ build.py - ✔ Completed task html ]
[09:34:54.852] [ build.py - ➜ Starting task images ]
Preparing images...
[09:34:54.854] [ build.py - ✔ Completed task images ]
[09:34:54.855] [ build.py - ➜ Starting task start_server ]
Starting server at localhost:80
[09:34:54.856] [ build.py - ✔ Completed task start_server ]
```

### Ignoring a task
If you find yourself in the situation were there's a task that many other tasks depend on, and you need to quickly remove it from the dependency chains of all those tasks, ignoring its execution is a very simple way to achieve that end without having to remove all definitions and references across the code.

To ignore or disable a task, simply set `ignore` to `True` in the task's decorator.

``` python
from leverage import task

@task()
def html(target="."):
    """Generate HTML."""
    print(f"Generating HTML in directory \"{target}\"")

@task(ignore=True)
def images():
    """Prepare images."""
    print("Preparing images...")

@task(html, images)
def start_server(server="localhost", port="80"):
    """Start the server"""
    print(f"Starting server at {server}:{port}")

```
``` bash
$ leverage run start_server
[09:38:32.819] [ build.py - ➜ Starting task html ]
Generating HTML in directory "."
[09:38:32.822] [ build.py - ✔ Completed task html ]
[09:38:32.823] [ build.py - ⤳ Ignoring task images ]
[09:38:32.824] [ build.py - ➜ Starting task start_server ]
Starting server at localhost:80
[09:38:32.825] [ build.py - ✔ Completed task start_server ]
```

When [listing the available tasks](../leverage-cli/reference/basic-features.md) any ignored task will be marked as such.

``` bash
$ leverage --list-tasks
Tasks in build file `build.py`:

  html                   	Generate HTML.
  images        [Ignored]	Prepare images.
  start_server           	Start the server

Powered by Leverage 1.0.10
```

### Private tasks
Sometimes you may want to define auxiliary tasks that don't need to be shown as available to run by the user. For this scenario, you can make any task into a private one. There's two ways to accomplish this, either by naming the task with an initial underscore (`_`) or by setting `private` to `True` in the task's decorator.

```python
from leverage import task

@task(private=True)
def clean():
    """Clean build directory."""
    print("Cleaning build directory...")

@task()
def _copy_resources():
    """Copy resource files. This is a private task and will not be listed."""
    print("Copying resource files")

@task(clean, _copy_resources)
def html(target="."):
    """Generate HTML."""
    print(f"Generating HTML in directory \"{target}\"")

@task(clean, _copy_resources, ignore=True)
def images():
    """Prepare images."""
    print("Preparing images...")

@task(html, images)
def start_server(host="localhost", port="80"):
    """Start the server"""
    print(f"Starting server at {host}:{port}")
```

Private tasks will be executed, but not shown when tasks are listed.

``` bash
$ leverage run start_server
[09:40:33.535] [ build.py - ➜ Starting task clean ]
Cleaning build directory...
[09:40:33.540] [ build.py - ✔ Completed task clean ]
               [ build.py - ➜ Starting task _copy_resources ]
Copying resource files
[09:40:33.541] [ build.py - ✔ Completed task _copy_resources ]
[09:40:33.542] [ build.py - ➜ Starting task html ]
Generating HTML in directory "."
[09:40:33.543] [ build.py - ✔ Completed task html ]
[09:40:33.544] [ build.py - ➜ Starting task images ]
Preparing images...
               [ build.py - ✔ Completed task images ]
[09:40:33.545] [ build.py - ➜ Starting task start_server ]
Starting server at localhost:80
[09:40:33.546] [ build.py - ✔ Completed task start_server ]
```
``` bash
$ leverage --list-tasks
Tasks in build file `build.py`:

  html          	Generate HTML.
  images        	Prepare images.
  start_server  	Start the server

Powered by Leverage 1.0.10
```

### Default task
If you have a task that is run much more often than the rest, it can get tedious to always pass the name of that task to the `run` command. Leverage allows for the definition of a default task to address this situation. Thi task is executed when no task name is given.

To define a default task, simply assign the already defined task to the special variable `__DEFAULT__`.

``` python
from leverage import task

@task()
def html(target="."):
    """Generate HTML."""
    print(f"Generating HTML in directory \"{target}\"")

@task(ignore=True)
def images():
    """Prepare images."""
    print("Preparing images...")

@task(html, images)
def start_server(server="localhost", port="80"):
    """Start the server"""
    print(f"Starting server at {server}:{port}")

__DEFAULT__ = start_server
```

The default task is marked as such when listing all available tasks.

``` bash
$ leverage --list-tasks
Tasks in build file `build.py`:

  html                   	Generate HTML.
  images        [Ignored]	Prepare images.
  start_server  [Default]	Start the server

Powered by Leverage 1.0.10
```

### Build scripts lookup
Build scripts are not only looked up in the current directory but also in all parent directories up to the root of the Leverage project. This makes it possible to launch tasks form any directory of the project as long as any parent of the current directory holds a build script.

### Organizing build scripts
Leverage CLI treats the directory in which the build script is found as a python package. This means that you can break up your build files into modules and simply import them into your main build script, encouraging modularity and code reuse.

Leverage CLI empowers you to create whole libraries of functionalities for your project. You can use it to better organize your tasks or implement simple auxiliary python functions.


This way, given the following folder structure:

```
leverage_project
├── build.py
├── deployment_tasks.py
├── testing_tasks.py
└── auxiliary_library
    ├── reports.py
    └── utils.py
```

The build script `build.py` can make use of definitions in the other files by means of importing them.


```python
from .deployment_tasks import *
from .testing_tasks import unit_tests, functional_tests
from .auxiliary_library.reports import coverage_report
from .auxiliary_library.utils import format_as_table
```

!!! info "Importing user defined modules"
    All import statements to user defined modules need to be relative to the main build script in order to function correctly.


## Known issues

#### Zsh Glob Patterns: `zsh: no matches found`
If you use `zsh` as your shell you might get the an error like this one: `zsh: no matches found: start_server[port=8000]`

The problem has to do with the square brackets, as zhs has glob patterns enabled by default which causes every input to be interpreted like that.

The are a few workarounds:

1. Escape the square brackets: `leverage run start_server\[port=8000\]`
   
2. Enclose the entire task between double quotes: `leverage run "start_server[port=8000]"`
   
3. Disable glob patterns: `noglob leverage run start_server[port=8000]`
   
An improvement over the last point is to create an alias for the leverage command: `alias leverage='noglob leverage'`

#### Folder names containing periods
As mentioned in the [Organizing build scripts](#organizing-build-scripts) section, Leverage CLI treats the directory in which the main build script is located as a python package in order to allow importing of user defined python modules. If this directory contains a period (`.`) in its name, this will create issues for the importing process. This is because the period is used by python to separate subpackages from their parents.

For example, if the directory where the build script `build.py` is stored is named `local.assets`, at the time of loading the build script, python will try to locate `local.build` instead of locating `local.assets.build` and fail.

The same situation will arise from any other subdirectory in the project. When importing modules from those directories, they wont be found.

The simple solution to this is to avoid using periods when naming directories. If the build script is located in the project's root folder, this would also apply to that directory.