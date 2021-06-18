# Infrastructure as Code (IaC) library modules

## **Open Source Modules Repos**

| Category              | URLs                                                                                |
|-----------------------|-------------------------------------------------------------------------------------|
| Ansible Galaxy Roles  | [bb-leverage-ansible-roles-list](https://github.com/topics/bb-le-mod-ansible-role)  |
| Dockerfiles           | [bb-leverage-dockerfiles-list](https://github.com/topics/bb-le-mod-docker)          |
| Helm Charts           | [bb-leverage-helm-charts-list](https://github.com/topics/bb-le-mod-helm)            |
| Jenkinsfiles Library  | [bb-leverage-jenkinsfiles-lib](https://github.com/topics/bb-le-mod-jenkins)         |
| Terraform Modules     | [bb-leverage-terraform-modules-list](https://github.com/topics/bb-le-mod-terraform) |


## **Open Source + Private Modules Repos (via GitHub Teams)**

| Repositories                                                                                                           | Details                                                                                                                   |
|------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| [Reference Architecture](https://github.com/orgs/binbashar/teams/leverage-ref-architecture-aws-dev/repositories)       | Most of the AWS resources are here, divided by account.                                                                   |
| [Dockerfiles](https://github.com/orgs/binbashar/teams/leverage-project-docker-dev/repositories)                        | These are Terraform module we created/imported to build reusable resources / stacks.                                      |
| [Ansible Playbooks & Roles](https://github.com/orgs/binbashar/teams/leverage-project-ansible-dev/repositories)         | Playbooks we use for provisioning servers such as Jenkins, Spinnaker, Vault, and so on.                                   |
| [Jenkins Modules](https://github.com/orgs/binbashar/teams/leverage-project-jenkins-dev/repositories)                   | Module we use in our Jenkins pipelines to perform repeated tasks such as posting to Slack, interacting with AWS CLI, etc. |
| [Helm Charts](https://github.com/orgs/binbashar/teams/leverage-project-helm-dev/repositories)                          | Complementary Jenkins pipelines to clean docker images, unseal Vault, and more. Also SecOps jobs can be found here.       |
| [Terraform Modules](https://github.com/orgs/binbashar/teams/leverage-project-terraform-dev/repositories)               | Jenkins pipelines, docker images, and other resources used for load testing.                                              |