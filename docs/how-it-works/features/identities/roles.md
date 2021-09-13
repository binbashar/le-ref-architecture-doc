# IAM roles

!!! info "What are AWS IAM Roles? ![aws-service](../../../assets/images/icons/aws-emojipack/General_AWScloud.png){: style="width:30px"} ![aws-service](../../../assets/images/icons/aws-emojipack/SecurityIdentityCompliance_IAM.png){: style="width:15px"}"
    For the Leverage AWS Reference Architecture we heavily depend on **AWS IAM roles**, which is a standalone IAM entity 
    that:
    
     * Allows you to attach **IAM policies** to it, 
     * Specify which other **IAM entities** to trust, and then 
     * Those other IAM entities can assume the IAM role to be temporarily get access to the permissions in those IAM 
       policies. 
       
       
!!! tip "The two most common use cases for IAM roles are"
    * [x] **Service roles:**
    Whereas an IAM user allows a human being to access AWS resources, one of the most common use cases for an IAM 
    role is to allow a service—e.g., one of your applications, a CI server, or an AWS service—to access specific 
    resources in your AWS account. For example, you could create an IAM role that gives access to a specific S3 bucket 
    and allow that role to be assumed by one of your EC2 instances or Lambda functions. The code running on that AWS compute
    service will then be able to access that S3 bucket (or any other service you granted through this IAM roles) without you
    having to manually copy AWS credentials (i.e., access keys) onto that instance.
    * [x] **Cross account access:**
    Allow to grant an IAM entity in one AWS account access to specific resources in another AWS account. For example, if you
    have an IAM user in AWS account A, then by default, that IAM user cannot access anything in AWS account B. However, you
    could create an IAM role in account B that gives access to a specific S3 bucket (or any necessary AWS services) in 
    AWS account B and allow that role to be assumed by an IAM user in account A. That IAM user will then be able to access
    the contents of the S3 bucket by assuming the IAM role in account B. This ability to assume IAM roles across different 
    AWS accounts is the critical glue that truly makes a multi AWS account structure possible.

## How IAM roles work?

![leverage-aws-iam-roles](../../../assets/images/diagrams/aws-iam-role-cross-account.png "Leverage"){: style="width:600px"}

<figcaption style="font-size:15px">
<b>Figure:</b> Example of AWS cross-account AWS access.
(Source: Kai Zhao, 
<a href="https://aws.amazon.com/blogs/security/aws-cloudtrail-now-tracks-cross-account-activity-to-its-origin/">
"AWS CloudTrail Now Tracks Cross-Account Activity to Its Origin"</a>,
AWS Security Blog, accessed November 17th 2020).
</figcaption>

---

!!! info "Main IAM Roles related entities"
    ### IAM policies
    Just as you can attach IAM policies to an IAM user and IAM group, you can attach IAM policies to an IAM role.
    ### Trust policy
    You must define a trust policy for each IAM role, which is a JSON document (very similar to an IAM policy) that 
    specifies who can assume this IAM role. For example, we present below a trust policy that allows this IAM role to be 
    assumed by an IAM user named John in AWS account 111111111111:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {"AWS": "arn:aws:iam::111111111111:user/John"}
        }
      ]
    }
    ``` 
    Note that a trust policy alone does NOT automatically give John permissions to assume this IAM role. 
    Cross-account access always requires permissions in both accounts (2 way authorization). So, if John is in AWS account
    111111111111 and you want him to have access to an IAM role called `DevOps` in account B ID 222222222222, then you need
    to configure permissions in both accounts: 
    1. In account 222222222222, the `DevOps` IAM role must have a trust policy that gives `sts:AssumeRole` permissions to 
    AWS account A ID 111111111111 (as shown above).
    2. 2nd, in account A 111111111111, you also need to attach an IAM policy to John’s IAM user that allows him to assume 
    the `DevOps` IAM role, which might look like this:
    
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Resource": "arn:aws:iam::222222222222:role/DevOps"
        }
      ]
    }
    ```

## Assuming an AWS IAM role

!!! summary "How does it work?" 
    IAM roles do not have a user name, password, or permanent access keys. To use an IAM role, you must assume it by 
    making an `AssumeRole` API call (vía [SDKs API](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html), 
    [CLI](https://docs.aws.amazon.com/cli/latest/reference/sts/assume-role.html) or 
    [Web Console](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html), which will
    return temporary access keys you can use in follow-up API calls to authenticate as the IAM role. The temporary 
    access keys will be valid for 1-12 hours (depending on your current validity expiration config), after which you
    must call `AssumeRole` again to fetch new temporary keys. Note that to make the `AssumeRole` API call, you must
    first authenticate to AWS using some other mechanism. 

For example, for an IAM user to assume an IAM role, the workflow looks like this:
![leverage-aws-iam-roles](../../../assets/images/diagrams/aws-iam-role-assume.png "Leverage"){: style="width:900px"}

<figcaption style="font-size:15px">
<b>Figure:</b> Assuming an AWS IAM role.
(Source: Gruntwork.io, 
<a href="https://gruntwork.io/guides/foundations/how-to-configure-production-grade-aws-account-structure/#iam-roles">
"How to configure a production-grade AWS account structure using Gruntwork AWS Landing Zone"</a>,
Gruntwork.io Production deployment guides, accessed November 17th 2020).
</figcaption>

!!! example "Basic AssumeRole workflow"
    1. Authenticate using the IAM user’s permanent AWS access keys
    2. Make the AssumeRole API call
    3. AWS sends back temporary access keys
    4. You authenticate using those temporary access keys
    5. Now all of your subsequent API calls will be on behalf of the assumed IAM role, with access to whatever 
       permissions are attached to that role

!!! info "IAM roles and AWS services"
    Most AWS services have native support built-in for assuming IAM roles. 
    
    For example: 
    
    * You can associate an IAM role directly with an EC2 instance (instance profile), and that instance will 
    automatically assume the IAM role every few hours, making the temporary credentials available in EC2 instance metadata. 
    * Just about every AWS CLI and SDK tool knows how to read and periodically update temporary credentials from EC2 
    instance metadata, so in practice, as soon as you attach an IAM role to an EC2 instance, any code running on that 
    EC2 instance can automatically make API calls on behalf of that IAM role, with whatever permissions are attached to
    that role. This allows you to give code on your EC2 instances IAM permissions without having to manually figure out
    how to copy credentials (access keys) onto that instance. 
    * The same strategy works with many other AWS services: e.g., you use IAM roles as a secure way to give your Lambda
     functions, ECS services, Step Functions, and many other AWS services permissions to access specific resources in 
     your AWS account.

## Read more

!!! info "AWS reference links"
    Consider the following AWS official links as reference:
        
    - :orange_book: [**AWS Identities | Roles terms and concepts**](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_terms-and-concepts.html)
    - :orange_book: [**AWS Identities | Common scenarios**](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_common-scenarios.html)