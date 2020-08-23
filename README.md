Terraform AWS Network Module
============================

Terraform module to create following AWS resources:
- VPC
- Intenet Gateway
- Subnets, Route Tables and Routes
- IAM role and policy for VPC flow log

# Contents
- [Required Input Variables](#variables)
- [Usage](#usage)
- [Outputs](#outputs)
- [License](#license)
- [Author Information](#author)

## <a name="variables"></a> Required Input Variables
At least following input variables must be provided. See [full list](variables.tf) of supported variables

| Name | Description                      |
| ---- | -------------------------------- |
| name | Common name, a unique identifier |

## <a name="usage"></a> Usage

To provision default configuration containing one private and one public subnet in each availability zone use:
```hcl-terraform
module "network" {
  source = "./modules/aws_network"
  name   = "Example Project"
}
```

By default vpc flow log is turned off as it applies additional charge. To turn it on add "vpc_flow_log_enabled" property:

```hcl-terraform
module "network" {
  source = "./modules/aws_network"
  name   = "Example Project"

  vpc_flow_log_enabled = true
}
```

If any alterations to subnets required, use "subnets" parameter to specify custom configuration:

```hcl-terraform
module "network" {
  source = "./modules/aws_network"
  name   = "Example Project"
  
  subnets = [
    {
      name        = "public"
      ig_attached = true
      tags        = {
        kubernetes.io/cluster/eks-cluster = "shared",
        kubernetes.io/role/elb            = "1"
      }
    },
    {
      name        = "eks"
      ig_attached = false
      tags        = {
        kubernetes.io/cluster/eks-cluster = "shared",
        kubernetes.io/role/internal-elb   = "1"
      }
    }
  ]
}
```

## <a name="outputs"></a> Outputs
Full list of module outputs and their descriptions can be found in [outputs.tf](outputs.tf)

## <a name="license"></a> License
The module is distributed under [MIT License](LICENSE.txt). Please make sure you have read, understood and agreed to
it's terms and conditions

## <a name="author"></a> Author Information
Vladimir Tiukhtin <vladimir.tiukhtin@hippolab.ru><br/>London
