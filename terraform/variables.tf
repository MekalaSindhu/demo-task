variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
  //default     = "us-west-1"
    
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  default     = "my-keypair"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  default     = "10.0.1.0/24"
}

