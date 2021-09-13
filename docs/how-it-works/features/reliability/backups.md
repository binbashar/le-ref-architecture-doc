# Backups

## AWS Backup

!!! quote "As defined by AWS"
    AWS Backup is a fully managed backup service that makes it easy to centralize and automate the backup of data across
    AWS services. Using AWS Backup, you can centrally configure backup policies and monitor backup activity for AWS
    resources, such as:
    
    * [x] Amazon **EBS volumes**, 
    * [x] Amazon **EC2 instances**, 
    * [x] Amazon **RDS databases**, 
    * [x] Amazon **DynamoDB tables**, 
    * [x] Amazon **EFS file systems**,
    * [x] and AWS **Storage Gateway volumes**. 
    
    AWS Backup automates and consolidates backup tasks previously performed service-by-service, removing the need to 
    create custom scripts and manual processes. 
    With just a few clicks in the AWS Backup console, you can create backup policies that automate backup schedules
    and retention management. AWS Backup provides a fully managed, policy-based backup solution, simplifying your
    backup management, enabling you to meet your business and regulatory backup compliance requirements.

![leverage-aws-backup](../../../assets/images/diagrams/aws-backup.png "Leverage"){: style="width:950px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Backup service diagram (just as reference).
(Source: AWS, 
<a href="https://aws.amazon.com/backup/">"AWS Backup - Centrally manage and automate backups across AWS services"</a>,
AWS Documentation, accessed November 18th 2020).
</figcaption>

## ![leverage-aws-s3](../../../assets/images/icons/aws-emojipack/Storage_AmazonS3.png "Leverage"){: style="width:30px"} S3 bucket region replication
* ![leverage-aws-s3](../../../assets/images/icons/aws-emojipack/Storage_AmazonS3_bucket.png "Leverage"){: style="width:20px"}
Buckets that hold data critical to business or to application operation can be replicated to another region almost
 synchronously. 
* ![leverage-aws-s3](../../../assets/images/icons/aws-emojipack/Storage_AmazonS3_bucket.png "Leverage"){: style="width:20px"}
This can be setup on request to increase durability and along with database backup can constitute the base for a
 Business Continuity strategy.

## Comparison of the backup and retention policies strategies

In this sub-section you'll find the resources to review and adjust your backup retention policies to 
adhere to compliance rules that govern your specific institutions regulations. This post is a summarised
write-up of how we approached this sensitive task, the alternatives we analysed and the recommended 
solutions we provided in order to meet the requirements. We hope it can be useful for others as well.

!!! info "Leverage Confluence Documentation"    
You'll find [**here**](https://binbash.atlassian.net/wiki/external/2055536653/OTdjZDZlNmI4NDE4NGQzMjg4ZWQzMzZkYjczMWM2NjA?atlOrigin=eyJpIjoiODRjZmQyNzQ2YjRlNDAzNTk4YTYyMzE0MDU1MjYyMWYiLCJwIjoiYyJ9)
a detailed comparison including the alternative product and solution types, pricing model, features, pros & cons.