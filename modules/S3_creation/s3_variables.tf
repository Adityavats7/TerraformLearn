variable "bucket_name" {
  description = "Base name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Block all public access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type        = map(string)
  default     = {}
}