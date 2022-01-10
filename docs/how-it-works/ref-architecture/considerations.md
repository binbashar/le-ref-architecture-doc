## Important Considerations

!!! info "Assumptions"
    *   [x] **AWS Regions:** Multi Region setup → 1ry: us-east-1 (N. Virginia) & 2ry: us-west-2 (Oregon).
    *   [x] **Repositories & Branching Strategy** 
        - DevOps necessary repositories will be created.
        Consultant will use a trunk-based branching strategy with short-lived feature branches (`feature/ID-XXX` -> `master),
        and members from either the Consultant or the Client will be reviewers of every code delivery to said 
        repositories (at least 1 approver per Pull Request). 
        - Infra as code deployments should run from the new `feature/ID-XXX` or `master` branch.
        `feature/ID-XXX` branch must be merged immediately (ASAP) via PR to the `master` branch.
        - :ledger: **Consideration:** validating that the changes within the code will only affect the desired target resources
        is the responsibility of the executor (to ensure everything is OK please consider exec after review/approved PR).  
    *   [x] **Infra as Code + GitOps** 
        - After deployment via IaC (Terraform, Ansible & Helm) all subsequent changes will
        be performed via versioned controlled code, by modifying the corresponding repository and running the proper IaC
        Automation execution. 
        - All AWS resources will be deployed via **_Terraform_** and rarely occasional CloudFormation, Python SDK & AWS CLI
        when the resource is not defined by Terraform (almost none scenario). All code and scripts will be included in the
        repository.
        We'll start the process via Local Workstations. Afterwards full exec automation will be considered via: Github Actions, 
        ,Gitlab Pipelines or equivalent preferred service. 
        - :ledger: **Consideration:** Note that any change manually performed will generate inconsistencies on the deployed resources 
          (which left them out of governance and support scope).
    *   [x] **Server OS provisioning**: Provisioning via **_Ansible_** for resources that need to be provisioned on an OS.
    *   [x] **Containers Orchestration:** Orchestration via **_Terraform + Helm Charts** for resources that need to be 
        provisioned in Kubernetes (with **_Docker_** as preferred container engine).
    *   [x] **Pre-existing AWS Accounts:** All resources will be deployed in several new AWS accounts created inside the Client AWS Organization. 
        Except for the AWS Legacy Account invitation to the AWS Org and _OrganizationAccountAccessRole_ creation in it, 
        there will be no intervention whatsoever in Client Pre-existing accounts, unless required by Client 
        authority and given a specific requirement.
        
!!! info 
    We will explore the details of all the relevant Client application stacks, CI/CD processes, 
    monitoring, security, target service level objective (SLO) and others in a separate document.