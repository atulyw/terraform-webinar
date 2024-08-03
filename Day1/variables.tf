variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "this value is for vpc cidr"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "namespace" {
  type    = string
  default = "gamma"
}

variable "tags" {
  type = map(any)
  default = {
    project_id    = "1123"
    project_owner = "gamma-app"
    cost_id       = "GM-1219"
  }
}

variable "availability_zone" {
  type = list(any)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subnet" {
  type    = list(any)
  default = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20", "10.0.64.0/20"]
}

variable "public_subnet" {
  type    = list(any)
  default = ["10.0.112.0/20", "10.0.128.0/20"]
}
