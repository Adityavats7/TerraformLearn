variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-south-1" # Mumbai – change if needed
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "my_ip" {
  description = "Your public IP in CIDR (for SSH). Example: 1.2.3.4/32"
  type        = string
  # Fill your IP (with /32) before apply to enable SSH; otherwise, you can still use SSM.
  default     = "0.0.0.0/0" # change to your IP: e.g., "203.0.113.45/32"
}
