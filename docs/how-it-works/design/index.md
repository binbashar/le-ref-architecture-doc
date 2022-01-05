![binbash-logo](../../assets/images/logos/binbash.png "Binbash"){: style="width:250px"}
![binbash-leverage-tf](../../assets/images/logos/binbash-leverage-terraform.png#right "Leverage"){: style="width:130px"}

# How it works

The objective of this document is to explain how the **Binbash Leverage Reference Architecture for AWS**
works, in particular how the Reference Architecture model is built and why we need it.

## Overview

This documentation contains all the guidelines to create Binbash 
Leverage Reference Architecture for AWS that will be implemented on the 
Projects’ AWS infrastructure.

We're assuming you've already have in place your AWS Landing Zone based on the
[First Steps](../../first-steps/introduction.md) guide. 

!!! check "Our Purpose"
    * [x] **Democratize advanced technologies:** As complex as it may sound, the basic idea behind this design principle is 
    simple. It is not always possible for a business to maintain a capable in-house IT department while staying up to
    date. It is entirely feasible to set up your own cloud computing ecosystem from scratch without experience, but that
    would take a considerable amount of resources; it is definitely not the most efficient way to go. 
    * [x] **An efficient business-minded** way to go is to employ AWS as a service allows organizations to benefit from
    the advanced technologies integrated into AWS without learning, researching, or creating teams specifically for
    those technologies.

!!! info
    This documentation will provide a detailed reference of the tools and techs used, 
    the needs they address and how they fit with the multiple practices we will be implementing.