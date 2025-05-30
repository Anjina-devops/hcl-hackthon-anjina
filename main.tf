terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "anjina-main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.common_tags,
    var.vpc_tags
  )
}
resource "aws_security_group" "devopsshack_node_sg" {
  vpc_id = aws_vpc.anjina-main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "anjina-hcl-sg"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.anjina-main.id

  tags = merge(
    var.common_tags,
    var.igw_tags
  )
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.anjina-main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = var.public_subnet_names[count.index]
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.anjina-main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = var.private_subnet_names[count.index]
    }
  )
}



resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.anjina-main.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags
  )
}

# associate public route table with public subnets
# public-route-table --> public-1a subnet
# public-route-table --> public-1b subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.anjina-main.id

  tags = merge(
    var.common_tags,
    var.private_route_table_tags
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}



