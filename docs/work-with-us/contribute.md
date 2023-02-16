# Contribute and Developing binbash Leverage 

This document explains how to get started with developing for **Leverage Reference Architecture**.
It includes how to build, test, and [release](https://github.com/binbashar/le-tf-infra-aws/releases) new versions.

## Quick Start

### Getting the code

The code must be checked out from this same github.com repo inside the
[binbash Leverage Github Organization](https://github.com/binbashar).

```
git clone git@github.com:binbashar/le-tf-infra-aws.git
cd le-tf-infra-aws
cd ..

git clone git@github.com:binbashar/le-ansible-infra.git
cd le-ansible-infra
cd ..
```

### Initial developer environment build

**TODO**

## Dependencies

This guide requires you to install X v0.1 or newer.

## Deploying

To deploy the Leverage Reference Architecture onto AWS.
Please check the [deployment guide](./deploy/)

## Testing

To run tests, just run...

## Releasing
### CircleCi PR auto-release job

![circleci-logo](../assets/images/logos/circleci.png "CircleCI"){: style="width:150px"}

- <https://circleci.com/gh/binbashar/bb-devops-tf-infra-aws>
- **NOTE:** Will only run after merged PR.