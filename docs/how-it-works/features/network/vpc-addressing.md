# Network Layer

!!! info "In this section we detail all the network design related specifications"
    * [x] VPCs CIDR blocks
    * [x] VPC Gateways:  Internet, NAT, VPN.
    * [x] VPC Peerings
    * [x] VPC DNS Private Hosted Zones Associations.
    * [x] Network ACLS (NACLs)

### VPCs IP Addressing Plan (CIDR blocks sizing)

!!! summary "Introduction"
    VPCs can vary in size from 16 addresses (/28 netmask) to 65,536 addresses (/16 netmask). 
    In order to size a VPC correctly, it is important to understand the number, types, and sizes of workloads 
    expected to run in it, as well as workload elasticity and load balancing requirements. 
    
    Keep in mind that there is no charge for using Amazon VPC (aside from EC2 charges), therefore cost 
    should not be a factor when determining the appropriate size for your VPC, so make sure you size your 
    VPC for growth.
    
    Moving workloads or AWS resources between networks is not a trivial task, so be generous in your 
    IP address estimates to give yourself plenty of room to grow, deploy new workloads, or change your 
    VPC design configuration from one to another. The majority of AWS customers use VPCs with a /16 
    netmask and subnets with /24 netmasks. The primary reason AWS customers select smaller VPC and 
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
    :fast_forward: Then each of these are /20 to /24
    
    *   [x] Considering the whole Starting CIDR Segment (AWS Org) before declared, we'll start at `172.18.0.0/20`
        *   **shared**
            *   1ry VPC CIDR: `172.18.0.0/24`
            *   2ry VPC CIDR: `172.18.16.0/24`
            *   1ry VPC DR CIDR: `172.18.32.0/24`
            *   2ry VPC DR CIDR: `172.18.48.0/24`
        *   **apps-devstg**
            *   1ry VPC CIDR: `172.18.64.0/24`
            *   2ry VPC CIDR: `172.18.80.0/24`
            *   1ry VPC DR CIDR: `172.18.96.0/24`
            *   2ry VPC DR CIDR: `172.18.112.0/24`
        *   **apps-prd**
            *   1ry VPC CIDR: `172.18.128.0/24`
            *   2ry VPC CIDR: `172.18.144.0/24`
            *   1ry VPC DR CIDR: `172.18.160.0/24`
            *   2ry VPC DR CIDR: `172.18.176.0/24`
            
    *   [x] Resulting in **Subnets: 16 x VPC**
        *   VPC Subnets with Hosts/Net: 256.
        *   Eg: apps-devstg account → us-east-1 w/ 3 AZs → 3 x Private Subnets /az + 3 x Public Subnets /az
            *   1ry VPC CIDR: `172.18.64.0/24 `Subnets:
                *   Private `172.18.64.0/24, 172.18.66.0/24 and 172.18.68.0/24`
                *   Public `172.18.65.0/24, 172.18.67.0/24 and 172.18.69.0/24`

## Planned VPCs 

Having defined the initial VPC that will be created in the different accounts that were defined, we are going to create
subnets in each of these VPCs defining Private and Public subnets split among different availability zones:
    
| Subnet address   | Netmask       | Range of addresses             | Hosts | Assignment             |
|------------------|---------------|--------------------------------|-------|------------------------|
| 172.18.0.0/20    | 255.255.240.0 | 172.18.0.0  - 172.18.15.255    | 4094  | 1ry VPC: shared        |
| 172.18.16.0/20   | 255.255.240.0 | 172.18.16.0  - 172.18.31.255   | 4094  | 2ry VPC: shared        |
| 172.18.32.0/20   | 255.255.240.0 | 172.18.32.0  - 172.18.47.255   | 4094  | 1ry VPC DR: shared     |
| 172.18.48.0/20   | 255.255.240.0 | 172.18.48.0  - 172.18.63.255   | 4094  | 2ry VPC DR: shared     |
| 172.18.64.0/20   | 255.255.240.0 | 172.18.64.0  - 172.18.79.255   | 4094  | 1ry VPC: apps-devstg   |
| 172.18.80.0/20   | 255.255.240.0 | 172.18.80.0  - 172.18.95.255   | 4094  | 2ry VPC: apps-devstg   |
| 172.18.96.0/20   | 255.255.240.0 | 172.18.96.0  - 172.18.111.255  | 4094  | 1ry VPC DR: apps-devstg|
| 172.18.112.0/20  | 255.255.240.0 | 172.18.112.0  - 172.18.127.255 | 4094  | 2ry VPC DR: apps-devstg|
| 172.18.128.0/20  | 255.255.240.0 | 172.18.128.0  - 172.18.143.255 | 4094  | 1ry VPC: apps-prd      |
| 172.18.144.0/20  | 255.255.240.0 | 172.18.144.0  - 172.18.159.255 | 4094  | 2ry VPC: apps-prd      |
| 172.18.160.0/20  | 255.255.240.0 | 172.18.160.0  - 172.18.175.255 | 4094  | 1ry VPC DR: apps-prd   |
| 172.18.176.0/20  | 255.255.240.0 | 172.18.176.0  - 172.18.191.255 | 4094  | 2ry VPC DR: apps-prd   |

### Considerations

<!-- - Kubernetes on EKS General Requirements for Network Layer: [**K8s EKS Networking**](../compute/k8s-eks.md#network-layer-eks-network-requirements)  -->