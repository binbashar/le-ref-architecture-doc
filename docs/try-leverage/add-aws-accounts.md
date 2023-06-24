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
4. Add the new account to the `config/common.tfvars` file. The new account ID should have been displayed in the output of the previous step so please grab it from there and use it to update said file as in the example below:
    ```shell
    accounts = {

    [...]

        apps-prd = {
            email = "<aws+apps-prd@yourcompany.com>",
            id    = "<add-the-account-id-here>"
        }
    }
    ```
5. If you are using SSO in this project, permissions on the new account must be granted before we can move forward. Add the right permissions to the `management/global/sso/account_assignments.tf` file. For the example:
    ```yaml
        {
          account             = var.accounts.apps-prd.id,
          permission_set_arn  = module.permission_sets.permission_sets["Administrator"].arn,
          permission_set_name = "Administrator",
          principal_type      = "GROUP",
          principal_name      = "AWS_Administrators"
        },
    
        {
          account             = var.accounts.apps-prd.id,
          permission_set_arn  = module.permission_sets.permission_sets["DevOps"].arn,
          permission_set_name = "DevOps",
          principal_type      = "GROUP",
          principal_name      = "AWS_DevOps"
        },
    
        {
          account             = var.accounts.apps-prd.id,
          permission_set_arn  = module.permission_sets.permission_sets["Developer_FullAccess"].arn,
          permission_set_name = "Developer_FullAccess",
          principal_type      = "GROUP",
          principal_name      = "AWS_Developers"
        },
    
    ```
    Note your needs can vary, these permissions are just an example, please be careful with what you are granting here. Apply these changes:
    ```shell
    leverage terraform apply
    ```
    And you must update your AWS config file accordingly by running this:
    ```shell
    leverage aws configure sso
    ```

Good! Now you are ready to create the initial directory structure for the new account. The next section will guide through those steps.

## Create and deploy the layers for the new account
In this example we will create the `apps-prd` account structure by using the `apps-devstg` as a template.

### Create the initial directory structure for the new account
1. Ensure you are at the root of this repository
2. Now create the directory structure for the new account:
    ```shell
    mkdir -p apps-prd/{global,us-east-1}
    ```
