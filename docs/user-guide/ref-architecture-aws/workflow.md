# Workflow

## Overview
The sequence of commands that you run to operate on each layer is called **the OpenTofu workflow**. In other words, it's what you would typically run in order to create, update, or delete the resources defined in a given layer.

## The basic workflow
Assuming that you have everything configured, the frequent commands you'll need to run are these:
```
# 1. Initialize
leverage tofu init

# 2. Preview any changes
leverage tofu plan

# 3. Apply any changes
leverage tofu apply
```

## The extended workflow
Now, the extended workflow is annotated with more explanations and it is intended for users who haven't yet worked with Leverage on a daily basis:

!!! check "OpenTofu Workflow"
    1. Make sure you understood the basic concepts:
        - [x] [Overview](overview.md)
        - [x] [Configuration](configuration.md)
        - [x] [Directory Structure](dir-structure.md)
        - [x] [Remote State](tf-state.md)
    2. Make sure you installed the [Leverage CLI](../leverage-cli/overview.md).
    3. Go to the layer (directory) you need to work with, e.g. `shared/global/base-identities/`.
    4. Run `leverage tofu init` -- only the first time you work on this layer, or if you upgraded modules or providers versions, or if you made changes to the OpenTofu remote backend configuration.
    5. Make any changes you need to make. For instance: modify a resource definition, add an output, add a new resource, etc.
    6. Run `leverage tofu plan` to preview any changes.
    7. Run `leverage tofu apply` to give it a final review and to apply any changes.

!!! info "Tip"
    You can use the `--layers` argument to run Terraform commands on more than one layer. For more information see [here](../leverage-cli/reference/tofu/layers.md)

!!! note 
    If desired, at step **#5** you could submit a PR, allowing you and the rest of the team to 
    understand and review what changes would be made to your AWS Cloud Architecture components before executing 
    `leverage tofu apply` (`tofu apply`). This brings the huge benefit of treating changes with a **GitOps** oriented 
    approach, basically as we should treat any other code & infrastructure change, and integrate it with the 
    rest of our tools and practices like CI/CD, in

## Running in Automation
![leverage-aws-terraform](/assets/images/diagrams/aws-terraform-automation.png "Terraform"){: style="width:350"}
<figcaption style="font-size:15px">Figure: Running terraform with AWS in automation (just as reference).</figcaption>

!!! info "Read More"
    * :ledger: [Running Terraform in automation](https://learn.hashicorp.com/terraform/development/running-terraform-in-automation)
