# CDN 

!!! quote "![leverage-aws-ec2](../../../assets/images/icons/aws-emojipack/NetworkingContentDelivery_AmazonCloudFront.png "Leverage"){: style="width:20px"} AWS Cloud Front"
    [**Amazon CloudFront**](https://aws.amazon.com/cloudfront/) is a fast content delivery network (CDN) service that securely delivers data, videos, 
    applications, and APIs to customers globally with low latency, high transfer speeds, all within a developer-friendly
    environment. CloudFront is integrated with AWS – both physical locations that are directly connected to the AWS
    global infrastructure, as well as other AWS services. CloudFront works seamlessly with services including AWS
    Shield for DDoS mitigation, 
    [Amazon S3, Elastic Load Balancing, API Gateway or Amazon EC2 as origins](https://docs.aws.amazon.com/cloudfront/latest/APIReference/API_Origin.html)
    for your applications, and Lambda@Edge to run custom code closer to customers’ users and to customize the user
    experience. Lastly, if you use AWS origins such as Amazon S3, Amazon EC2 or Elastic Load Balancing, you don’t pay 
    for any data transferred between these services and CloudFront.
    
## Load Balancer (ALB | NLB) & S3 Cloudfront Origins 

![leverage-aws-cloudfront](../../../assets/images/diagrams/aws-cloudfront-acm-elb-s3.png "Leverage"){: style="width:950px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS CloudFront with ELB and S3 as origin diagram.
(Source: Lee Atkinson, 
<a href="https://aws.amazon.com/blogs/security/how-to-help-achieve-mobile-app-transport-security-compliance-by-using-amazon-cloudfront-and-aws-certificate-manager/">
"How to Help Achieve Mobile App Transport Security (ATS) Compliance by Using Amazon CloudFront and AWS Certificate Manager"</a>,
AWS Security Blog, accessed November 17th 2020).
</figcaption>

## API Gateway Cloudfront Origins 

![leverage-aws-cloudfront](../../../assets/images/diagrams/aws-cloudfront-api-gw.png "Leverage"){: style="width:950px"}
<figcaption style="font-size:15px">
<b>Figure:</b> AWS CloudFront with API Gateway as origin diagram.
(Source: AWS, 
<a href="https://aws.amazon.com/solutions/implementations/serverless-image-handler/">
"AWS Solutions Library, AWS Solutions Implementations Serverless Image Handler"</a>,
AWS Solutions Library Solutions Implementations, accessed November 17th 2020).
</figcaption>
