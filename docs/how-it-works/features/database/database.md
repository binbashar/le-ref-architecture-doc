# Databases

## Overview 
Will implement [AWS RDS databases](https://aws.amazon.com/rds/) matching the requirements of the current application stacks. 
If the region selected is the same you're actually using for your legacy AWS RDS instances we will be able to create a
peering connection to existing databases in order to migrate the application stacks first, then databases. 

!!! info "AWS RDS Specs"
    * [x] RDS Instance Size
    * [x] Multi AZ
    * [x] Encryption: Yes
    * [x] Auto Minor version update
    * [x] Automated snapshots
    * [x] Snapshot retention