3. Set up the config files:
    1. Create the config files for this account: 
        ```shell
        cp -r apps-devstg/config apps-prd/config
        ```
    2. Open `apps-prd/config/backend.tfvars` and replace any occurrences of `devstg` with `prd`. (basically, `apps-devstg` is being replaced with the new name `apps-prd`)
    3. Do the same with `apps-prd/config/account.tfvars`
    4. If **no SSO** is implemented in the project (i.e. OAAR is being used):
        1. Open up `apps-prd/config/backend.tfvars` again and replace this:
            ```yaml
            profile = "bb-apps-prd-devops"
            ```
            with this:
            ```yaml
            profile = "bb-apps-prd-oaar"
            ```
        2. In the step above, we are switching to the OAAR (OrganizationalAccountAccessRole) role because we are working with a brand new account that is empty, so, the only way to access it programmatically is through the OAAR role.
        3. Now it's time to configure your OAAR credentials (if haven't already done so). For that you can follow the steps in [this section](https://leverage.binbash.co/try-leverage/management-account/#update-the-bootstrap-credentials) of the official documentation.

### Create the Terraform Backend layer
1. Copy the layer from an existing one:
    ```shell
    cp -r apps-devstg/us-east-1/base-tf-backend apps-prd/us-east-1/base-tf-backend
    ```
    
    !!! info
        If the source layer was already initialized you should delete the previous Terraform setup using `sudo rm -rf .terraform*` in the target layer's directory.
    
2. Go to the `apps-prd/us-east-1/base-tf-backend` directory, open the `config.tf` file and comment the S3 backend block. E.g.:
    ```yaml
    #backend "s3" {
    #    key = "apps-devstg/tf-backend/terraform.tfstate"
    #}
    ```
3. Now run the [Terraform workflow](https://leverage.binbash.co/user-guide/ref-architecture-aws/workflow/) to initialize and
    apply this layer. The flag `--skip-validation` is needed here since the bucket does not yet exist.
    ```shell
    leverage terraform init --skip-validation
    leverage terraform apply
    ```
4. Open the `config.tf` file again uncommenting the block commented before and replacing `devstg` with `prd`. E.g.:
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

### Create the identities layer
1. Copy the layer from an existing one: 
    From the repository root run: 
    ```shel
    cp -r apps-devstg/global/base-identities apps-prd/global/base-identities`
    ```
2. Go to the `apps-prd/global/base-identities` directory and open the `config.tf` file. Replace any occurrences of `devstg` with `prd`. E.g. this line should be:
    ```yaml
    backend "s3" {
        key = "apps-prd/identities/terraform.tfstate"
    }
    ```
3. Init the layer 
    ```shell
    leverage tf init -reconfigure -upgrade
    ```
4. Import the OAAR role 
    Run this command:
    ```shell
    leverage tf import module.iam_assumable_role_oaar.aws_iam_role.this OrganizationAccountAccessRole
    ```
5. Finally apply the layer
    ```shell
    leverage tf apply
    ```

### Create the `security-base` layer
1. Copy the layer from an existing one:
    From the repository root run: 
    ```shell
    cp -r apps-devstg/us-east-1/security-base apps-prd/us-east-1/security-base
    ```
2. Go to the `apps-prd/us-east-1/security-base` directory and open the `config.tf` file replacing any occurrences of `devstg` with `prd`
    E.g. this line should be:
    ```yaml
    backend "s3" {
        key = "apps-prd/security-base/terraform.tfstate"
    }
    ```
3. Init and apply the layer

    ```shell
    leverage tf init -reconfigure -upgrade
    leverage tf apply
    ```

### Create the `network` layer
1. Copy the layer from an existing one:
    From the root of the repository run this: 
    ```shell
    cp -r apps-devstg/us-east-1/base-network apps-prd/us-east-1/base-network
    ```
2. Go to the `apps-prd/us-east-1/base-network` directory and open the `config.tf` file replacing any occurrences of `devstg` with `prd`. E.g. this line should be:
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
3. Init and apply the layer
    ```shell
    leverage tf init -reconfigure -upgrade
    leverage tf apply
    ```
4. Create the VPC Peering between the new account and the VPC of the Shared account. Edit file `shared/us-east-1/base-network/config.tf` and add provider and remote state for the created account.
    ```yaml
    provider "aws" {
        alias                   = "apps-prd"
        region                  = var.region
        profile                 = "${var.project}-apps-prd-devops"
        shared_credentials_file = "~/.aws/${var.project}/config"
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
    Edit file `shared/us-east-1/base-network/vpc_peerings.tf` and add the peering definition:
    ```yaml
    #
    # VPC Peering: AppsPrd VPC => Shared VPC
    #
    module "vpc_peering_apps_prd_to_shared" {
        source = "github.com/binbashar/terraform-aws-vpc-peering.git?ref=v4.0.1"
        
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
    leverage terraform apply
    ```

### Replace temporary profiles with permanent ones
1. If no SSO is implemented in the project (i.e. OAAR is being used), switch back from OAAR to DevOps role
2. Open up `apps-prd/config/backend.tfvars`and replace this:
    ```yaml
    profile = "bb-apps-prd-oaar"
    ```
    with this:
    ```yaml
    profile = "bb-apps-prd-devops"
    ```
    This is needed because we only want to use the OAAR role for exceptional cases, not on a daily basis.
3. Now, let's configure your DevOps credentials (if you haven't already done so).
    1. Log into your security account, create programmatic access keys, and enable MFA.        
    2. Then run: `leverage credentials configure --fetch-mfa-device --type SECURITY`
    3. The command above should prompt for your programmatic keys and, with those, Leverage should be able to configure your AWS config and credentials files appropriately.

## Done!
That should be it. At this point you should have the following:

1. A brand new AWS account in your AWS organization.
2. Working configuration files for both existing layers and any new layer you add in the future.
3. A remote Terraform State Backend for this new account.
4. Roles and policies (base identities) that are necessary to access the new account.
5. The base networking resources ready to host your compute services.
