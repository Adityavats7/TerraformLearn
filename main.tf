############################
# Data Sources
############################

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get a default subnet (first one) in that VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Latest Amazon Linux 2 AMI (x86_64)
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

############################
# Networking - Security Group
############################

resource "aws_security_group" "ssh_only" {
  name        = "ssh_only"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.default.id

  # SSH (Optional if you only want SSM)
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Outbound: allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# IAM for SSM Session Manager
############################

# Instance role
resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach AmazonSSMManagedInstanceCore
resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

############################
# EC2 Instance
############################

resource "aws_instance" "this" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.ssh_only.id]

  # Attach SSM instance profile (so you can connect without SSH keys)
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  # Optional: simple user data
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from Terraform $(date)" > /etc/motd
    yum update -y
  EOF

  # Root EBS
  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
  }

  # Get a public IP (since default subnet may be public)
  associate_public_ip_address = true
}
