terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}

provider "aws" {
  profile = "atulyw"
  region  = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  # tags = {
  #   Name = "abc"
  #   project_id = "gamma-app"
  # }
  tags = merge(
    var.tags,
    {
      #Name = "${var.namespace}-${var.env}-vpc"
      Name = format("%s-%s-vpc", var.namespace, var.env)
    }
  )
}


resource "aws_subnet" "private" {
  count                   = length(var.private_subnet)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet[count.index]
  enable_dns64            = "false"
  map_public_ip_on_launch = "false"
  availability_zone       = element(var.availability_zone, count.index)
  tags = merge(
    var.tags,
    {
      #Name = "${var.namespace}-${var.env}-private-subnet"
      Name = format("%s-%s-private-subnet", var.namespace, var.env)
    }
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet[count.index]
  enable_dns64            = "false"
  map_public_ip_on_launch = "true"
  availability_zone       = element(var.availability_zone, count.index)
  tags = merge(
    var.tags,
    {
      #Name = "${var.namespace}-${var.env}-public-subnet"
      Name = format("%s-%s-public-subnet", var.namespace, var.env)
    }
  )
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = format("%s-%s-private-rt", var.namespace, var.env) })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = format("%s-%s-public-rt", var.namespace, var.env) })
}


resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = format("%s-%s-igw", var.namespace, var.env) })
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_eip" "this" {
  tags = merge(var.tags, { Name = format("%s-%s-eip", var.namespace, var.env) })
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id
  tags          = merge(var.tags, { Name = format("%s-%s-nat", var.namespace, var.env) })
}

resource "aws_route" "nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}
