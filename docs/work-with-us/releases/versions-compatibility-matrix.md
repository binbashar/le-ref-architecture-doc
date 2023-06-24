
# Leverage Releases & Versioning

binbash Leverage™ and its components intends to be backward compatible, but due to the complex ecosystems of tools we
manage this is not always possible.

It is always recommended using the latest version of the [Leverage CLI](https://pypi.org/project/leverage/) with the latest versions of the
[Reference Architecture for AWS](https://github.com/binbashar/le-tf-infra-aws/releases). In case that's
not possible we always recommend pinning versions to favor stability and doing controlled updates
component by component based on the below presented compatibility matrix table.

## Compatibility Matrix

<table>
  <tr>
    <th>Leverage Ref Arch version</th>
    <th>Leverage CLI</th>
    <th>Leverage Toolbox<br /><small>image</small><br /><small>version</small></th>
  </tr>

  <tr>
    <td rowspan="3">v1.12.0</td>
    <td rowspan="2">v1.9.x</td>
    <td>`binbash/leverage-toolbox`<br /> ==1.3.5-0.0.2</td>
  </tr>
  <tr>
    <td>`binbash/leverage-toolbox`<br /> ==1.2.7-0.1.1</td>
  </tr>
  <tr>
    <td>v1.8.x</td>
    <td>`binbash/leverage-toolbox`<br /> ==1.2.7-0.0.x</td>
  </tr>
  <tr>
    <td>v1.8.1</td>
    <td>v1.7.2</td>
    <td>`binbash/terraform-awscli-slim`<br /> >=1.1.9</td>
  </tr>
  <tr>
    <td>v1.7.2</td>
    <td>v1.6.2</td>
    <td>`binbash/terraform-awscli-slim`<br /> >=1.1.3</td>
  </tr>

</table>

Releases which are ~~crossed out~~ _should_ work, but are unlikely to get security or other fixes.
We suggest they should be upgraded soon.

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
