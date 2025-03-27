output "vpc_id" {
  value = aws_vpc.vpc_main.id
  description = "vpc id for environment"
}
output "vpc_cidr" {
  value       = aws_vpc.vpc_main.cidr_block
  description = "cidr of the vpc"
}
output "pvt_subnet" {
  value = [for subnet in aws_subnet.pvt_subnet : subnet.id]
  # value       = aws_subnet.pvt_subnet[*].id
  description = "list of private subnet ID's"
}
output "pub_subnet" {
  # value       = aws_subnet.pub_subnet[*].id
  value       = [for subnet in aws_subnet.pub_subnet : subnet.id]
  description = "list of public subnet ID's"
}
output "default_security_group" {
  value       = aws_vpc.vpc_main.default_security_group_id
  description = "vpc default security group id"
}
output "vpc_env" {
  value = aws_vpc.vpc_main.tags
}
output "pub_route_table" {
  value       = aws_route_table.pub_route_table.id
  description = "public subnet route table id"
}
output "pvt_route_table" {
  value       = aws_route_table.pvt_route_table.id
  description = "private route table id"
}
output "igw_name" {
  value = aws_internet_gateway.IGW.id
}
output "nat_gateway_id" {
  value       = aws_nat_gateway.pvt_nat_gateway.id
  description = "nat gateway id"
}

# output "public_subnet" {
#   value = var.pub_subnet_cidr
# }