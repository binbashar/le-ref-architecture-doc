## Override defaults via `build.env` file
By utilizing the [`build.env` capability](https://github.com/binbashar/leverage/blob/master/leverage/conf.py), you can
easily change some default behaviors of the CLI. In the **binbash Leverage™ Ref
Architecture** you will find the following
[`build.env` example](https://github.com/binbashar/le-tf-infra-aws/blob/master/build.env) as an example. 
This allows you to specify several configurations for the CLI, such as the
[Leverage-Toolbox-Image](https://hub.docker.com/repository/docker/binbash/leverage-toolbox/general) that you want to
use, ensuring that you are using the latest version or a specific version that you prefer based on your [compatibility
requirements](https://leverage.binbash.com.ar/work-with-us/releases/versions-compatibility-matrix/#compatibility-matrix).
This helps you avoid compatibility issues and ensures that your infrastructure deployments go smoothly.

### `build.env` file format
The `build.env` file format and supported parameters are the following:

```
# Project settings
PROJECT=bb

# General
MFA_ENABLED=false

# Terraform
TERRAFORM_IMAGE_TAG=1.2.7-0.1.4
```

!!! info "Customizing or extending the leverage-toolbox docker image"
    You can locally copy and edit the [Dockerfile](https://github.com/binbashar/le-docker-leverage-toolbox/blob/master/Dockerfile)
    in order to rebuild it based on your needs, eg for a `Dockerfile` placed in the current working directory:
    `$ docker build -t binbash/leverage-toolbox:1.2.7-0.1.4 --build-arg TERRAFORM_VERSION='1.2.7' .`
    In case you like this changes to be permanent please consider 
    [creating and submitting a PR](https://github.com/binbashar/leverage/pulls).

### Working principle & multiple `build.env` precedence

The `leverage CLI` has an environmental variable loading utility that will load all `.env` files with the given name in 
the current directory an all of its parents up to the repository root directory, and store them in a dictionary.
Files are traversed from parent to child as to allow values in deeper directories to override possible
previously existing values.
Consider all files must bear the same name, which in our case defaults to `"build.env"`. So you can have multiple 
`build.env` files that we'll be processed by the `leverage` CLI in the context of a specific layer of a 
Reference Architecture project. 
For example the [/le-tf-infra-aws/apps-devstg/us-east-1/k8s-kind/k8s-resources/build.env](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-kind/k8s-resources/build.env) file. 