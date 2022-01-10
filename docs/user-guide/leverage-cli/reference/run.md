# Command: `run`

The `run` command is used to execute user defined tasks and all of their dependencies.

!!! info "[:books: About tasks and how to implement them](../tasks.md)"

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