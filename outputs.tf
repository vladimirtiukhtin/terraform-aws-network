output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "VPC CIDR e.g. 10.0.0.0/16"
  value       = aws_vpc.vpc.cidr_block
}

output "subnet_ids" {
  description = "Produces a map { 'subnet_name': ['az1_id', 'az2_id', 'az3_id'] }"
  value = {
    for subnet in var.subnets :
    subnet["name"] => [
      for az in data.aws_availability_zones.available.names : aws_subnet.subnet["${subnet["name"]}-${az}"]["id"]
    ]
  }
}

output "route_table_ids" {
  description = "Produces a map { 'subnet_name': 'route_table_id'] }"
  value = {
    for subnet in var.subnets :
    subnet["name"] => aws_route_table.table[subnet["name"]]["id"]
  }
}
