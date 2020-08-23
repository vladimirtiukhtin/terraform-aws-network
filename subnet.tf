resource "aws_subnet" "subnet" {
  for_each = {
    for index, subnet in local.subnets : "${subnet["name"]}-${subnet["availability_zone"]}" => merge(subnet, map("index", index))
  }

  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(aws_vpc.vpc.cidr_block, var.newbits, each.value["index"])
  availability_zone               = each.value["availability_zone"]
  map_public_ip_on_launch         = each.value["ig_attached"]
  assign_ipv6_address_on_creation = var.ipv6_enabled
  ipv6_cidr_block                 = var.ipv6_enabled ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, each.value["index"]) : null
  tags = merge(
    map("Name", "${var.name} ${each.value["name"]}"),
    local.common_tags,
    each.value["tags"],
    var.extra_tags
  )
}

resource "aws_route_table" "table" {
  for_each = {
    for subnet in var.subnets : subnet["name"] => subnet
  }

  vpc_id = aws_vpc.vpc.id
  tags = merge(
    map("Name", "${var.name} ${each.key}"),
    local.common_tags,
    var.extra_tags
  )
}

resource "aws_route_table_association" "association" {
  for_each = {
    for subnet in local.subnets : "${subnet["name"]}-${subnet["availability_zone"]}" => subnet
  }

  subnet_id      = aws_subnet.subnet[each.key]["id"]
  route_table_id = aws_route_table.table[each.value["name"]]["id"]
}

resource "aws_route" "ipv4_defaut_gateway" {
  for_each = {
    for subnet in var.subnets : subnet["name"] => subnet if lookup(subnet, "ig_attached", false)
  }

  route_table_id         = aws_route_table.table[each.key]["id"]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route" "ipv6_defaut_gateway" {
  for_each = {
    for subnet in var.subnets : subnet["name"] => subnet if lookup(subnet, "ig_attached", false) && var.ipv6_enabled
  }

  route_table_id              = aws_route_table.table[each.key]["id"]
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.gateway.id
}
