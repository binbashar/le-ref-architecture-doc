# Audit | CloudTrail

AWS CloudTrail monitors and records account activity across your AWS infrastructure, giving you control over storage, analysis, and remediation actions.


![Cloudtrail Diagram](../../../assets/images/diagrams/aws-cloudtrail.svg)

!!! note ":bookmark_tabs: [Leverage Reference Architecture | Security Audit](https://github.com/binbashar/le-tf-infra-aws/tree/master/apps-prd/us-east-1/security-audit)"

**CloudTrail module**. Key elements:  

* Destination bucket
* KMS Key to files encrypt files
* Include global services
* Enable multi-regional trail


**S3 Bucket Module**. Key elements:

* Lifecycle rule
* Expiration

**KMS Key Module**. Key elements:

* Deletion Window
* Policy  
  *Grant permission to the rest of the accounts to use the key*

# Read More

* :cloud: [AWS Cloudtrail Overview](https://aws.amazon.com/cloudtrail/)
* :notebook: [Security Pillar - AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)