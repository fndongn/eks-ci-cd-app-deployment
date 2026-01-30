
# VPC
# Creates the main Virtual Private Cloud
# Required for all EKS networking resources
resource "aws_vpc" "eksvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


# Internet Gateway
# Allows public subnets to access the internet
resource "aws_internet_gateway" "eksvpc_igw" {
  vpc_id = aws_vpc.eksvpc.id

  tags = {
    Name = "eks-igw"
  }
}


# Public Subnets
# Used for ALB and NAT Gateways
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.eksvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-us-east-1a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.eksvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "eks-public-us-east-1b"
    "kubernetes.io/role/elb" = "1"
  }
}

# Public Route Table
# Routes internet traffic through the IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eksvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eksvpc_igw.id
  }

  tags = {
    Name = "eks-public-rt"
  }
}


# Public Route Table Associations
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}


# Elastic IPs
# Required for NAT Gateways
resource "aws_eip" "nat_a" {
  domain = "vpc"
}

resource "aws_eip" "nat_b" {
  domain = "vpc"
}


# NAT Gateways
# Allow private subnets outbound internet access
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "eks-nat-us-east-1a"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "eks-nat-us-east-1b"
  }
}

# Private Subnets
# Used by EKS worker nodes
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.eksvpc.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "eks-private-us-east-1a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.eksvpc.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eks-private-us-east-1b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Private Route Tables
# Route private traffic through NAT Gateways
resource "aws_route_table" "private_a_rt" {
  vpc_id = aws_vpc.eksvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "eks-private-rt-a"
  }
}

resource "aws_route_table" "private_b_rt" {
  vpc_id = aws_vpc.eksvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = {
    Name = "eks-private-rt-b"
  }
}


# Private Route Table Associations
resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a_rt.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b_rt.id
}
