variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name"
}

variable "ingress_ssh_cidr" {
  type        = string
  description = "CIDR allowed to SSH"
  default     = "0.0.0.0/0"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}