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

![leverage-aws-backup](../../assets/images/diagrams/aws-backup.png "Leverage"){: style="width:950px"}
<figcaption>**Figure:** [AWS Backup](https://aws.amazon.com/backup/) service diagram (just as reference).</figcaption>

## ![leverage-aws-s3](../../assets/images/icons/aws-emojipack/Storage_AmazonS3.png "Leverage"){: style="width:30px"} S3 bucket region replication
* ![leverage-aws-s3](../../assets/images/icons/aws-emojipack/Storage_AmazonS3_bucket.png "Leverage"){: style="width:20px"}
Buckets that hold data critical to business or to application operation can be replicated to another region almost
 synchronously. 
* ![leverage-aws-s3](../../assets/images/icons/aws-emojipack/Storage_AmazonS3_bucket.png "Leverage"){: style="width:20px"}
This can be setup on request to increase durability and along with database backup can constitute the base for a
 Business Continuity strategy.
