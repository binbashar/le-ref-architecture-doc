# Extending & Configuring leverage CLI

## Override defaults via `build.env` file
By utilizing the [`build.env` capability](https://github.com/binbashar/leverage/blob/master/leverage/conf.py), you can
easily change some default behaviors of the CLI. This allows you to specify several configurations for the CLI, 
such as the
[Leverage-Toolbox-Image](https://hub.docker.com/repository/docker/binbash/leverage-toolbox/general) that you want to
use, ensuring that you are using the latest version or a specific version that you prefer based on your [compatibility
requirements](https://leverage.binbash.com.ar/work-with-us/releases/versions-compatibility-matrix/#compatibility-matrix). 
This helps you avoid compatibility issues and ensures that your infrastructure deployments go smoothly. 

!!! info "Read More about `build.env`"
    In order to further understand this mechanism and how to use it please visit the dedicated 
    [build.env](./build.env.md) entry.

## `.tfvars` config files
Using additional `.tfvars` configuration files at the account level or at the global level will allow you to extend your
terraform configuration entries. Consider that using multiple `.tfvars` configuration files allows you to keep your 
configuration entries well-organized. You can have separate files for different accounts or environments, making it easy
to manage and maintain your infrastructure. This also makes it easier for other team members to understand and work with
your configuration, reducing the risk of misconfigurations or errors.

!!! info "Read More about `.tfvars` config files"
    In order to further understand this mechanism and how to use it please visit the dedicated
    [.tfvars configs](../../ref-architecture-aws/configs.md) entry.

## Custom tasks with build.py 
Leverage CLI has a native mechanism to allow yo customizing your workflow. With the custom tasks feature using `build.py`,
you can write your own tasks using Python, tailoring the CLI to fit your specific workflow. This allows you to automate
and streamline your infrastructure deployments, reducing the time and effort required to manage your infrastructure. 
You can also easily integrate other tools and services into your workflow to further improve your productivity.

!!! info "Read More about `build.py` custom tasks"
    In order to further understand this mechanism and how to use it please visit the dedicated
    [build.py custom tasks](tasks.md) entry.

## Fork, collaborate and improve  
By forking the [leverage repository on GitHub](https://github.com/binbashar/leverage) and contributing to the project,
you have the opportunity to make a positive impact on the product and the community. You can fix bugs, implement new 
features, and contribute your ideas and feedback. This helps to ensure that the product continues to evolve and improve,
serving the needs of the community and making infrastructure deployments easier for everyone.

!!! info "Read More about contributing with the project"
    In order to further understand this mechanism and how to use it please visit the dedicated
    [CONTRIBUTING.md](https://github.com/binbashar/leverage/blob/master/CONTRIBUTING.md) entry.

