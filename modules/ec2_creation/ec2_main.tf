# Amazon Linux 2 AMI (x86_64, gp2), official owner
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web" {
  name        = "${var.tags["Project"]}-web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags["Project"]}-web-sg" })
}

locals {
  user_data = <<-EOT
    #!/bin/bash
    set -xe
    amazon-linux-extras install nginx1 -y || yum install -y nginx
    systemctl enable nginx
    echo "<h1>${var.tags["Project"]} - Hello from $(hostname)</h1>" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOT
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amzn2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = local.user_data

  tags = merge(var.tags, { Name = coalesce(var.tags["Name"], "${var.tags["Project"]}-web-1") })
}