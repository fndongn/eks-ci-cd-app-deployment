variable "region" {
  default = "us-east-1"
}

variable "az_a" {
  default = "us-east-1a"
}

variable "az_b" {
  default = "us-east-1b"
}

variable "project_name" {
  default = "eks-deployment"
}

variable "environment" {
  default = "production"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.0.0/24"
}

variable "key_name" {
  default = "myKey1"
}

variable "instance_type" {
  default = "t3.small"
}
