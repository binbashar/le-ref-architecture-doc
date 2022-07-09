
# Leverage Releases & Versioning

Binbash Leverage™ and its components intends to be backward compatible, but since the complex ecosystems of tools we 
manage this is not always possible. 

Is always recommended using the latest version of the [Leverage cli](https://pypi.org/project/leverage/) with the latest versions of the 
[Reference Architecture for AWS](https://github.com/binbashar/le-tf-infra-aws/releases). In case that's 
not possible we always recommend pinning versions to favor stability and doing controlled updates by component based
on the below presented compatibility matrix table.

## Compatibility Matrix

| Leverage Ref Arch :construction_site: :cloud: version | Leverage Cli | Terraform | Terraform AWS provider | K8s EKS   |
|-------------------------------------------------------|--------------|-----------|------------------------|-----------|
| v1.8.1                                                | v1.7.2       | >= 1.1.9  | 3.27.x, 4.x.y          | 1.20-1.22 |
| v1.7.2                                                | v1.6.2       | >= 1.1.3  | 3.27.x, 4.x.y          | 1.17-1.19 |
| ~~v1.3.73~~                                           | v1.2.0       | 1.0.x     | 3.27.x                 | 1.17      |
| ~~v1.3.25~~                                           | v1.0.10      | 0.14.x    | 3.27.x                 | 1.17      |

Releases which are ~~crossed out~~ _should_ work, but are unlikely to get security or other fixes.
We suggest they should be upgraded soon.

## Release Schedule

This project does not follow the **Terraform** or other release schedule. Leverage aims to
provide a reliable deployment and operations experience for the [Binbash Leverage™ Reference Architecture
for AWS](https://leverage.binbash.com.ar/how-it-works/ref-architecture/), and typically releases about a quarter after 
the corresponding Terraform release. This time allows for the Terraform project to resolve any issues introduced 
by the new version and ensures that we can support the latest features.

## Read more

!!! info "Reference links"
    Consider the following extra links as reference:
    
    - :blue_book: [Hashicorp Terraform releases](https://github.com/hashicorp/terraform/releases)
    - :orange_book: [Amazon EKS Kubernetes release calendar](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html#kubernetes-release-calendar)
    - :orange_book: [Amazon EKS Kubernetes versions - Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)



