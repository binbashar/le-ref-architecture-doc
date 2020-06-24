# Route53 DNS hosted zones 

!!! info "![aws-service](../../assets/images/icons/aws-emojipack/General_AWScloud.png){: style="width:30px"} ![aws-service](../../assets/images/icons/aws-emojipack/NetworkingContentDelivery_AmazonRoute53.png){: style="width:20px"} Route53 Considerations"
     - [x] **Route53** private hosted zone will have associations with VPCs on different AWS organization accounts
     - [x] **Route53** should ideally be hosted in the Shared account, although sometimes Route53 is already deployed in a Legacy
        account where it can be imported and fully supported as code.
