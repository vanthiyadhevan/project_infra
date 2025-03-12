# Main VPC Creation

resource "aws_vpc" "vpc_main" {
  cidr_block = var.vpc_cidr[var.environment]
  tags = {
    Name        = "${var.environment}-VPC"
    Environment = var.environment
  }
}


# Subnet Creation Both Private and Public

resource "aws_subnet" "pub_subnet" {
  count = length(var.pub_subnet_cidr[var.environment])

  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.pub_subnet_cidr[var.environment][count.index]
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-pub-subnet-${count.index + 1}"
    Environment = var.environment
    "Kubernetes.io/role/elb" = "1"
    "Kubernetes.io/cluster/chatApp" = var.environment
  }
}

resource "aws_subnet" "pvt_subnet" {
  count             = length(var.pvt_subnet_cidr[var.environment])
  vpc_id            = aws_vpc.vpc_main.id
  cidr_block        = var.pvt_subnet_cidr[var.environment][count.index]
  availability_zone = element(["us-east-1a", "us-east-1b", "us-east-1c"], count.index)
  tags = {
    Name        = "${var.environment}-pvt-subnet-${count.index + 1}"
    Environment = var.environment
    "Kubernetes.io/role/internal-elb" = "1"
    "Kubernetes.io/cluster/chatApp" = var.environment
  }

}


# Subnet Group Creation For RDS 
resource "aws_db_subnet_group" "pvt_db_subnet_grp" {
  name = var.db_subnet_grp_name
  subnet_ids = [aws_subnet.pvt_subnet[*].id]

  tags = {
    Name = "${var.environment}-db-subnet-grp"
    Environment = var.environment
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
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = var.route_table_route_cidr
    gateway_id = aws_internet_gateway.IGW.id
  }
  # route  {
  #   cidr_block = "::/0"
  #   egress_only_gateway_id = 
  # }
  tags = {
    Name        = "${var.environment}-public-RT"
    Environment = var.environment
  }
}

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

# Route For Nat Gateway
# resource "aws_route" "private_route_for_nat_gateway" {
#   route_table_id         = aws_route_table.pvt_route_table.id
#   destination_cidr_block = var.route_table_route_cidr
#   nat_gateway_id         = ""
# }

# Public Route Table Association
resource "aws_route_table_association" "pub_subet_association" {
  count     = length(aws_subnet.pub_subnet)
  subnet_id = aws_subnet.pub_subnet[count.index].id
  # subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.pub_route_table.id
  
}

# Private Route Table Association
resource "aws_route_table_association" "pvt_subet_association" {
  count     = length(aws_subnet.pvt_subnet)
  subnet_id = aws_subnet.pvt_subnet[count.index].id
  # subnet_id      = aws_subnet.pvt_subnet.id
  route_table_id = aws_route_table.pvt_route_table.id
}

# EIP Creation
resource "aws_eip" "for_nat_gateway" {
  # vpc = true
  domain = "vpc"
}

# Nat Gateway Creation
resource "aws_nat_gateway" "pvt_nat_gateway" {
  allocation_id = aws_eip.for_nat_gateway.id
  # subnet_id     = aws_subnet.pub_subnet.id
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
