variable "env_name" {
  description = "Enviroment name. This will be used as prefix for all resources"
  type        = string
}

variable "region" {
  description = "The AWS region in which resources will be deployed"
  type        = string
}

variable "tags" {
  description = "Tags logging in center place"
  type = object({
    env   = string
    owner = string
  })
}
variable "vpc" {
  description = "Object representing the VPC configuration"

  type = object({
    azs             = list(string)
    cidr            = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}

variable "ec2" {
  type = object({
    key                   = string
    public_instance_size  = string
    private_instance_size = string
  })
}