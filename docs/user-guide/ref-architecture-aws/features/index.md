![binbash-logo](/assets/images/logos/binbash-leverage-header.png "binbash"){: style="width:800px"}

# Features

## Overview
This reference architecture supports a growing number of AWS services. This section lists all of them and goes through each in depth.

!!! check "Governance | AWS Organizations"
    - [x] [Overview](organization/overview.md)
    - [x] [Configuration](organization/configuration.md)
    - [x] [Invite pre-exiting accounts to AWS Organizations](organization/legacy-accounts.md)

!!! check "Identity Management"
    - [x] [GPG Keys](identities/gpg.md)
    - [x] [Identities](identities/identities.md)
    - [x] [AWS Credentials](identities/credentials.md)
    - [x] [Hashicorp Vault Credentials](identities/credentials-vault.md)

!!! check "Single Sign-On (SSO)"
    - [x] [AWS SSO + Jumpcloud IdP](sso/overview.md)

!!! check "Cost Monitoring & Optimization"
    - [x] [Costs](costs/costs.md)

!!! check "Security"
    - [X] [Security Services](security/overview.md)
    - [X] [VPN | Pritunl](security/vpn.md)

!!! check "Networking | VPC, TGW, NFW, DNS and NACLs"
    - [x] [VPC Addressing](network/vpc-addressing.md)
    - [x] [VPC Peering](network/vpc-peering.md)
    - [x] [DNS](network/dns.md)

!!! check "Secrets Management"
    - [X] [Secrets](secrets/secrets.md)

!!! check "Compute"
    - [x] [Compute](compute/overview.md)
    - [x] [K8s EKS](compute/k8s-eks.md)
    - [x] [K8s Kops](compute/k8s-kops.md)
    - [x] [Serverless](compute/serverless.md)

!!! check "Databases"
    - [x] [Databases](database/database.md)
    - [x] [RDS MySql](database/mysql.md)
    - [x] [RDS Postgres](database/postgres.md)

!!! check "Storage"
    - [x] [Storage](storage/storage.md)

!!! check "Content Delivery Network (CDN)"
    - [x] [AWS CloudFront](cdn/cdn.md)

!!! check "CI/CD (Continuous Integration / Continuous Delivery)"
    - [x] [ArgoCD](ci-cd/argocd.md)
    - [x] [Jenkins & ArgoCD](ci-cd/jenkins-argocd.md)
    - [x] [Jenkins & Spinnaker](ci-cd/jenkins-spinnaker.md)

!!! check "Monitoring | Metrics, Logs, APM and Tracing"
    - [x] [Monitoring](monitoring/monitoring.md)
    - [x] [Metrics](monitoring/metrics.md)
    - [x] [Logs](monitoring/logs.md)
    - [x] [Tracing](monitoring/tracing.md)
    - [x] [APM](monitoring/apm.md)

!!! check "Reliability"
    - [X] [Bakcups](reliability/backups.md)
    - [x] [Health-Checks](./)
    - [X] [Disaster Recovery](reliability/dr.md)
