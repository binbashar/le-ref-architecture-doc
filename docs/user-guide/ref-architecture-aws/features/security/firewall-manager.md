# Firewall Manager

![Firewall Manager Service](/assets/images/diagrams/aws-fms.png)

## Use Cases

- [x] **Network Firewall rules**: Security administrators will be able to deploy firewall rules for AWS Network Firewall to control traffic leaving and entering your network across accounts and Amazon VPCs, from the Security account.
- [x] **WAF & WAF v2**: Your security administrators will able to deploy WAF and WAF v2 rules, and Managed rules for WAF to be used on Application Load Balancers, API Gateways and Amazon CloudFront distributions.
- [x] **Route 53 Resolver DNS Firewall rules**: Deploy Route 53 Resolver DNS Firewall rules from the Security account to enforce firewall rules across your organization.
- [x] **Audit Security Groups**: You can create policies to set guardrails that define what security groups are allowed/disallowed across your VPCs. AWS Firewall Manager continuously monitors security groups to detect overly permissive rules, and helps improve firewall posture. You can get notifications of accounts and resources that are non-compliant or allow AWS Firewall Manager to take action directly through auto-remediation.
- [x] **Security Groups**: Use AWS Firewall Manager to create a common primary security group across your EC2 instances in your VPCs.

### Read More
- [x] [AWS Firewall Manager](https://aws.amazon.com/firewall-manager/)
