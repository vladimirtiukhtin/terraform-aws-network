resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = var.ipv6_enabled
  enable_dns_hostnames             = true
  tags = merge(
    map("Name", var.name),
    local.common_tags,
    var.extra_tags
  )
}

module "vpc_flow_log" {
  source = "./vpc_flow_log"
  count  = var.vpc_flow_log_enabled ? 1 : 0
  name   = join("", regexall("[[:alnum:]]", var.name)) // Remove any spaces and special characters
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.common_tags, var.extra_tags)
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    map("Name", "${var.name} Default SG"),
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    map("Name", var.name),
    local.common_tags,
    var.extra_tags
  )
}
