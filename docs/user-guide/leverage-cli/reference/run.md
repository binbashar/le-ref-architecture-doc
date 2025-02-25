# Command: `run`

The `run` command is used to execute user defined tasks and all of their dependencies.

!!! info "[:books: Custom tasks documentation](../extending-leverage/tasks.md)"

### Usage
``` bash
leverage run [tasks]
```

An arbitrary number of tasks can be given to the command. All tasks given must be in the form of the task name optionally followed by arguments that the task may require enclosed in square brackets, i.e. `TASK_NAME[TASK_ARGUMENTS]`. The execution respects the order in which they were provided.

If no tasks are given, the default task will be executed. In case no default task is defined, the command will list all available tasks to run.

<b>Example:</b>
```
leverage run task1 task2[arg1,arg2] task3[arg1,kwarg1=val1,kwarg2=val2]
```

* `task1` is invoked with no arguments, which is equivalent to `task1[]`
  
* `task2` receives two positional arguments `arg1` and `arg2`
  
* `task3` receives one positional argument `arg1` and two keyworded arguments `kwarg1` with value `val1` and `kwarg2` with value `val2`

### Options
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

  Powered by Leverage 1.13.0
  ```
