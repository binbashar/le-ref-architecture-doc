# Credentials

## Overview
Access to EKS is usually achieved via IAM roles. These could be either custom IAM roles that you define, or SSO roles that AWS takes care of creating and managing.

## Configuration
Granting different kinds of access to IAM roles can be done as shown [here](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks/cluster/locals.tf#L33-L60) where you can define classic IAM roles or SSO roles. Note however that, since the latter are managed by AWS SSO, they could change if they are recreated or reassigned.

Now, even though granting access to roles is the preferred way, keep in mind that that is not the only way you can use. You can also grant access [to specific users](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks/cluster/locals.tf#L18-L29) or [to specific accounts](https://github.com/binbashar/le-tf-infra-aws/blob/master/apps-devstg/us-east-1/k8s-eks/cluster/locals.tf#L10-L14).
