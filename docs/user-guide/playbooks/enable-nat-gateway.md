# Enable nat-gateway using binbash Leverage

## Goal

To activate the NAT Gateway in a VPC created using [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/).

## Assumptions

We are assuming the [**binbash Leverage**](https://leverage.binbash.co/) [Landing Zone](https://leverage.binbash.co/try-leverage/) is deployed, an account called `apps-devstg` was created and a region `us-east-1` is being used. In any case you can adapt these examples to other scenarios.

---

---

## How to

Go into you account/region/network layer:

```shell
cd apps-devstg/us-east-1/base-network
```

!!! info
    if you called the layer other that this, please set the right dir here
    
Check a file called `terraform.auto.tfvars` exists. If it does not, create it.

Edit the file and set this content:

```hcl
vpc_enable_nat_gateway = true
```

Apply the layer as usual:

```shell
leverage tf apply
```

## How to disable the nat gateway

Do the same as before but setting this in the `tfvars` file:

```hcl
vpc_enable_nat_gateway = false
```
