# Cost Estmation & Optimization

## Opportunity to optimize resources

!!! tip "![leverage-aws-ec2](../../assets/images/icons/aws-emojipack/Compute_AmazonEC2.png "Leverage"){: style="width:20px"} Compute"
    * Usage of reserved EC2 instances for stable workloads (AWS Cost Explorer Reserved Optimization | Compute 
    Optimizer - get a -$ of up to 42% vs On-Demand)
    * Usage of Spot EC2 instances for fault-tolerant workloads (-$ by up to 90%).
    * Use ASG to allow your EC2 fleet to +/- based on demand.
    * Id EC2 w/ low-utiliz and -$ by stop / rightsize them.
    * Compute Savings Plans to reduce EC2, Fargate and Lambda $ (Compute Savings Plans OK regardless of EC2 family,
     size, AZ, reg, OS or tenancy, OK for Fargate / Lambda too).

!!! tip "![leverage-aws-rds](../../assets/images/icons/aws-emojipack/Database_AmazonRDS.png "Leverage"){: style="width:20px"} Databases"
    * Usage of reserved RDS instances for stable workload databases.

!!! tip "![leverage-aws-cw](../../assets/images/icons/aws-emojipack/ManagementTools_AmazonCloudWatch.png "Leverage"){: style="width:20px"} Monitoring & Automation"
    * AWS billing alarms + AWS Budget (forecasted account cost / RI Coverage) Notifications to Slack
    * Activate AWS Trusted Advisor cost related results
        * Id EBS w/ low-utiliz and -$ by snapshotting and then rm them
        * Check underutilized EBS to be possibly shrunk or removed.
        * Networking -> deleting idle LB -> Use LB check w/ RequestCount of > 100 past 7d.
    * Setup Lambda nuke to automatically clean up AWS account resources.
    * Setup lambda scheduler for stop and start resources on AWS (EC2, ASG & RDS)

!!! tip "![leverage-aws-s3](../../assets/images/icons/aws-emojipack/Storage_AmazonS3.png "Leverage"){: style="width:20px"} Storage & Network Traffic"
    * Check S3 usage and -$ by leveraging lower $ storage tiers.
    * Use S3 Analytics, or automate mv for these objects into lower $ storage tier w/ Life Cycle Policies or w/ S3
    Intelligent-Tiering.
    * If DataTransferOut from EC2 to the public internet is significant $, consider implementing CloudFront.

## Consideration

!!! check "Reserved Instances" 
    * [x] :moneybag: Stable workloads will always run on reserved instances, the following calculation only considers 1yr. No Upfront mode,
    in which Client will not have to pay in advance but commits to this monthly usage and will be billed so, even if the
    instance type is not used. More aggressive Reservation strategies can be implemented to further reduce costs, these
    will have to be analyzed by business in conjunction with operations.


## Read more

!!! info "Reference links"
    Consider the following extra links as reference:
         
    - :orange_book: [AWS Ramp-Up Guide: Cost Management](https://d1.awsstatic.com/training-and-certification/ramp-up_guides/Ramp-Up_Guide_Cost_Management.pdf)
    - :orange_book: [How is the pricing benefit of a RI applied across an organization's consolidated bill?](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-ri-consolidated-billing/)
    - :books: [A Guide to Cloud Cost Optimization with HashiCorp Terraform](https://www.hashicorp.com/blog/a-guide-to-cloud-cost-optimization-with-hashicorp-terraform)
    - :books: [FinOps: How Cloud Finance Management Can Save Your Cloud Programme From Extinction](https://www.contino.io/insights/finops-cloud-finance-management)
