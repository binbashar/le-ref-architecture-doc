
# Leverage Releases & Versioning

Binbash Leverage™ and its components intends to be backward compatible, but due to the complex ecosystems of tools we
manage this is not always possible.

It is always recommended using the latest version of the [Leverage cli](https://pypi.org/project/leverage/) with the latest versions of the
[Reference Architecture for AWS](https://github.com/binbashar/le-tf-infra-aws/releases). In case that's
not possible we always recommend pinning versions to favor stability and doing controlled updates
component by component based on the below presented compatibility matrix table.

## Compatibility Matrix

<table>
  <tr>
    <th>Leverage Ref Arch version</th>
    <th>Leverage CLI</th>
    <th>Leverage Toolbox<br /><small>image</small><br /><small>version</small></th>
    <th>Terraform</th>
    <th>AWS cli vesion</th>
    <th>Terraform AWS provider</th>
    <th>K8s EKS</th>
  </tr>
  <tr>
    <td rowspan="5">v1.11.0</td>
    <td rowspan="4">v1.9.x</td>
    <td>`binbash/leverage-toolbox`<br /> ==1.3.5-0.0.2</td>
    <td>1.3.5</td>
    <td>2.7.32</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.20-1.22</td>
  </tr>
  <tr>
    <td>`binbash/leverage-toolbox`<br /> ==1.2.7-0.1.1</td>
    <td>1.2.7</td>
    <td>2.7.32</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.20-1.22</td>
  </tr>
  <tr>
    <td>`binbash/leverage-toolbox`<br /> ==1.3.5-0.0.x</td>
    <td>1.3.5</td>
    <td>2.7.32</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.20-1.22</td>
  </tr>
  <tr>
    <td>`binbash/leverage-toolbox`<br /> ==1.2.7-0.1.x</td>
    <td>1.2.7</td>
    <td>2.7.32</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.20-1.22</td>
  </tr>
  <tr>
    <td>v1.8.x</td>
    <td>`binbash/leverage-toolbox`<br /> ==1.2.7-0.0.x</td>
    <td>1.2.7</td>
    <td>2.4.7</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.20-1.22</td>
  </tr>
  <tr>
    <td>v1.8.1</td>
    <td>v1.7.2</td>
    <td>`binbash/terraform-awscli-slim`<br /> >=1.1.9</td>
    <td>1.1.9</td>
    <td>2.4.7</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.20-1.22</td>
  </tr>
  <tr>
    <td>v1.7.2</td>
    <td>v1.6.2</td>
    <td>`binbash/terraform-awscli-slim`<br /> >=1.1.3</td>
    <td>1.1.3</td>
    <td>2.4.7</td>
    <td>3.27.x, 4.x.y</td>
    <td>1.17-1.19</td>
  </tr>
  <tr>
    <td><del>v1.3.73</del></td>
    <td>v1.2.0</td>
    <td>`binbash/terraform-awscli-slim`<br /> >=1.0.x</td>
    <td>1.0.x</td>
    <td>1.19.67</td>
    <td>3.27.x</td>
    <td>1.17</td>
  </tr>
  <tr>
    <td><del>v1.3.25</del></td>
    <td>v1.0.10</td>
    <td>`binbash/terraform-awscli-slim`<br /> >=0.14.x</td>
    <td>0.14.x</td>
    <td>1.19.67</td>
    <td>3.27.x</td>
    <td>1.17</td>
  </tr>
</table>

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
