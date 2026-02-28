output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.this.public_ip
}

output "ssh_command" {
  description = "SSH command (requires a key pair if you add key_name)"
  value       = "ssh ec2-user@${aws_instance.this.public_ip}"
}

output "ssm_connect_hint" {
  description = "Command to start SSM session (AWS CLI v2 required)"
  value       = "aws ssm start-session --target ${aws_instance.this.id}"
}