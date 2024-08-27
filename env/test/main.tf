provider "aws" {
  profile = "atulyw"
  region  = "eu-west-1"
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_cidr = "192.168.0.0/24"
  env = "test"
  private_subnet = ["192.168.0.0/27", "192.168.0.32/27"]
  public_subnet = ["192.168.0.64/27"]
}

module "security_group" {
  source = "../../modules/security-group"
  env = "test"
  namespace = "gamma"
  vpc_id = module.vpc.vpc_id
}