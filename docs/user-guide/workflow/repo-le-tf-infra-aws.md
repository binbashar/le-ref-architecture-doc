# Workflow

!!! success "Terraform Workflow"
    1. Make sure you've read the 'Pre-requisites' section 1st steps
    2. Get into the folder that you need to work with (e.g. `2_identities`)
    3. Run `make init`
    4. Make whatever changes you need to make
    5. Run `make plan` if you only mean to preview those changes
    6. Run `make apply` if you want to review and likely apply those changes

!!! note 
    If desired at step **#5** you could submit a PR, allowing you and the rest of the team to 
    understand and review what changes would be made to your AWS Cloud Architecture components before executing 
    `make apply` (`terraform apply`). This brings the huge benefit of treating changes with a **GitOps** oriented 
    approach, basically as we should treat any other code & infrastructure change, and integrate it with the 
    rest of our tools and practices like CI/CD, in