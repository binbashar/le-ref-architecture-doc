# AWS SSM

## Introduction

Welcome to the comprehensive guide for using the AWS Systems Manager (SSM) through the Leverage framework integrated
with AWS Single Sign-On (SSO). This documentation is designed to facilitate a smooth and secure setup for managing EC2
instances, leveraging advanced SSO capabilities for enhanced security and efficiency.

## Overview

The AWS Systems Manager (SSM) provides a powerful interface for managing cloud resources. By initiating an SSM session
using the leverage aws sso configure command, you can securely configure and manage your instances using single sign-on
credentials. This integration simplifies the authentication process and enhances security, making it an essential tool
for administrators and operations teams.

## Key features

* _SSO Integration:_ Utilize the Leverage framework to integrate AWS SSO, simplifying the login process and reducing the
  need for multiple credentials.
* _Interactive Command Sessions:_ The start-session command requires the Session Manager plugin and is interactive,
  ensuring secure and direct command execution.

## Command

This command configures your AWS CLI to use SSO for authentication, streamlining access management across your AWS
resources.

```bash
leverage aws sso configure
```

## Advantages of Terminal Access

While it is possible to connect to SSM through a web browser, using the terminal offers several benefits:

* _Direct Shell Access:_ Provides real-time, interactive management capabilities.
* _Operational Efficiency:_ Enhances workflows by allowing quick and direct command executions.

## Security and Management Benefits

Adopting this integrated approach offers significant advantages:

* _Increased Security:_ By using SSO, the system minimizes risks associated with multiple credential sets and potential
  unauthorized access.
* _Efficient Management:_ Centralizes control over AWS resources, reducing complexity and improving oversight.

## Getting Started

This guide is structured into detailed sections that cover:

* _Pre-requisites:_ Requirements needed before you begin.
* _Variable Initialization:_ Setup and explanation of the necessary variables.
* _Authentication via SSO:_ How to authenticate using the leverage aws sso configure command.
* _Exporting AWS Credentials:_ Guidelines for correctly exporting AWS credentials for session management.
* _Session Handling:_ Detailed instructions for starting, managing, and terminating SSM sessions.

Each section aims to provide step-by-step instructions to ensure you are well-prepared to use the AWS SSM configuration
tool effectively.

Navigate through the subsections for detailed information relevant to each stage of the setup process and refer back to
this guide as needed to enhance your experience and utilization of AWS SSM capabilities.

## Prerequisites

Before you begin, ensure that you have the necessary tools and permissions set up:

* _SSM Plugin for AWS CLI:_ Crucial for starting SSM sessions from the command line. Install it by following the steps
  on
  the [AWS Documentation site](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html).

## Getting Started Guide

### Step 1: Initialize Environment Variables

Set up all necessary variables used throughout the session. These include directories, profiles, and configuration
settings essential for the script’s functionality.

```bash
PROJECT_SHORT="bb"
FOLDER="le-tf-infra-aws"
COMMON_CONFIG_FILE="$FOLDER/config/common.tfvars"
REPO_URL="git@github.com:binbashar/$FOLDER.git"
AWS_CREDS_DIR="~/.aws/$PROJECT_SHORT"
AWS_PROFILE="$PROJECT_SHORT-shared-devops"
SKIP_VALIDATION="yes"
```

### Step 2: Authenticate via SSO

Navigate to the required layer directory and perform authentication using AWS SSO. This step verifies your credentials
and ensures that subsequent operations are secure.

```bash
cd $FOLDER/shared/us-east-1/tools-vpn-server
leverage aws sso configure
```

### Step 3: Export AWS Credentials

Export the AWS credentials as environment variables to enable the AWS CLI and other tools to use them for session
management.

```bash
export AWS_SHARED_CREDENTIALS_FILE="$AWS_CREDS_DIR/credentials"
export AWS_CONFIG_FILE="$AWS_CREDS_DIR/config"
```

### Step 4: Validate Identity (Optional)

Optionally, you can validate your AWS identity to ensure that your configuration is correct. This step is recommended to
avoid issues in later stages.

```bash
aws sts get-caller-identity --profile $AWS_PROFILE
```

### Step 5: Start an SSM Session

Now that the setup is complete, you can start an SSM session. This is the final step and allows you to manage your AWS
resources securely.

#### Command syntax

```bash
aws ssm start-session --target <instance-id> --profile <aws-profile> --region <aws-region>
```

#### Example command

Consider the following settings as an example:

* _Instance ID:_ **i-0123456789abcdef0**
* _AWS Profile:_ **devops-profile**
* _AWS Region:_ **us-west-2**

```bash
aws ssm start-session --target i-0123456789abcdef0 --profile devops-profile --region us-west-2
```

This command initiates a secure session to the specified EC2 instance using SSM. It's a crucial tool for managing your
servers securely without the need for direct SSH access. Ensure that your permissions and profiles are correctly
configured to use this feature effectively.

By following these steps, you can efficiently set up and use the AWS SSM configuration tool for enhanced security and
management of your cloud resources.

For a complete view of the script and additional configurations, please refer to
the [full Gist](https://gist.github.com/exequielrafaela/2d963c6f12186a1492f870ce2f9f9dde).
