output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs"
}

output "ec2_instance_id" {
  value       = module.ec2.instance_id
  description = "EC2 instance ID"
}

output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "EC2 Public IP"
}

output "ec2_public_dns" {
  value       = module.ec2.public_dns
  description = "EC2 Public DNS"
}

output "ec2_http_url" {
  value       = "http://${module.ec2.public_ip}"
  description = "URL to test NGINX"
}
output "s3_bucket_name" {
  value       = module.s3_bucket.bucket_name
  description = "S3 bucket name"
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "S3 bucket ARN"
}