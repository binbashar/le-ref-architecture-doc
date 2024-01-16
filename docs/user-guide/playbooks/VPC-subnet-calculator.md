# How to calculate the VPC subnet CIDRs?

To calculate subnets [this calculator](https://www.davidc.net/sites/default/subnets/subnets.html?network=172.18.0.0&mask=20&division=15.7231) can be used

Note in this link a few params were added: the base network and mask, and the division number. In this case the example is for the `shared` account networking.

This table will be shown: 
![subnet-cidr-calculator](/assets/images/screenshots/subnet-cidr-calculator.png "Subnet CIDR calculator"){: style="width:950px"}

Note how this information is set in the tf file:

```yaml
  vpc_cidr_block = "172.18.0.0/20"
  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  private_subnets_cidr = ["172.18.0.0/21"]
  private_subnets = [
    "172.18.0.0/23",
    "172.18.2.0/23"
  ]

  public_subnets_cidr = ["172.18.8.0/21"]
  public_subnets = [
    "172.18.8.0/23",
    "172.18.10.0/23"
  ]
```

Note the main CIDR is being used for the VPC. See on the left how the `/20` encompasses all the rows.

Then two divisions for `/21`. Note the first subnet address of the first row for each one is being used for `private_subnets_cidr` and `public_subnets_cidr`.

Finally the `/23` are being used for each subnet.

Note we are using the first two subnet addresses for each `/21`. This is due to we are reserving the other two to allow adding more AZs in the future. (up to two in this case)

If you want you can take as a reference [this page](http://localhost:8000/user-guide/ref-architecture-aws/features/network/vpc-addressing/) to select CIDRs for each account.
