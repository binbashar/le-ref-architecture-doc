# Project Structure

## Files/Folders Organization
The following block provides a brief explanation of the chosen files/folders layout:

???+ note "*MyExample* project file structure"
    ```
    +📂 management/      (resources for the management account)
        ...
    +📂 security/        (resources for the security + users account)
        ...
    +📂 shared/          (resources for the shared account)
        ...
    +📂 network/         (resources for the centralized network account)
        ...
    +📂 apps-devstg/     (resources for apps dev & stg account)
        ...
    +📂 apps-prd/        (resources for apps prod account)
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
???- note "*MyExample* project file structure"
    ```
    ...
    ├── 📂 apps-devstg
    │   ├── 📂 config
    |   │   ├── 📄 account.tfvars
    |   │   └── 📄 backend.tfvars
    |   ├── 📂 global
    |   │   └── 📂 base-identities
    |   ├── 📂 us-east-1
    |   │   ├── 📂 backups --
    |   │   ├── 📂 base-certificates
    |   │   ├── 📂 base-network
    |   │   ├── 📂 base-tf-backend
    |   │   ├── 📂 cdn-s3-frontend
    |   │   ├── 📂 databases-aurora
    |   │   ├── 📂 databases-mysql --
    |   │   ├── 📂 databases-pgsql --
    |   │   ├── 📂 ec2-fleet-ansible --
    |   │   ├── 📂 k8s-eks-demoapps
    |   │   ├── 📂 k8s-kind
    |   │   ├── 📂 k8s-kops --
    |   │   ├── 📂 notifications
    |   │   ├── 📂 security-audit
    |   │   ├── 📂 security-base
    |   │   ├── 📂 security-certs
    |   │   ├── 📂 security-firewall --
    |   │   ├── 📂 security-keys-dr
    |   │   ├── 📂 storage
    |   │   └── 📂 tools-cloud-nuke
    |   └── 📂 us-east-2
    |       ├── 📂 k8s-eks
    |       ├── 📂 security-compliance --
    |       └── 📂 security-keys
    ├── 📂 apps-prd
    │   ├── 📂 config
    |   │   ├── 📄 account.tfvars
    |   │   └── 📄 backend.tfvars
    │   ├── 📂 global
    |   │   └── 📂 base-identities
    │   └── 📂 us-east-1
    |       ├── 📂 backups --
    |       ├── 📂 base-network
    |       ├── 📂 base-tf-backend
    |       ├── 📂 cdn-s3-frontend
    |       ├── 📂 ec2-fleet --
    |       ├── 📂 k8s-eks
    |       ├── 📂 notifications
    |       ├── 📂 security-audit
    |       ├── 📂 security-base
    |       ├── 📂 security-certs
    |       ├── 📂 security-compliance --
    |       └── 📂 security-keys
    ├── 📄 build.env
    ├── 📄 build.py
    ├── 📂 config
    │   └── 📄 common.tfvars
    ├── 📂 management
    │   ├── 📂 config
    |   │   ├── 📄 account.tfvars
    |   │   └── 📄 backend.tfvars
    │   ├── 📂 global
    |   │   ├── 📂 base-identities
    |   │   ├── 📂 cost-mgmt
    |   │   ├── 📂 organizations
    |   │   └── 📂 sso
    │   ├── 📂 us-east-1
    |   │   ├── 📂 backups
    |   │   ├── 📂 base-tf-backend
    |   │   ├── 📂 notifications
    |   │   ├── 📂 security-audit
    |   │   ├── 📂 security-base
    |   │   ├── 📂 security-compliance --
    |   │   ├── 📂 security-keys
    |   │   └── 📂 security-monitoring-dr --
    │   └── 📂 us-east-2
    |       └── 📂 security-monitoring
    ├── 📂 network
    │   ├── 📂 config
    |   │   ├── 📄 account.tfvars
    |   │   └── 📄 backend.tfvars
    │   ├── 📂 global
    |   │   └── 📂 base-identities
    │   ├── 📂 us-east-1
    |   │   ├── 📂 base-network
    |   │   ├── 📂 base-tf-backend
    |   │   ├── 📂 network-firewall
    |   │   ├── 📂 notifications
    |   │   ├── 📂 security-audit
    |   │   ├── 📂 security-base
    |   │   ├── 📂 security-compliance --
    |   │   ├── 📂 security-keys
    |   │   └── 📂 transit-gateway
    │   └── 📂 us-east-2
    |       ├── 📂 base-network
    |       ├── 📂 network-firewall
    |       ├── 📂 security-compliance --
    |       ├── 📂 security-keys
    |       └── 📂 transit-gateway
    ├── 📂 security
    │   ├── 📂 config
    |   │   ├── 📄 account.tfvars
    |   │   └── 📄 backend.tfvars
    │   ├── 📂 global
    |   │   └── 📂 base-identities
    │   ├── 📂 us-east-1
    |   │   ├── 📂 base-tf-backend
    |   │   ├── 📂 firewall-manager
    |   │   ├── 📂 notifications
    |   │   ├── 📂 security-audit
    |   │   ├── 📂 security-base
    |   │   ├── 📂 security-compliance --
    |   │   ├── 📂 security-keys
    |   │   └── 📂 security-monitoring
    │   └── 📂 us-east-2
    |       ├── 📂 security-audit
    |       ├── 📂 security-compliance --
    |       └── 📂 security-monitoring --
    └── 📂 shared
        ├── 📂 config
        │   ├── 📄 account.tfvars
        │   └── 📄 backend.tfvars
        ├── 📂 global
        |   ├── 📂 base-dns
        |   └── 📂 base-identities
        ├── 📂 us-east-1
        |   ├── 📂 backups
        |   ├── 📂 base-network
        |   ├── 📂 base-tf-backend
        |   ├── 📂 container-registry
        |   ├── 📂 ec2-fleet --
        |   ├── 📂 k8s-eks
        |   ├── 📂 k8s-eks-demoapps
        |   ├── 📂 k8s-eks-prd
        |   ├── 📂 notifications
        |   ├── 📂 security-audit
        |   ├── 📂 security-base
        |   ├── 📂 security-compliance --
        |   ├── 📂 storage
        |   ├── 📂 tools-cloud-scheduler-stop-start
        |   ├── 📂 tools-eskibana
        |   ├── 📂 tools-github-selfhosted-runners
        |   ├── 📂 tools-jenkins --
        |   ├── 📂 tools-managedeskibana
        |   ├── 📂 tools-prometheus
        |   ├── 📂 tools-vault
        |   ├── 📂 tools-vpn-server
        |   └── 📂 tools-webhooks --
        └── 📂 us-east-2
            ├── 📂 base-network
            ├── 📂 container-registry
            ├── 📂 security-compliance --
            ├── 📂 security-keys
            ├── 📂 tools-eskibana
            └── 📂 tools-prometheus
    ```

**NOTE:** As a convention folders with the `--` suffix reflect that the resources are not currently
created in AWS, basically they've been destroyed or not yet exist. 

Such layer separation is meant to avoid situations in which a single folder contains a lot of resources. 
That is important to avoid because at some point, running `leverage terraform plan / apply` starts taking 
too long and that becomes a problem.

This organization also provides a layout that is easier to navigate and discover. 
You simply start with the accounts at the top level and then you get to explore the resource categories within 
each account.
