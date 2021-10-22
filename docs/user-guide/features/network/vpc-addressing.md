# Network Layer

!!! help "How it works"
    :books: [**documentation:** Networking](../../../../how-it-works/features/network/vpc-addressing/)
    
## User guide

Please follow the steps below to orchestrate your `base-network` layer, 1st in your
[`project-shared`](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/base-network) AWS account and
afterwards in the necessary member accounts which will host network connected resources (EC2, Lambda, EKS, RDS, ALB, NLB, etc):  

* [x] [`project-apps-devstg`](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/base-network) account.
* [x] [`project-apps-prd`](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/us-east-1/base-network) account.

!!! example "Network layer standard creation workflow"
    1. Please follow 
    [Leverage's Terraform workflow](../../../base-workflow/repo-le-tf-infra/) for
    each of your accounts.
    2. We'll start by `project-shared` AWS Account Update (add | remove | customize) your VPC associated code before 
    deploying this layer [shared/base-network](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/base-network)
        Main files
        - :file_folder: [network.tf](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/base-network/network.tf)
        - :file_folder: [locals.tf](https://github.com/binbashar/le-tf-infra-aws/blob/master/shared/us-east-1/base-network/locals.tf)
    3. Repeat for every AWS member Account that needs its own VPC 
    [Access AWS Organization member account](https://aws.amazon.com/premiumsupport/knowledge-center/organizations-member-account-access/)        
    consider repeating step 3. but for the corresponding member accounts.


### Next Steps

:books: [AWS VPC Peering](vpc-peering.md)