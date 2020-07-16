# Storage

We will review all S3 buckets in the existing account to determine if it’s necessary to copy over to the new account, 
evaluate existing bucket policy and tightening permissions to be absolutely minimum required for users and applications.
As for EBS volumes, our recommendation is to create all encrypted by default. Overhead created by this process is negligible. 

##  ![leverage-aws-s3](../../assets/images/icons/aws-emojipack/Storage_AmazonS3.png "Leverage"){: style="width:30px"} S3 buckets

!!! important "Tech specs"
    * [x] **Encryption:** Yes (by default)
    * [x] **Object versioning:** TBD per bucket
    * [x] **Access logs enabled:** TBD per bucket
    * [x] **MFA delete:** Yes on critical buckets
    * [x] **Replication to another region:** TBD per bucket

## ![leverage-aws-s3](../../assets/images/icons/aws-emojipack/Storage_AmazonEBS.png "Leverage"){: style="width:25px"} EBS Volumes

!!! Important "Tech specs"
    * [x] **Backups:** Periodic EBS snapshots with retention policy
    * [x] **Encryption:** Yes (by default)
    * [x] **Type:** SSD (gp2) by default, Throughput Optimized HDD (st1) for some database workloads, if needed.
