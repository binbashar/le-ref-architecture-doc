# Files/Folders Organization
The following block provides a brief explanation of the chosen files/folders layout:

```
+ management/      (resources for the management account)
    ...
+ security/        (resources for the security + users account)
    ...
+ shared/          (resources for the shared account)
    ...
+ network/         (resources for the centralized network account)
    ...
+ apps-devstg/     (resources for apps dev & stg account)
    ...
+ apps-prd/        (resources for apps prod account)
    ...
```

Configuration files are organized by environments (e.g. dev, stg, prd), and service type,
which we call **layers** (identities, organizations, storage, etc) to keep any changes made to them separate.
Within each of those folders you should find the Terraform files that are used to define all the 
resources that belong to such account environment and specific layer.

![binbash-logo](../../assets/images/diagrams/aws-organizations.png "Binbash"){: style="width:650px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Organization multi-account architecture diagram.
(Source: Binbash Leverage,
"Leverage Reference Architecture components",
Binbash Leverage Doc, accessed August 4th 2021).
</figcaption>

Under every account folder you will see a service layer structure similar to the following:
```
...
├── apps-devstg
│   ├── backups\ --
│   ├── base-certificates
│   ├── base-identities
│   ├── base-network
│   ├── base-tf-backend
│   ├── cdn-s3-frontend
│   ├── config
│   ├── databases-aurora
│   ├── databases-mysql\ --
│   ├── databases-pgsql\ --
│   ├── ec2-fleet-ansible\ --
│   ├── k8s-eks
│   ├── k8s-eks-demoapps
│   ├── k8s-kind
│   ├── k8s-kops\ --
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   ├── security-certs
│   ├── security-compliance\ --
│   ├── security-firewall\ --
│   ├── security-keys
│   ├── security-keys-dr
│   ├── storage
│   └── tools-cloud-nuke
├── apps-prd
│   ├── backups\ --
│   ├── base-identities
│   ├── base-network
│   ├── base-tf-backend
│   ├── cdn-s3-frontend
│   ├── config
│   ├── ec2-fleet\ --
│   ├── k8s-eks
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   ├── security-certs
│   ├── security-compliance\ --
│   └── security-keys
├── build.env
├── build.py
├── config
│   ├── common.tfvars
├── network
│   ├── base-identities
│   ├── base-network
│   ├── base-tf-backend
│   ├── config
│   ├── network-firewall
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   └── security-keys
├── management
│   ├── backups
│   ├── base-identities
│   ├── base-tf-backend
│   ├── config
│   ├── cost-mgmt
│   ├── notifications
│   ├── organizations
│   ├── security-audit
│   ├── security-base
│   ├── security-compliance\ --
│   ├── security-keys
│   ├── security-monitoring
│   └── security-monitoring-dr\ --
├── security
│   ├── base-identities
│   ├── base-tf-backend
│   ├── config
│   ├── notifications
│   ├── security-audit
│   ├── security-base
│   ├── security-compliance\ --
│   ├── security-keys
│   ├── security-monitoring
│   └── security-monitoring-dr\ --
└── shared
    ├── backups
    ├── base-dns
    ├── base-identities
    ├── base-network
    ├── base-tf-backend
    ├── config
    ├── container-registry
    ├── ec2-fleet\ --
    ├── k8s-eks
    ├── k8s-eks-demoapps
    ├── k8s-eks-prd
    ├── notifications
    ├── security-audit
    ├── security-base
    ├── security-compliance\ --
    ├── security-keys
    ├── security-keys-dr
    ├── storage
    ├── tools-cloud-scheduler-stop-start
    ├── tools-eskibana
    ├── tools-github-selfhosted-runners
    ├── tools-jenkins\ --
    ├── tools-managedeskibana
    ├── tools-prometheus
    ├── tools-vault
    ├── tools-vpn-server
    └── tools-webhooks\ --
```

**NOTE:** As a convention folders with the `--` suffix reflect that the resources are not currently
created in AWS, basically they've been destroyed or not yet exist. 

Such layer separation is meant to avoid situations in which a single folder contains a lot of resources. 
That is important to avoid because at some point, running `leverage terraform plan / apply` starts taking 
too long and that becomes a problem.

This organization also provides a layout that is easier to navigate and discover. 
You simply start with the accounts at the top level and then you get to explore the resource categories within 
each account.

## Remote State
In the `base-tf-backend` folder you should find the definition of the infrastructure that needs to be deployed before 
you can get to work with anything else.

**IMPORTANT:** THIS IS ONLY NEEDED IF THE BACKEND WAS NOT CREATED YET. IF THE BACKEND ALREADY EXISTS YOU JUST USE IT.

!!! info "Read More"
    * [x] [Terraform - S3 & DynamoDB for Remote State Storage & Locking](../base-workflow/repo-le-tf-infra-aws-tf-state.md)
 
## Configuration

!!! tips "Config files can be found under each `config` folders"
    - :file_folder: **Global config file** 
    [`/config/common.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/config/common.config.example) 
    contains global context TF variables that we inject to TF commands which are used by all sub-directories such as 
    `make plan` or `make apply` and which cannot be stored in `backend.config` due to TF.
    - :file_folder: **Account config files** 
        - [`backend.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/backend.config)
         contains TF variables that are mainly used to configure TF backend but since
         `profile` and `region` are defined there, we also use them to inject those values into other TF commands.
        - [`account.tfvars`](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/config/account.config)
         contains TF variables that are specific to an AWS account.
          
## AWS Profile
- File `backend.tfvars` will inject the profile name that TF will use to make changes on AWS.
- Such profile is usually one that relies on another profile to assume a role to get access to each corresponding account.
- Please follow to correctly setup your AWS Credentials
    - [user-guide/features/identities](../features/identities/identities.md)
    - [user-guide/features/identities/credentials](../features/identities/credentials.md) 
- Read the following page leverage doc to understand [how to set up a profile to assume 
a role](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)

