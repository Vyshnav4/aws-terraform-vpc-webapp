variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr_block" {
  description = "CIDR block for subnet 1"
  default     = "10.0.0.0/24"
}

variable "subnet2_cidr_block" {
  description = "CIDR block for subnet 2"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0261755bbcb8c4a84"
}