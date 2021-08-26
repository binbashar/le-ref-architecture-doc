![binbash-logo](../../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../../assets/images/logos/binbash-leverage.png#right "Leverage"){: style="width:130px"}

# Leverage CLI
Leverage CLI is the tool used to manage and interact with any Leverage project.

It transparently handles the most complex and error prone tasks that arise from working with a state-of-the-art infrastructure definition like our Leverage Reference Architecture. Leverage CLI uses a dockerized approach to encapsulate the tools needed to perform such tasks and to free the user from having to deal with the configuration and management of said tools.

!!! success "[:books: **Leverage CLI Documentation**](../../user-guide/base-workflow/leverage-cli/reference/basic-features.md)"
## Sources
- [x] [leverage-cli github](https://github.com/binbashar/leverage)
- [x] [leverage-cli pypi](https://pypi.org/project/leverage/)

## How Leverage CLI came about
The multiple tools and technologies required to work with a Leverage project were initially handled through a Makefiles system. Not only to automate and simplify the different tasks, but also to provide a uniform user experience during the management of a project.

As a result of more and more features being added and the Leverage Reference Architecture becoming broader and broader, our Makefiles were growing large and becoming too repetitive, and thus, harder to maintain. Also, some limitations and the desire for a more friendly and flexible language than that of Makefiles made evident the need for a new tool to take their place.

Python, a language broadly adopted for automation due to its flexibility and a very gentle learning curve seemed ideal. Even more so, Pynt, a package that provides the ability to define and manage tasks as simple Python functions satisfied most of our requirements, and thus, was selected for the job. Some gaps still remained but with minor modifications these were bridged.

Gradually, all capabilities originally implemented through Makefiles were migrated to Python as libraries of tasks that still resided within the Leverage Reference Architecture. But soon, the need to deliver these capabilities pre-packaged in a tool instead of embedded in the infrastructure definition became apparent, and were re-implemented in the shape of built-in commands of Leverage CLI.

Currently, the core functionality needed to interact with a Leverage project is native to Leverage CLI but a system for custom tasks definition and execution heavily inspired in that of Pynt is retained.
