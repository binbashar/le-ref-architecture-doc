# Storage


## Overview
We will review all S3 buckets in the existing account to determine if it’s necessary to copy over to the new account, 
evaluate existing bucket policy and tightening permissions to be absolutely minimum required for users and applications.
As for EBS volumes, our recommendation is to create all encrypted by default. Overhead created by this process is negligible. 

##  ![leverage-aws-s3](../../../../assets/images/icons/aws-emojipack/Storage_AmazonS3.png "Leverage"){: style="width:30px"} S3 buckets

!!! important "Tech specs"
    * [x] **Encryption:** Yes (by default)
    * [x] **Object versioning:** TBD per bucket
    * [x] **Access logs enabled:** TBD per bucket
    * [x] **MFA delete:** Yes on critical buckets
    * [x] **Replication to another region:** TBD per bucket
    
| Storage class           | Designed for                                                                | Durability (designed for) | Availability (designed for)        | Availability Zones | Min storage duration | Min billable object size | Other considerations                                                                                                                                   |
|-------------------------|-----------------------------------------------------------------------------|---------------------------|------------------------------------|--------------------|----------------------|--------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| S3 Standard             | Frequently accessed data                                                    | 99.999999999%             | 99.99%                             | >= 3               | None                 | None                     | None                                                                                                                                                   |
| S3 Standard-IA          | Long-lived, infrequently accessed data                                      | 99.999999999%             | 99.9%                              | >= 3               | 30 days              | 128 KB                   | Per GB retrieval fees apply.                                                                                                                           |
| S3 Intelligent-Tiering  | Long-lived data with changing or unknown access patterns                    | 99.999999999%             | 99.9%                              | >= 3               | 30 days              | None                     | Monitoring and automation fees per object apply. No retrieval fees.                                                                                    |
| S3 One Zone-IA          | Long-lived, infrequently accessed, non-critical data                        | 99.999999999%             | 99.5%                              | 1                  | 30 days              | 128 KB                   | Per GB retrieval fees apply. Not resilient to the loss of the Availability Zone.                                                                       |
| S3 Glacier              | Long-term data archiving with retrieval times ranging from minutes to hours | 99.999999999%             | 99.99% (after you restore objects) | >= 3               | 90 days              | 40 KB                    | Per GB retrieval fees apply. You must first restore archived objects before you can access them. For more information, see Restoring archived objects. |
| S3 Glacier Deep Archive | Archiving rarely accessed data with a default retrieval time of 12 hours    | 99.999999999%             | 99.99% (after you restore objects) | >= 3               | 180 days             | 40 KB                    | Per GB retrieval fees apply. You must first restore archived objects before you can access them. For more information, see Restoring archived objects. |
| RRS (Not recommended)   | Frequently accessed, non-critical data                                      | 99.99%                    | 99.99%                             | >= 3               | None                 | None                     | None                                                                                                                                                   |

## ![leverage-aws-ebs](../../../../assets/images/icons/aws-emojipack/Storage_AmazonEBS.png "Leverage"){: style="width:25px"} EBS Volumes

!!! Important "Tech specs"
    * [x] **Backups:** Periodic EBS snapshots with retention policy
    * [x] **Encryption:** Yes (by default)
    * [x] **Type:** SSD (gp2) by default, Throughput Optimized HDD (st1) for some database workloads, if needed.

## Read more

!!! info "Reference links"
    Consider the following extra links as reference:
         
    - :orange_book: [Amazon S3 FAQs](https://aws.amazon.com/s3/faqs/)
    - :orange_book: [Amazon S3 storage classes - Developer Guide](https://docs.aws.amazon.com/AmazonS3/latest/dev/storage-class-intro.html)
    - :orange_book: [Amazon S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)
