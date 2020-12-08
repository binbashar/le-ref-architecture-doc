# Route53 DNS hosted zones

!!! info "![aws-service](../../assets/images/icons/aws-emojipack/General_AWScloud.png){: style="width:30px"} ![aws-service](../../assets/images/icons/aws-emojipack/NetworkingContentDelivery_AmazonRoute53.png){: style="width:20px"} Route53 Considerations"
     - [x] **Route53** private hosted zone will have associations with VPCs on different AWS organization accounts
     - [x] **Route53** should ideally be hosted in the Shared account, although sometimes Route53 is already deployed in a Legacy
        account where it can be imported and fully supported as code.
     - [x] **Route53** [zero downtime migration](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-migrating.html) 
        (active-active hosted zones) is completely possible and achieviable with Leverage terraform code    
        
![leverage-aws-dns](../../assets/images/diagrams/aws-route53.png "Leverage"){: style="width:800px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS Organization shared account Route53 DNS diagram.
(Source: Cristian Southall, 
<a href="https://abstractable.io/aws/2019/09/20/cloudformation-custom-resources.html">
"Using CloudFormation Custom Resources to Configure Route53 Aliases"</a>,
Abstractable.io Blog post, accessed November 18th 2020).
</figcaption>