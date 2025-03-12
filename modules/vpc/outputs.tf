output "vpc_id" {
  value = aws_vpc.vpc_main.id
}
output "pvt_subnet" {
  value = aws_subnet.pvt_subnet[*].id
  description = "list of private subnet ID's"
}
output "default_security_group" {
  value = aws_vpc.vpc_main.default_security_group_id
  description = "vpc default security group id"
}
output "vpc_env" {
  value = aws_vpc.vpc_main.tags
}
output "route_table" {
  value = aws_route_table.pub_route_table.id
}
output "igw_name" {
  value = aws_internet_gateway.IGW.id
}