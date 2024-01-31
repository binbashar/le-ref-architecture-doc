# Add more AWS Accounts

## Brief
You can add new AWS accounts to your Leverage project by following the steps in this page.

!!! info "Important"
    In the examples below, we will be using `apps-prd` as the account we will be adding and it will be created in the `us-east-1` region.

## Create the new account in your AWS Organization
1. Go to `management/global/organizations`.
2. Edit the `locals.tf` file to add the account to the local `accounts` variable.
    ```yaml
        accounts = {
        ...
        ...
            apps-prd = {
                email     = "aws+apps-prd@yourcompany.com",
                parent_ou = "apps"
            }
        }
    ```
    Note that the `apps` organizational unit (OU) is being used as the parent OU of the new account. If you need to use a new OU you can add it to `organizational_units` variable in the same file.
3. Run the [Terraform workflow](https://leverage.binbash.co/user-guide/ref-architecture-aws/workflow/) to apply the new changes. Typically that would be this:
    ```shell
    leverage terraform init
    leverage terraform apply
    ```
!!! info "Authentication error"
    Note this layer was first applied before using the boostrap user. Now, that we are working with SSO, credentials have changed. So, if this is the first account you add you'll probably get this error applying: "Error: error configuring S3 Backend: no valid credential sources for S3 Backend found."
    In this case running `leverage tf init -reconfigure` will fix the issue.
    
4. Add the new account to the `<project>/config/common.tfvars` file. The new account ID should have been displayed in the output of the previous step, e.g.:
   ```shell
   aws_organizations_account.accounts["apps-prd"]: Creation complete after 14s [id=999999999999]
   ```
   **Note** the id, `999999999999`.
   
    ...so please grab it from there and use it to update the file as shown below:
    ```shell
    accounts = {

    [...]

        apps-prd = {
            email = "<aws+apps-prd@yourcompany.com>",
            id    = "<add-the-account-id-here>"
        }
    }
    ```
5. Since you are using SSO in this project, permissions on the new account must be granted before we can move forward. Add the right permissions to the `management/global/sso/account_assignments.tf` file. For the example:
    ```yaml
     # -------------------------------------------------------------------------
     # apps-prd account
     # -------------------------------------------------------------------------
     {
       account             = var.accounts.apps-prd.id,
       permission_set_arn  = module.permission_sets.permission_sets["Administrator"].arn,
       permission_set_name = "Administrator",
       principal_type      = local.principal_type_group
       principal_name      = local.groups["administrators"].name
     },
     {
       account             = var.accounts.apps-prd.id,
       permission_set_arn  = module.permission_sets.permission_sets["DevOps"].arn,
       permission_set_name = "DevOps",
       principal_type      = local.principal_type_group
       principal_name      = local.groups["devops"].name
     },
    ```
    Note your needs can vary, these permissions are just an example, please be careful with what you are granting here.
    
    Apply these changes:
    ```shell
    leverage terraform apply
    ```
    And you must update your AWS config file accordingly by running this:
    ```shell
    leverage aws configure sso
    ```

Good! Now you are ready to create the initial directory structure for the new account. The next section will guide through those steps.

## Create and deploy the layers for the new account
In this example we will create the `apps-prd` account structure by using the `shared` as a template.

### Create the initial directory structure for the new account
1. Ensure you are at the root of this repository
2. Now create the directory structure for the new account:
    ```shell
    mkdir -p apps-prd/{global,us-east-1}
    ```
3. Set up the config files:
    1. Create the config files for this account: 
        ```shell
        cp -r shared/config apps-prd/config
        ```
    2. Open `apps-prd/config/backend.tfvars` and replace any occurrences of `shared` with `apps-prd`.
    3. Do the same with `apps-prd/config/account.tfvars`

### Create the Terraform Backend layer
1. Copy the layer from an existing one:
    ```shell
    cp -r shared/us-east-1/base-tf-backend apps-prd/us-east-1/base-tf-backend
    ```
    
    !!! info
        If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory, e.g. `rm -rf apps-prd/us-east-1/base-tf-backend/.terraform* `
    
2. Go to the `apps-prd/us-east-1/base-tf-backend` directory, open the `config.tf` file and comment the S3 backend block. E.g.:
    ```yaml
    #backend "s3" {
    #    key = "shared/tf-backend/terraform.tfstate"
    #}
    ```
    We need to do this for the first apply of this layer.
    
3. Now run the [Terraform workflow](https://leverage.binbash.co/user-guide/ref-architecture-aws/workflow/) to initialize and
    apply this layer. The flag `--skip-validation` is needed here since the bucket does not yet exist.
    ```shell
    leverage terraform init --skip-validation
    leverage terraform apply
    ```
4. Open the `config.tf` file again uncommenting the block commented before and replacing `shared` with `apps-prd`. E.g.:
    ```yaml
    backend "s3" {
        key = "apps-prd/tf-backend/terraform.tfstate"
    }
    ```
5. To finish with the backend layer, re-init to move the `tfstate` to the new location. Run:
    ```shell
    leverage terraform init
    ```
    Terraform will detect that you are trying to move from a local to a remote state and will ask for confirmation.
    ```shell
    Initializing the backend...
    Acquiring state lock. This may take a few moments...
    Do you want to copy existing state to the new backend?
        Pre-existing state was found while migrating the previous "local" backend to the
        newly configured "s3" backend. No existing state was found in the newly
        configured "s3" backend. Do you want to copy this state to the new "s3"
        backend? Enter "yes" to copy and "no" to start with an empty state.

        Enter a value: 
    ```
    Enter `yes` and hit enter.

### Create the `security-base` layer
1. Copy the layer from an existing one:
    From the repository root run: 
    ```shell
    cp -r shared/us-east-1/security-base apps-prd/us-east-1/security-base
    ```

    !!! info
        If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory, e.g. `rm -rf apps-prd/us-east-1/security-base/.terraform* `

2. Go to the `apps-prd/us-east-1/security-base` directory and open the `config.tf` file replacing any occurrences of `shared` with `apps-prd`
    E.g. this line should be:
    ```yaml
    backend "s3" {
        key = "apps-prd/security-base/terraform.tfstate"
    }
    ```
3. Init and apply the layer

    ```shell
    leverage tf init
    leverage tf apply
    ```

### Create the `network` layer
1. Copy the layer from an existing one:
    From the root of the repository run this: 
    ```shell
    cp -r shared/us-east-1/base-network apps-prd/us-east-1/base-network
    ```

    !!! info
        If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory, e.g. `rm -rf apps-prd/us-east-1/base-network/.terraform* `

2. Go to the `apps-prd/us-east-1/base-network` directory and open the `config.tf` file replacing any occurrences of `shared` with `apps-prd`. E.g. this line should be:
    ```yaml
    backend "s3" {
        key = "apps-prd/network/terraform.tfstate"
    }
    ```
3. Open the file `locals.tf` and set the new account's CIDRs.
    ```yaml
    vpc_cidr_block = "172.19.0.0/20"
    azs = [
        "${var.region}a",
        "${var.region}b",
        #"${var.region}c",
        #"${var.region}d",
    ]

    private_subnets_cidr = ["172.19.0.0/21"]
    private_subnets = [
        "172.19.0.0/23",
        "172.19.2.0/23",
        #"172.19.4.0/23",
        #"172.19.6.0/23",
    ]

    public_subnets_cidr = ["172.19.8.0/21"]
    public_subnets = [
        "172.19.8.0/23",
        "172.19.10.0/23",
        #"172.19.12.0/23",
        #"172.19.14.0/23",
    ]
    ```
    Note here only two AZs are enabled, if needed uncomment the other ones in the three structures.
    
    !!! warning "Do not overlap CIDRs!"
        Be careful when chosing CIDRs.
        Avoid overlaping CIDRs between accounts.
        If you need a reference on how to chose the right CIDRs, please see [here](/user-guide/ref-architecture-aws/features/network/vpc-addressing/).
        
    !!! info "Calculate CIDRs"
        To calculate CIDRs you can check [this playbook](/user-guide/playbooks/VPC-subnet-calculator/).

3. Init and apply the layer
    ```shell
    leverage tf init
    leverage tf apply
    ```

4. Create the VPC Peering between the new account and the VPC of the Shared account. Edit file `shared/us-east-1/base-network/config.tf` and add provider and remote state for the created account.
    ```yaml
    provider "aws" {
        alias                   = "apps-prd"
        region                  = var.region
        profile                 = "${var.project}-apps-prd-devops"
    }
    
    data "terraform_remote_state" "apps-prd-vpcs" {
        for_each = {
        for k, v in local.apps-prd-vpcs :
        k => v if !v["tgw"]
        }
    
        backend = "s3"
    
        config = {
        region  = lookup(each.value, "region")
        profile = lookup(each.value, "profile")
        bucket  = lookup(each.value, "bucket")
        key     = lookup(each.value, "key")
        }
    }
    
    ```
    Edit file `shared/us-east-1/base-network/locals.tf` and under 
    ```yaml
    #
    # Data source definitions
    #
    ```
    ...add the related structure:
    ```yaml
    #
    # Data source definitions
    #
    apps-prd-vpcs = {
        apps-prd-base = {
        region  = var.region
        profile = "${var.project}-apps-prd-devops"
        bucket  = "${var.project}-apps-prd-terraform-backend"
        key     = "apps-prd/network/terraform.tfstate"
        tgw     = false
        }
    }
    ```
    Edit file `shared/us-east-1/base-network/vpc_peerings.tf` (if this is your first added account the file won´t exist, please crate it) and add the peering definition:
    ```yaml
    #
    # VPC Peering: AppsPrd VPC => Shared VPC
    #
    module "vpc_peering_apps_prd_to_shared" {
        source = "github.com/binbashar/terraform-aws-vpc-peering.git?ref=v6.0.0"
        
        for_each = {
        for k, v in local.apps-prd-vpcs :
        k => v if !v["tgw"]
        }
        
        providers = {
        aws.this = aws
        aws.peer = aws.apps-prd
        }
        
        this_vpc_id = module.vpc.vpc_id
        peer_vpc_id = data.terraform_remote_state.apps-prd-vpcs[each.key].outputs.vpc_id
        
        this_rts_ids = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
        peer_rts_ids = concat(
        data.terraform_remote_state.apps-prd-vpcs[each.key].outputs.public_route_table_ids,
        data.terraform_remote_state.apps-prd-vpcs[each.key].outputs.private_route_table_ids
        )
        
        auto_accept_peering = true
        
        tags = merge(local.tags, {
        "Name"             = "${each.key}-to-shared",
        "PeeringRequester" = each.key,
        "PeeringAccepter"  = "shared"
        })
        }

    ```
    Apply the changes (be sure to CD into `shared/us-east-1/base-network` layer for doing this):
    ```shell
    leverage terraform init
    leverage terraform apply
    ```

## Done!
That should be it. At this point you should have the following:

1. A brand new AWS account in your AWS organization.
2. Working configuration files for both existing layers and any new layer you add in the future.
3. A remote Terraform State Backend for this new account.
4. Roles and policies (SSO) that are necessary to access the new account.
5. The base networking resources ready to host your compute services.
6. The VPC peerings between the new account and shared


## Next steps
Now you have a new account created, so what else?

To keep creating infra on top of this **binbash Leverage Landing Zone** with this new account added, please check:

- [X] :books: Check common use cases in [Playbooks](/user-guide/playbooks/)
- [X] :books: Review the [binbash Leverage architecture](/user-guide/ref-architecture-aws/overview/#overview)
- [X] :books: Go for [EKS](/user-guide/ref-architecture-eks/overview/#overview)!
