# AWS Security & Compliance Services

!!! danger "Security Directives"
    There will not be any instance port or service port open to general access, unless justified by business reasons, 
    and we’ll take alternative means of security to mitigate any possible risk.
    
    Every account will have a set of active services that will allow for administrative users (SecOps) to audit all 
    actions and track potentially dangerous behavior. All services will be enabled via IaC (Terraform or SDK and tracked
    in the proper git repo).

!!! important "AWS Managed Security Services"
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_IAM.png){: style="width:30px"}
        **AWS IAM Access Analyzer:** Generates comprehensive findings that identify resources policies for public or 
        cross-account accessibility, monitors and helps you refine permissions. Provides the highest levels of security assurance.
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_Config.png){: style="width:30px"}
        **AWS Config:** Tracks changes made to AWS resources over time, making possible to return to a previous state.
         Monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded
          configurations against desired compliance rule set. Adds accountability factor.
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_CloudTrail.png){: style="width:30px"}
        **AWS Cloudtrail:** Stores logs over all calls made to AWS APIs, coming from web console, command line or any
         other. Allowing us to monitor it via CW Dashboards and notifications.
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/NetworkingContentDelivery_AmazonVPC_flowlogs.png){: style="width:30px"}
        **AWS VPC Flow Logs:** Enables us to examine individual Network Interfaces logs, to address network issues and
         also monitor suspicious behavior.
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_AWSWAF.png){: style="width:30px"}
        **AWS Web Application Firewall:** Optional but if not used, it is recommended that a similar service is used,
         such as Cloudflare. When paired to an Application Load Balancer or Cloudfront distribution, it checks incoming
          requests to detect and block OWASP Top10 attacks, such as SQL injection, XSS and others. 
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_AmazonInspector.png){: style="width:30px"} 
        **AWS Inspector:**  Is an automated security assessment service that helps improve the security and compliance
         of infrastructure and applications deployed on AWS. 
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_AmazonGuardDuty.png){: style="width:30px"}
        **AWS Guard Duty:** Is a managed [threat](https://youtu.be/czsuZXQvD8E?t=947) detection service that
         continuously monitors for malicious or unauthorized behavior to help you protect your AWS accounts and
          workloads. Detects unusual API calls or potentially unauthorized deployments (possible account compromise)
           and potentially compromised instances or reconnaissance by attackers.
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/ManagementTools_AmazonCloudWatch.png){: style="width:30px"}
        **AWS Security Logs** Other access logs from client-facing resources will be stored in the Security account.
    - [x] ![aws-service](../../../assets/images/icons/aws-emojipack/AWS_Firewall_Manager.png){: style="width:30px"}
        **AWS Firewall Manager** Is a security management service which allows you to centrally configure and manage firewall rules across your accounts and applications in AWS Organizations. This service lets you build firewall rules, create security policies, and enforce them in a consistent, hierarchical manner across your entire infrastructure, from a central administrator account.

# Security Layer

## AWS Firewall Manager

!!! summary "Scenarios"
    - [x] **Network Firewall rules**: Security administrators will be able to deploy firewall rules for AWS Network Firewall to control traffic leaving and entering your network across accounts and Amazon VPCs, from the Security account.
    - [x] **WAF & WAF v2**: Your security administrators will able to deploy WAF and WAF v2 rules, and Managed rules for WAF to be used on Application Load Balancers, API Gateways and Amazon CloudFront distributions.
    - [x] **Route 53 Resolver DNS Firewall rules**: Deploy Route 53 Resolver DNS Firewall rules from the Security account to enforce firewall rules across your organization.
    - [x] **Audit Security Groups**: You can create policies to set guardrails that define what security groups are allowed/disallowed across your VPCs. AWS Firewall Manager continuously monitors security groups to detect overly permissive rules, and helps improve firewall posture. You can get notifications of accounts and resources that are non-compliant or allow AWS Firewall Manager to take action directly through auto-remediation.
    - [x] **Security Groups**: Use AWS Firewall Manager to create a common primary security group across your EC2 instances in your VPCs.

![Firewall Manager Service](../../../assets/images/diagrams/aws-fms.png)