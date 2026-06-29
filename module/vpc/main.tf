resource "aws_vpc" "training" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.training.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.training.id
  tags = {
    Name = "training-igw"
  }
}
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat.id
  depends_on = [
    aws_internet_gateway.gw
  ]
  tags = {
    Name = "-training-nat"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.training.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "training-publiv-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.training.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "training-private-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.training.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  count                   = length(var.private_subnet_cidrs)
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zones[count.index]
  tags = {
    Name = "private-${count.index + 1}"
  }
}

