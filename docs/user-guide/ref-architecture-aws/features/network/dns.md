# Route53 DNS hosted zones

## How it works

!!! info "![aws-service](/assets/images/icons/aws-emojipack/General_AWScloud.png){: style="width:30px"} ![aws-service](/assets/images/icons/aws-emojipack/NetworkingContentDelivery_AmazonRoute53.png){: style="width:20px"} Route53 Considerations"
     - [x] **Route53** private hosted zone will have associations with VPCs on different AWS organization accounts
     - [x] **Route53** should ideally be hosted in the Shared account, although sometimes Route53 is already deployed in a Legacy
        account where it can be imported and fully supported as code.
     - [x] **Route53** [zero downtime migration](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-migrating.html) 
        (active-active hosted zones) is completely possible and achievable with Leverage terraform code    
        
![leverage-aws-dns](/assets/images/diagrams/aws-route53.png "Leverage"){: style="width:800px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Organization shared account Route53 DNS diagram.
(Source: Cristian Southall, 
<a href="https://abstractable.io/aws/2019/09/20/cloudformation-custom-resources.html">
"Using CloudFormation Custom Resources to Configure Route53 Aliases"</a>,
Abstractable.io Blog post, accessed November 18th 2020).
</figcaption>
    
## User guide

!!! done "pre-requisites"
    * :gear: Review & update [**configs**](/user-guide/ref-architecture-aws/configuration.md) 
    * :gear: Review & understand the [**workflow**](/user-guide/ref-architecture-aws/workflow.md) 


!!! example "Steps"
    1. **DNS** service has to be orchestrated from 
    [`/shared/global/base-dns`](https://github.com/binbashar/le-tf-infra-aws/tree/master/shared/global/base-dns) layer 
    following the standard [workflow](/user-guide/ref-architecture-aws/workflow.md)
        
### Migrated AWS Route53 Hosted Zones between AWS Accounts 

We'll need to setup the Route53 DNS service with an active-active config to avoid any type of service disruption and 
downtime. This would then allow the Name Servers of both AWS Accounts to be added to your domain provider
(eg: [namecheap.com](https://www.namecheap.com/)) and have for example: 

* 4 x ns (`project-legacy` Route53 Account) 
* 4 x ns (`project-shared` Route53 Account) 

After the records have propagated and everything looks OK we could remove the `project-legacy` Route53 ns from your
domain provider (eg: [namecheap.com](https://www.namecheap.com/)) and leave only the of `project-shared` ones.

This [official Migrating a hosted zone to a different AWS account - Amazon Route 53 article](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-migrating.html) 
explains this procedure step by step:

!!! example "AWS Route53 hosted zone migration steps" 
    1. Create records in the new hosted zone (bb-shared)
    2. Compare records in the old and new hosted zones (bb-legacy)
    3. Update the domain registration to use name servers for the new hosted zone (NIC updated to use both 
    bb-legacy + bb-shared)
    4. Wait for DNS resolvers to start using the new hosted zone
    5. (Optional) delete the old hosted zone (bb-legacy), remember you'll need to delete the ns delegation 
    records from your domain registration (NIC) too.
