---
template: overrides/main.html
---

![binbash-logo](./assets/images/logos/binbash-leverage-header.png "Binbash"){: style="width:800px"}

# About Leverage

!!! important "What's Leverage?"
    Our focus is on creating reusable, high quality 
    ![leverage-aws](./assets/images/icons/aws-emojipack/General_AWScloud.png "AWS"){: style="width:30px"} 
    Cloud Infrastructure code, through our core components:

    - [x] [**Reference Architecture for AWS**](how-it-works/ref-architecture/index.md)
    - [x] [**Infrastructure as Code (IaC) Library**](how-it-works/infra-as-code-library/infra-as-code-library.md)
    - [x] [**Leverage CLI**](https://github.com/binbashar/leverage)

    Because all the code and modules are already built, we can get you up and running **up to 10x faster** :rocket: 
    than a consulting company (:white_check_mark: *typically in just a few weeks!*). On top of code that is thoroughly 
    documented, tested, and has been proven in production at dozens of other project deployments.

!!! important "Why Leverage?"
    If you implement our **Reference Architecture for AWS** and the 
    **Infrastructure as Code (IaC) Library** via Leverage CLI , you will get your entire Cloud Native 
    Application Infra in few weeks.

    *Implement Leverage yourself or we can deploy it for you!* :muscle:

        
    :books: **Read More:** 

    - [Why our stack?](./how-it-works/ref-architecture/general-concepts/why-tech-stack.md)
    - [Why Leverage?](./work-with-us/faqs/#why-leverage)

!!! important "Core Features"
    - [x] [**Reference Architecture**](how-it-works/infra-as-code-library/infra-as-code-library.md):
    Designed under optimal configs for the most popular modern web and mobile applications needs.
    Its design is fully based on the
    [**AWS Well Architected Framework**](https://leverage.binbash.com.ar/support/#aws-well-architected-review).

    - [x] [**Infrastructure as Code (IaC) Library**](how-it-works/ref-architecture/index.md):
        A collection of reusable, tested, production-ready E2E AWS Cloud infrastructure as code solutions, leveraged by
        modules written in: *Terraform, Ansible, Helm charts, Dockerfiles and Makefiles*.

    - [x] [**Leverage CLI**](https://github.com/binbashar/leverage): projects' command line tool.
    Provides the means to interact and deploy Leverage Reference Architecture on AWS and if needed
    it allows you to define custom tasks to run.

# Welcome
This is the documentation for the **Leverage Reference Architecture**.

It is built around the [AWS Well Architected Framework](https://aws.amazon.com/architecture/well-architected/)
, using a [Terraform](https://www.terraform.io/), [Ansible](https://www.ansible.com/) and [Helm](https://helm.sh/).

An its compose of the following 3 main repos:

- [x] [le-tf-infra-aws](https://github.com/binbashar/le-tf-infra-aws)
- [x] [le-tf-vault](https://github.com/binbashar/le-tf-vault)
- [x] [le-ansible-infra](https://github.com/binbashar/le-ansible-infra)

## Getting Started
:books: See [**First Steps**](./first-steps/introduction.md) for an introduction to our Reference
Architecture for AWS workflow through the complete deployment of a basic AWS Landing Zone.

:books: See [**How it works**](how-it-works/ref-architecture/index.md) for a whirlwind tour that will get you started.

:books: See [**User guide**](./user-guide/index.md) for a hands on help.