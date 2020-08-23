terraform {
  required_version = ">=0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.0.0"
    }
  }

}

data "aws_availability_zones" "available" {}

locals {
  subnets = flatten([
    for az in data.aws_availability_zones.available.names : [
      for subnet in var.subnets : [
        merge(subnet, map("availability_zone", az))
      ]
    ]
  ])
  common_tags = {
    ManagedBy = "terraform"
  }
}
