# Identity and Access Management (IAM) Layer

## Summary
Having this [official AWS resource](https://d0.awsstatic.com/aws-answers/AWS_Multi_Account_Security_Strategy.pdf) 
as reference  we've define a security account structure for managing multiple accounts.

!!! tip "User Management Definitions ![aws-service](../../assets/images/icons/aws-emojipack/General_AWScloud.png){: style="width:30px"} ![aws-service](../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_IAM.png){: style="width:15px"}" 
    *   [x] IAM users will strictly be created and centralized in the Security account (member accounts IAM Users could be exceptionally created for very specific tools that still don’t support IAM roles for cross-account auth). 
    *   [x] All access to resources within the Client organization will be assigned via policy documents attached to IAM roles or groups.
    *   [x] All IAM roles and groups will have the least privileges required to properly work.
    *   [x] IAM AWS and Customer managed policies will be defined, inline policies will be avoided whenever possible.
    *   [x] All user management will be maintained as code and will reside in the DevOps repository.
    *   [x] All users will have MFA enabled whenever possible (VPN and AWS Web Console).
    *   [x] Root user credentials will be rotated and secured. MFA for root will be enabled. 
    *   [x] IAM Access Keys for root will be disabled.
    *   [x] IAM root access will be monitored via CloudWatch Alerts.

!!! info "Why multi account IAM strategy?"
    Creating a security relationship between accounts makes it even easier for companies to assess the security 
    of AWS-based deployments, centralize security monitoring and management, manage identity and access, and provide 
    audit and compliance monitoring services

![leverage-aws-iam](../../assets/images/diagrams/aws-iam.png "Leverage"){: style="width:600px"}
<figcaption>**Figure:** AWS Organization Security account structure for managing multiple accounts (just as reference).</figcaption>

## IAM Groups & Roles definition 

**AWS Org member accounts IAM groups :**

<table>
  <tr>
   <td rowspan="2" ><strong>Account Name</strong>
   </td>
   <td colspan="4" >AWS Org Member Accounts <strong>IAM Groups</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Admin</strong>
   </td>
   <td><strong>Auditor</strong>
   </td>
   <td><strong>DevOps</strong>
   </td>
   <td><strong>DeployMaster</strong>
   </td>
  </tr>
  <tr>
   <td><strong>project-root</strong>
   </td>
   <td>x
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td><strong>project-security</strong>
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
  </tr>
</table>

**AWS Org member accounts IAM roles :**


<table>
  <tr>
   <td rowspan="2" ><strong>Account Name</strong>
   </td>
   <td colspan="5" >AWS Org Member Accounts <strong>IAM Roles</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Admin</strong>
   </td>
   <td><strong>Auditor</strong>
   </td>
   <td><strong>DevOps</strong>
   </td>
   <td><strong>DeployMaster</strong>
   </td>
   <td><strong>OrganizationAccountAccessRole</strong>
   </td>
  </tr>
  <tr>
   <td><strong>project-root</strong>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>x
   </td>
  </tr>
  <tr>
   <td><strong>project-security</strong>
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>
   </td>
   <td>x
   </td>
  </tr>
  <tr>
   <td><strong>project-shared</strong>
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
  </tr>
  <tr>
   <td><strong>project-legacy</strong>
   </td>
   <td>
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>
   </td>
   <td>x
   </td>
  </tr>
  <tr>
   <td><strong>project-apps-devstg</strong>
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
  </tr>
  <tr>
   <td><strong>project-apps-prd</strong>
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
   <td>x
   </td>
  </tr>
</table>