provider "aws" {
  profile = var.profile
  region  = var.region
}

module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr       = var.vpc_cidr
  env            = var.env
  namespace      = var.namespace
  private_subnet = var.private_subnet
  public_subnet  = var.public_subnet
}

module "security_group" {
  source    = "../../modules/security-group"
  env       = var.env
  namespace = var.namespace
  vpc_id    = module.vpc.vpc_id
}