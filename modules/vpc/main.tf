# -------------------------
# Main VPC Creation
# VPC Main
# -------------------------
resource "aws_vpc" "vpc_main" {
  cidr_block = var.vpc_cidr[var.environment]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-VPC"
    Environment = var.environment
  }
}

# ----------------------------------------
# Subnet Creation Both Private and Public
# ----------------------------------------
# Public Subnet
resource "aws_subnet" "pub_subnet" {
  count = length(var.pub_subnet_cidr[var.environment])

  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.pub_subnet_cidr[var.environment][count.index]
  availability_zone       = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name                            = "${var.environment}-pub-subnet-${count.index + 1}"
    Environment                     = var.environment
    "Kubernetes.io/role/elb"        = "1"
    "Kubernetes.io/cluster/chatApp" = var.environment
  }
}

# Private subnet
resource "aws_subnet" "pvt_subnet" {
  count             = length(var.pvt_subnet_cidr[var.environment])
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.pvt_subnet_cidr[var.environment][count.index]
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  tags = {
    Name                              = "${var.environment}-pvt-subnet-${count.index + 1}"
    Environment                       = var.environment
    "Kubernetes.io/role/internal-elb" = "1"
    "Kubernetes.io/cluster/chatApp"   = var.environment
  }

}


# Internet Gateway(IGW) Creation
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name        = "${var.environment}-IGW"
    Environment = var.environment
  }
}


# Route Table Creation Both Public And Private
# Public Route Table
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = var.route_table_route_cidr
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name        = "${var.environment}-public-RT"
    Environment = var.environment
  }
}

# Private Route Table
resource "aws_route_table" "pvt_route_table" {
  vpc_id = aws_vpc.vpc_main.id
  route {
    cidr_block     = var.route_table_route_cidr
    nat_gateway_id = aws_nat_gateway.pvt_nat_gateway.id
  }
  tags = {
    Name        = "${var.environment}-private-RT"
    Environment = var.environment
  }
}



# Route Table Association For Both Public And Private
# Public Route Table Association
resource "aws_route_table_association" "pub_subet_association" {
  count     = length(aws_subnet.pub_subnet)
  subnet_id = aws_subnet.pub_subnet[count.index].id
  route_table_id = aws_route_table.pub_route_table.id
}

# Private Route Table Association
resource "aws_route_table_association" "pvt_subet_association" {
  count     = length(aws_subnet.pvt_subnet)
  subnet_id = aws_subnet.pvt_subnet[count.index].id
  route_table_id = aws_route_table.pvt_route_table.id
}

# EIP Creation
resource "aws_eip" "for_nat_gateway" {
  domain = "vpc"
}

# Nat Gateway Creation
resource "aws_nat_gateway" "pvt_nat_gateway" {
  allocation_id = aws_eip.for_nat_gateway.id
  subnet_id = aws_subnet.pub_subnet[0].id

  tags = {
    Name        = "${var.environment}-NAT-gateway"
    Environment = var.environment
  }
  depends_on = [
    aws_eip.for_nat_gateway,
    aws_internet_gateway.IGW
  ]
}
