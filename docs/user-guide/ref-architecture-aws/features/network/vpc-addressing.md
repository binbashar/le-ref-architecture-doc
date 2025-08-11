# Network Layer

!!! info "In this section we detail all the network design related specifications"
    * [x] VPCs CIDR blocks
    * [x] VPC Gateways:  Internet, NAT, VPN.
    * [x] VPC Peerings
    * [x] VPC DNS Private Hosted Zones Associations.
    * [x] Network ACLS (NACLs)

### VPCs IP Addressing Plan (CIDR blocks sizing)

!!! summary "Introduction"
    VPCs can vary in size from 16 addresses (/16 netmask) to 65,536 addresses (/28 netmask).
    In order to size a VPC correctly, it is important to understand the number, types, and sizes of workloads 
    expected to run in it, as well as workload elasticity and load balancing requirements. 
    
    Keep in mind that there is no charge for using Amazon VPC (aside from EC2 charges), therefore cost 
    should not be a factor when determining the appropriate size for your VPC, so make sure you size your 
    VPC for growth.
    
    Moving workloads or AWS resources between networks is not a trivial task, so be generous in your 
    IP address estimates to give yourself plenty of room to grow, deploy new workloads, or change your 
    VPC design configuration from one to another. The majority of AWS customers use VPCs with a /16 
    netmask and subnets with /23 netmasks. The primary reason AWS customers select smaller VPC and 
    subnet sizes is to avoid overlapping network addresses with existing networks. 

    So having [AWS single VPC Design](https://aws.amazon.com/answers/networking/aws-single-vpc-design/) we've chosen
    a Medium/Small VPC/Subnet addressing plan which would probably fit a broad range variety of
    use cases

## Networking - IP Addressing

!!! example "Starting CIDR Segment (AWS Org)"
    * [x] AWS Org IP Addressing calculation is presented below based on segment `172.16.0.0/12`
    * [x] We started from `172.16.0.0/12` and subnetted to `/20`
    * [x] Resulting in **Total Subnets: 256**
        *   2 x AWS Account with Hosts/SubNet: 4094
        *   1ry VPC + 2ry VPC
        *   1ry VPC DR + 2ry VPC DR


!!! example "Individual CIDR Segments (VPCs)"
    :fast_forward: Then each of these are /20 to /23
    
    *   [x] Considering the whole Starting CIDR Segment (AWS Org) before declared, we'll start at `172.18.0.0/20`
        *   **shared**
            *   1ry VPC CIDR: `172.18.0.0/23`
            *   2ry VPC CIDR: `172.18.16.0/23`
        *   **apps-devstg**
            *   1ry VPC CIDR: `172.18.64.0/23`
            *   2ry VPC CIDR: `172.18.80.0/23`
        *   **apps-prd**
            *   1ry VPC CIDR: `172.18.128.0/23`
            *   2ry VPC CIDR: `172.18.144.0/23`
            
    *   [x] Resulting in **Subnets: 16 x VPC**
        *   VPC Subnets with Hosts/Net: 256.
        *   Eg: apps-devstg account → us-east-1 w/ 3 AZs → 4 x Private Subnets /az + 4 x Public Subnets /az
            *   1ry VPC CIDR: `172.18.64.0/23 `Subnets:
                *   Private `172.18.64.0/23, 172.18.66.0/23, 172.18.68.0/23, and 172.18.70.0/23`
                *   Public `172.18.72.0/23, 172.18.74.0/23, 172.18.76.0/23, and 172.18.78.0/23`
                * Note: keep in mind that you may not strictly need 4 private subnets and 4 public subnets in every case. In some cases you might do fine with only 2 or 3, if that goes in sync with the kind of availability that you need to meet.

## Planned VPCs and their Subnets

Having defined the initial VPC that will be created in the different accounts that were defined, we are going to create
subnets in each of these VPCs defining Private and Public subnets split among different availability zones:
    
| VPC CIDR         | Purpose       | Visual Subnet Calc |
| :--------------: | :-----------: | :----------------: |
| **Shared**       |               |
|  172.18.0.0/20   | Primary       | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.0.0&mask=20&division=15.7231) |
| 172.18.16.0/20   | Secondary     | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.16.0&mask=20&division=15.7231) |
| 172.18.32.0/20   | Primary DR    | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.32.0&mask=20&division=15.7231) |
| 172.18.48.0/20   | Secondary DR  | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.48.0&mask=20&division=15.7231) |
| **Apps-DevStg**  |               |
| 172.18.64.0/20   | Primary       | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.64.0&mask=20&division=15.7231) |
| 172.18.80.0/20   | Secondary     | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.80.0&mask=20&division=15.7231) |
| 172.18.96.0/20   | Primary DR    | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.96.0&mask=20&division=15.7231) |
| 172.18.112.0/20  | Secondary DR  | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.112.0&mask=20&division=15.7231) |
| **Apps-DevStg EKS** |               |
|  10.2.0.0/16   | Primary       | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=10.2.0.0&mask=16&division=15.7231) |
| **Apps-DevStg EKS DemoApps** |               |
|  10.1.0.0/16   | Primary  | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=10.1.0.0&mask=16&division=15.7231) |
| **Apps-Prd**     |               |
| 172.18.128.0/20  | Primary       | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.128.0&mask=20&division=15.7231) |
| 172.18.144.0/20  | Secondary     | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.144.0&mask=20&division=15.7231) |
| 172.18.160.0/20  | Primary DR    | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.160.0&mask=20&division=15.7231) |
| 172.18.176.0/20  | Secondary DR  | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.176.0&mask=20&division=15.7231) |
| **Network** |               |
|  172.20.0.0/20   | Primary       | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.20.0.0&mask=20&division=15.7231) |
| 172.20.16.0/20   | Secondary     | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.20.16.0&mask=20&division=15.7231) |
| 172.20.32.0/20   | Primary DR    | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.20.32.0&mask=20&division=15.7231) |
| 172.20.48.0/20   | Secondary DR  | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.20.48.0&mask=20&division=15.7231) |
| **Data-Science** |               |
|  172.19.0.0/20   | Primary       | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.19.0.0&mask=20&division=15.7231) |
| 172.19.16.0/20   | Secondary     | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.19.16.0&mask=20&division=15.7231) |
| 172.19.32.0/20   | Primary DR    | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.19.32.0&mask=20&division=15.7231) |
| 172.19.48.0/20   | Secondary DR  | [Link](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.19.48.0&mask=20&division=15.7231) |

### Considerations

- Kubernetes on EKS General Requirements for Network Layer: [**K8s EKS Networking | VPC Addressing**](/user-guide/ref-architecture-eks/vpc/)

    
## User guide

Please follow the steps below to orchestrate your `base-network` layer, 1st in your
[`project-shared`](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/us-east-1/base-network) AWS account and
afterwards in the necessary member accounts which will host network connected resources (EC2, Lambda, EKS, RDS, ALB, NLB, etc):  

* [x] [`project-apps-devstg`](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-devstg/us-east-1/base-network) account.
* [x] [`project-apps-prd`](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/us-east-1/base-network) account.

!!! example "Network layer standard creation workflow"
    1. Please follow 
    [Leverage's OpenTofu workflow](../../../base-workflow/repo-le-tf-infra/) for
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
