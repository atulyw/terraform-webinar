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
  availability_zone = element(var.availability_zone, count.index)
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
  availability_zone = element(var.availability_zone, count.index)
  tags = merge(
    var.tags,
    {
      #Name = "${var.namespace}-${var.env}-public-subnet"
      Name = format("%s-%s-public-subnet", var.namespace, var.env)
    }
  )
}
