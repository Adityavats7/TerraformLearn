variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

# CHANGE: list(string) -> map(string)
variable "public_subnets" {
  type        = map(string)
  description = "Map of public subnet name => CIDR"
}

variable "azs" {
  type        = list(string)
  default     = []
}

variable "enable_ipv6" {
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
}