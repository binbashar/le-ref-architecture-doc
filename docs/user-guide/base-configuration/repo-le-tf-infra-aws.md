# Files/Folders Organization
The following block provides a brief explanation of the chosen files/folders layout:

```
+ apps-devstg/     (resources for Apps dev & stg account)
    ...
+ apps-prd/        (resources for Apps Prod account)
    ...
+ root-org/        (resources for the root-org account)
    ...
+ security/        (resources for the security + users account)
    ...
+ shared/          (resources for the shared account)
    ...
```

Configuration files are organized by environments (e.g. dev, stg) and service type (identities, sec, 
network, etc) to keep any changes made to them separate.
Within each of those folders you should find the Terraform files that are used to define all the 
resources that belong to such environment.

![binbash-logo](../../assets/images/diagrams/aws-organizations.png "Binbash"){: style="width:650px"}

**figure 1:** AWS Organization Architecture Diagram (just as reference).

Under every account folder you will see a service layer structure similar to the following:
```
.
├── apps-devstg
│   ├── backups --
│   ├── base-identities
│   ├── base-network
│   ├── base-tf-backend
│   ├── cdn-s3-frontend
│   ├── config
│   ├── databases-mysql --
│   ├── databases-pgsql --
│   ├── ec2-fleet-ansible --
│   ├── k8s-eks --
│   ├── k8s-kops --
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   ├── security-certs
│   ├── security-compliance --
│   ├── security-keys
│   ├── security-keys-dr
│   ├── storage
│   └── tools-cloud-nuke
├── apps-prd
│   ├── backups --
│   ├── base-identities
│   ├── base-network
│   ├── base-tf-backend
│   ├── cdn-s3-frontend
│   ├── config
│   ├── ec2-fleet --
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   ├── security-certs
│   ├── security-compliance --
│   └── security-keys
├── @bin
│   ├── config
│   ├── makefiles
│   └── scripts
├── CHANGELOG.md
├── config
│   └── common.config
├── _config.yml
├── @doc
│   └── figures
├── LICENSE.md
├── Makefile
├── README.md
├── root
│   ├── base-identities
│   ├── base-tf-backend
│   ├── config
│   ├── cost-mgmt
│   ├── notifications
│   ├── organizations
│   ├── security-audit
│   ├── security-base
│   ├── security-compliance --
│   ├── security-keys
│   ├── security-monitoring
│   └── security-monitoring-dr --
├── security
│   ├── base-identities
│   ├── base-tf-backend
│   ├── config
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   ├── security-compliance --
│   ├── security-keys
│   ├── security-monitoring
│   └── security-monitoring-dr --
└── shared
    ├── base-dns
    ├── base-identities
    ├── base-network
    ├── base-tf-backend
    ├── config
    ├── container-registry
    ├── ec2-fleet --
    ├── infra_prometheus
    ├── notifications
    ├── security-audit
    ├── security-base
    ├── security-compliance --
    ├── security-keys
    ├── storage
    ├── tools-cloud-scheduler-stop-start
    ├── tools-eskibana --
    ├── tools-jenkins --
    └── tools-vpn-server
```

**NOTE:** As a convention folders with the `--` suffix reflect that the resources are not currently
created in AWS, basically they've been destroyed or not yet exist. 

Such separation is meant to avoid situations in which a single folder contains a lot of resources. 
That is important to avoid because at some point, running `terraform plan or apply` stats taking too long and that 
becomes a problem.

This organization also provides a layout that is easier to navigate and discover. 
You simply start with the accounts at the top level and then you get to explore the resource categories within 
each account.

# Pre-requisites

## Makefile
- We rely on `Makefiles` as a wrapper to run terraform commands that consistently use the same config files.
- You are encouraged to inspect those Makefiles to understand what's going on.

## Terraform
- [`Makefiles`](https://github.com/binbashar/le-dev-makefiles) already grant the recs via 
  [Dockerized Terraform cmds](https://hub.docker.com/repository/docker/binbash/terraform-awscli-slim)  

## Remote State
In the `tf-backend` folder you should find all setup scripts or configuration files that need to be run before
 you can get to work with anything else.

**IMPORTANT:** THIS IS ONLY NEEDED IF THE BACKEND WAS NOT CREATED YET. IF THE BACKEND ALREADY EXISTS YOU JUST USE IT.

!!! info "Read More"
    * [x] [Terraform - S3 & DynamoDB for Remote State Storage & Locking](../base-workflow/repo-le-tf-infra-aws-tf-state.md)
 
## Configuration

!!! tips "Config files can be found under each `config` folders"
    - :file_folder: **Global config file** 
    [`/config/common.config`](https://github.com/binbashar/le-tf-infra-aws/blob/master/config/common.config) 
    contains global context TF variables that we inject to TF commands which are used by all sub-directories such as 
    `make plan` or `make apply` and which cannot be stored in `backend.config` due to TF.
    - :file_folder: **Account config files** 
        - [`backend.config`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/backend.config)
         contains TF variables that are mainly used to configure TF backend but since
         `profile` and `region` are defined there, we also use them to inject those values into other TF commands.
        - [`account.config`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/account.config)
         contains TF variables that are specific to an AWS account.
    - :file_folder: **Makefile config file** 
    [`/@bin/config/base.mk`](https://github.com/binbashar/le-tf-infra-aws/blob/master/%40bin/config/base.mk) contains
    global [makefile-lib](https://github.com/binbashar/le-dev-makefiles) variables 
    
          
## AWS Profile
- File `backend.config` will inject the profile name that TF will use to make changes on AWS.
- Such profile is usually one that relies on another profile to assume a role to get access to each corresponding account.
- Please follow to correctly setup your AWS Credentials
    - [user-guide/identities](../identities/identities.md)
    - [user-guide/identities/credentials](../identities/credentials.md) 
- Read the following page leverage doc to understand [how to set up a profile to assume 
a role](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)

