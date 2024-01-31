
# Leverage Releases & Versioning

binbash Leverage™ and its components intends to be backward compatible, but due to the complex ecosystems of tools we
manage this is not always possible.

It is always recommended using the latest version of the [Leverage CLI](https://pypi.org/project/leverage/) with the latest versions of the
[Reference Architecture for AWS](https://github.com/binbashar/le-tf-infra-aws/releases). In case that's
not possible we always recommend pinning versions to favor stability and doing controlled updates
component by component based on the below presented compatibility matrix table.

## Compatibility Matrix

If you need to know which Leverage CLI versions are compatible with which Leverage Toolbox Docker Images please refer to the [Release Notes](https://github.com/binbashar/leverage/releases). Just look for the section called "Version Compatibility". Bear in mind though that, at the moment, we do not include a full compatibility table there but at least you should be able to find out what's the Toolbox Image that was used for a given release.

If you are looking for the versions of the software included in the Toolbox Docker Image then go instead to [the release notes of that repo](https://github.com/binbashar/le-docker-leverage-toolbox/releases) instead.

## Release Schedule

This project does not follow the **Terraform** or other release schedule. Leverage aims to
provide a reliable deployment and operations experience for the [binbash Leverage™ Reference Architecture
for AWS](https://leverage.binbash.co/how-it-works/ref-architecture/), and typically releases about a quarter after
the corresponding Terraform release. This time allows for the Terraform project to resolve any issues introduced
by the new version and ensures that we can support the latest features.

## Read more

!!! info "Reference links"
    Consider the following extra links as reference:

    - :blue_book: [Hashicorp Terraform releases](https://github.com/hashicorp/terraform/releases)
    - :orange_book: [Amazon EKS Kubernetes release calendar](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html#kubernetes-release-calendar)
    - :orange_book: [Amazon EKS Kubernetes versions - Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)
