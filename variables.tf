variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region"
}

# SWITCH to map for stable addressing (no index churn)
# Keys are stable names; values are CIDRs.
variable "public_subnets" {
  type = map(string)
  default = {
    public-a = "10.0.1.0/24"
    public-b = "10.0.2.0/24"
  }
  description = "Map of public subnet name => CIDR"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# Optional: specify AZs; otherwise, auto-pick first N.
variable "azs" {
  type    = list(string)
  default = []
}

# Networking future-proof toggles
variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Enable IPv6 CIDRs and routes"
}

# EC2
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "Existing EC2 key name. If empty and enable_ssm=true, we won't require SSH."
}

variable "enable_ssm" {
  type        = bool
  default     = true
  description = "Attach SSM role/profile to instance to use Session Manager instead of SSH."
}

# Security: define as lists so you can update without code edits
variable "ssh_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Allowed CIDRs for SSH (used only if you plan to SSH)"
}

variable "http_ports" {
  type        = list(number)
  default     = [80]
  description = "HTTP-ish ports to open publicly"
}

variable "ingress_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed for SSH"
}

# Global tags (provider.default_tags will propagate)
variable "tags" {
  type = map(string)
  default = {
    Project = "ProjectSwing"
    Env     = "dev"
    Owner   = "Aditya"
  }
}
variable "s3_bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  default     = "projectswing-assets"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}