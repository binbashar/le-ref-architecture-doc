# AWS SSO

![leverage-aws-sso](/assets/images/diagrams/aws-sso.png "Leverage"){: style="width:750px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Organization with SSO diagram.
(Source: binbash Leverage,
"Leverage Reference Architecture components",
binbash Leverage Doc, accessed January 4th 2022).
</figcaption>

### SSO Strengths
- [x] 100% cloud-based
- [x] Secure directory services
- [x] Unified device management
- [x] SSO and user lifecycle management
- [x] Secure app and server authentication with cloud LDAP
- [x] Event logging, reporting, and monitoring

### SSO Groups
| Account / Groups | Administrators | DevOps | FinOps | SecurityAuditors |
|------------------|----------------|--------|--------|------------------|
| Management       | x              | x      | x      | x                |

!!! Info "Consideration"
        This definition could be fully customized based on the project specific needs

### SSO Permission Sets (w/ Account Associations)
| Account / Permission Sets | Administrator | DevOps | FinOps | SecurityAuditors |
|---------------------------|---------------|--------|--------|------------------|
| Management                | x             |        | x      |                  |
| Security                  | x             | x      |        | x                |
| Shared                    | x             | x      |        | x                |
| Network                   | x             | x      |        | x                |
| Apps-DevStg               | x             | x      |        | x                |
| Apps-Prd                  | x             | x      |        | x                |

!!! Info "Considerations"
     1. Developers could have their specific SSO Group + Permission Set policy association.
     2. This definition could be fully customized based on the project specific needs
