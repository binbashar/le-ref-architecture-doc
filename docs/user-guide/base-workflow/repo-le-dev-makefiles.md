# Makefiles used to operate Binbash Leverage repositories.

## Overview

In order to get the full automated potential of the
[Binbash Leverage Infrastructure as Code (IaC) Library](https://leverage.binbash.com.ar/how-it-works/code-library/code-library/) 
you should initialize all the necessary helper **Makefiles**.

!!! faq "How?"
    For all supported modules and infra components you must execute the `make init-makefiles` command at the root context
    
    ```shell
    ╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
    ╰─⠠⠵ make
    Available Commands:
     - init-makefiles     initialize makefiles
    ```

!!! faq "Why?"
    You'll get all the necessary commands to automatically operate this module via a dockerized approach,
    example shown below for the different tech stack components 

### Terraform 

!!! tip "![leverage-terraform](../../assets/images/logos/terraform.png "Leverage"){: style="width:20px"} Modules"
    ```shell
    ╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
    ╰─⠠⠵ make
    Available Commands:
     - circleci-validate-config  ## Validate A CircleCI Config (https
     - format-check        ## The terraform fmt is used to rewrite tf conf files to a canonical format and style.
     - format              ## The terraform fmt is used to rewrite tf conf files to a canonical format and style.
     - tf-dir-chmod        ## run chown in ./.terraform to gran that the docker mounted dir has the right permissions
     - version             ## Show terraform version
     - init-makefiles      ## initialize makefiles
    ```
    
    ```shell
    ╭─delivery at delivery-I7567 in ~/terraform/terraform-aws-backup-by-tags on master✔ 20-09-17
    ╰─⠠⠵ make format-check
    docker run --rm -v /home/delivery/Binbash/repos/Leverage/terraform/terraform-aws-backup-by-tags:"/go/src/project/":rw -v :/config -v /common.config:/common-config/common.config -v ~/.ssh:/root/.ssh -v ~/.gitconfig:/etc/gitconfig -v ~/.aws/bb:/root/.aws/bb -e AWS_SHARED_CREDENTIALS_FILE=/root/.aws/bb/credentials -e AWS_CONFIG_FILE=/root/.aws/bb/config --entrypoint=/bin/terraform -w "/go/src/project/" -it binbash/terraform-awscli-slim:0.12.28 fmt -check
    ```

!!! tip "![leverage-terraform](../../assets/images/logos/terraform.png "Leverage"){: style="width:20px"} Infra"
    ```shell
    ╭─delivery at delivery-ops in ~/le-tf-infra-aws/apps-devstg/base-network on master✔ 2020-10-29
    ╰─⠠⠵ make
    Available Commands:
     - apply               apply-cmd tf-dir-chmod ## Make terraform apply any changes with dockerized binary
     - cost-estimate-plan  ## Terraform plan output compatible with https
     - cost-estimate-state  ## Terraform state output compatible with https
     - decrypt             ## Decrypt secrets.tf via ansible-vault
     - destroy             ## Destroy all resources managed by terraform
     - encrypt             ## Encrypt secrets.dec.tf via ansible-vault
     - force-unlock        ## Manually unlock the terraform state, eg
     - format-check        ## The terraform fmt is used to rewrite tf conf files to a canonical format and style.
     - format              ## The terraform fmt is used to rewrite tf conf files to a canonical format and style.
     - init                init-cmd tf-dir-chmod ## Initialize terraform backend, plugins, and modules
     - init-reconfigure    init-reconfigure-cmd tf-dir-chmod ## Initialize and reconfigure terraform backend, plugins, and modules
     - output              ## Terraform output command is used to extract the value of an output variable from the state file.
     - plan-detailed       ## Preview terraform changes with a more detailed output
     - plan                ## Preview terraform changes
     - shell               ## Initialize terraform backend, plugins, and modules
     - tf-dir-chmod        ## run chown in ./.terraform to gran that the docker mounted dir has the right permissions
     - tflint-deep         ## TFLint is a Terraform linter for detecting errors that can not be detected by terraform plan (tf0.12 > 0.10.x).
     - tflint              ## TFLint is a Terraform linter for detecting errors that can not be detected by terraform plan (tf0.12 > 0.10.x).
     - validate-tf-layout  ## Validate Terraform layout to make sure it's set up properly
     - version             ## Show terraform version
    ```
    
    ```shell
    ╭─delivery at delivery-ops in ~/le-tf-infra-aws/apps-devstg/base-network on master✔ 2020-10-29
    ╰─⠠⠵ make init
    docker run --rm -v ~/le-tf-infra-aws/apps-devstg/base-network:"/go/src/project/":rw \
        -v ~/le-tf-infra-aws/apps-devstg/config:/config \
        -v ~/le-tf-infra-aws/config/common.config:/common-config/common.config \
        -v ~/.ssh:/root/.ssh -v ~/.gitconfig:/etc/gitconfig \
        -v ~/.aws/bb:/root/.aws/bb \
        -e AWS_SHARED_CREDENTIALS_FILE=/root/.aws/bb/credentials \
        -e AWS_CONFIG_FILE=/root/.aws/bb/config \
        --entrypoint=/bin/terraform \
        -w "/go/src/project/" \
        -it binbash/terraform-awscli-slim:0.13.2 init \
        -backend-config=/config/backend.config
    Initializing modules...
    
    Initializing the backend...
    
    Initializing provider plugins...
    - terraform.io/builtin/terraform is built in to Terraform
    - Using previously-installed hashicorp/aws v3.9.0
    
    Terraform has been successfully initialized!
    
    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.
    
    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    LOCAL_OS_USER_ID: 1000
    LOCAL_OS_GROUP_ID: 1000
    sudo chown -R 1000:1000 ./.terraform
    ```

### Ansible

!!! tip  "![leverage-ansible](../../assets/images/logos/ansible.png "Leverage"){: style="width:20px"} Roles"    
    ```shell
    ╭─delivery at delivery-ops
    ╰─⠠⠵ make
    Available Commands:
     - ansible-galaxy-import-role  ## Run playbook tests w/ molecule using the local code
     - init                ## Install required ansible roles
     - test-ansible-lint   ## Ansible lint
     - test-molecule-galaxy  ## Run playbook tests w/ molecule pulling role from ansible galaxy
     - test-molecule-local  ## Run playbook tests w/ molecule using the local code
     - circleci-validate-config  ## Validate A CircleCI Config (https
     - changelog-init      ## git-chglog (https
     - changelog-major     ## git-chglog generation for major release
     - changelog-minor     ## git-chglog generation for minor release
     - changelog-patch     ## git-chglog generation for path release
     - release-major       ## releasing major (eg
     - release-major-with-changelog-circleci  ## make changelog-major && git add && git commit && make release-major
     - release-major-with-changelog  ## make changelog-major && git add && git commit && make release-major
     - release-minor       ## releasing minor (eg
     - release-minor-with-changelog-circleci  ## make changelog-minor && git add && git commit && make release-minor
     - release-minor-with-changelog  ## make changelog-minor && git add && git commit && make release-minor
     - release-patch       ## releasing patch (eg
     - release-patch-with-changelog-circleci  ## make changelog-patch && git add && git commit && make release-patch
     - release-patch-with-changelog  ## make changelog-patch && git add && git commit && make release-patch
     - init-makefiles      ## initialize makefiles
    ```
    
    ```shell
    ╭─delivery at delivery-ops
    ╰─⠠⠵ make test-molecule-local 
    ...
    -------------------------------
    TESTING MODULE ON: ubuntu1804
    -------------------------------
    Using default tag: latest
    latest: Pulling from geerlingguy/docker-ubuntu1804-ansible
    Digest: sha256:1b47cbb66e819170fd3afee98db55176bc13cd12fabdbcf0183aff2582dc0254
    Status: Image is up to date for geerlingguy/docker-ubuntu1804-ansible:latest
    docker.io/geerlingguy/docker-ubuntu1804-ansible:latest
    ## Starting testing stages ##
    --> Test matrix
        
    └── default
        ├── dependency
        ├── lint
        ├── cleanup
        ├── destroy
        ├── syntax
        ├── create
        ├── prepare
        ├── converge
        ├── idempotence
        ├── side_effect
        ├── verify
        ├── cleanup
        └── destroy
        
    --> Scenario: 'default'
    ...
        
        PLAY [Destroy] *****************************************************************
        
        TASK [Destroy molecule instance(s)] ********************************************
        changed: [localhost] => (item=instance)
        
        TASK [Wait for instance(s) deletion to complete] *******************************
        FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
        changed: [localhost] => (item=None)
        changed: [localhost]
        
        TASK [Delete docker network(s)] ************************************************
        
        PLAY RECAP *********************************************************************
        localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
        
    --> Pruning extra files from scenario ephemeral directory
    -------------------------------
    DONE
    
    -------------------------------
    TESTING MODULE ON: ubuntu1604
    -------------------------------
    ```

!!! tip  "![leverage-ansible](../../assets/images/logos/ansible.png "Leverage"){: style="width:20px"} Infra"
    ```shell
    ╭─delivery at delivery-ops in ~/le-ansible-infra/vpn-pritunl on master✔ 20-10-21
    ╰─⠠⠵ make
    Available Commands:
     - apply               ## run ansible-playbook
     - check               ## run ansible-playbook in Check Mode (“Dry Run”)
     - decrypt             ## Decrypt secrets.tf via ansible-vault
     - decrypt-string      ## Decrypt encrypted string via ansible-vault - e.g. make ARG="your_encrypted_srting" decrypt-string
     - encrypt             ## Encrypt secrets.dec.tf via ansible-vault
     - init-ansible-py     ## Install required ansible version
     - init                ## Install required ansible roles
     - apply-users         ## Run sec-users playbook on this host
    ```
    
    ```shell
    ╭─delivery at delivery-ops in ~/le-ansible-infra/vpn-pritunl on master✔ 20-10-21
    ╰─⠠⠵ make check 
    ansible-playbook setup.yml --check
    
    PLAY [Provision OpenVPN Pritunl instance] ****************************************************************************************************************************************************
    
    TASK [Gathering Facts] ***********************************************************************************************************************************************************************
    ok: [pritunl_private]
    
    TASK [Check ansible version] *****************************************************************************************************************************************************************
    ok: [pritunl_private] => {
        "changed": false,
        "msg": "All assertions passed"
    }
    
    TASK [binbash_inc.ansible_role_common : Setup your server hostname] **************************************************************************************************************************
    ok: [pritunl_private]
    ...
    ```

### Helm

!!! tip  "![leverage-helm](../../assets/images/logos/helm.png "Leverage"){: style="width:20px"} Charts"
    TODO

!!! tip  "![leverage-helm](../../assets/images/logos/helm.png "Leverage"){: style="width:20px"} Infra"
    TODO