variable "env" {
  type    = string
  default = "dev"
}

variable "namespace" {
  type    = string
  default = "gamma"
}

variable "description" {
  type = string
  default = "temp security group"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
  default = ""
}