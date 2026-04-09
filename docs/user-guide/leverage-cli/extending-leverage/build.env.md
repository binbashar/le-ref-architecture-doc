## Override defaults via `build.env` file
By utilizing the [`build.env` capability](https://github.com/binbashar/leverage/blob/master/leverage/conf.py), you can
easily change some default behaviors of the CLI. In the **binbash Leverage™ Ref
Architecture** you will find the following
[`build.env` example](https://github.com/binbashar/le-tf-infra-aws/blob/master/build.env) as an example. 
This allows you to specify several configurations for the CLI, such as the project short name that is injected throughout the codebase.

### `build.env` file format
The `build.env` file format and supported parameters are the following:

```
# Project settings
PROJECT=bb

# General
MFA_ENABLED=false

# OpenTofu
TF_BINARY=./@bin/tofu
```

### Working principle & multiple `build.env` precedence

The `leverage CLI` has an environmental variable loading utility that will load all `.env` files with the given name in 
the current directory an all of its parents up to the repository root directory, and store them in a dictionary.
Files are traversed from parent to child as to allow values in deeper directories to override possible
previously existing values.
Consider all files must bear the same name, which in our case defaults to `"build.env"`. So you can have multiple 
`build.env` files that will be processed by the `leverage` CLI in the context of a specific layer of a 
Reference Architecture project. 
For example the [/le-tf-infra-aws/apps-devstg/us-east-1/k8s-kind/k8s-resources/build.env](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-kind/k8s-resources/build.env) file. 
