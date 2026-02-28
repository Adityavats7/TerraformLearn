# 🚀 Terraform EC2 Deployment

This project contains a Terraform configuration that deploys an EC2 instance in AWS using the default VPC, a secure Security Group, and SSM Session Manager for passwordless access (no SSH keys needed).

---

## 📁 Project Structure
```
.
├── versions.tf
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── .gitignore
```

---

## 📌 Features
- Deploys an Amazon Linux 2 EC2 instance
- Uses default VPC + default subnet
- Creates a Security Group allowing SSH from your IP
- Attaches IAM Role + Instance Profile for SSM
- Supports SSM Session Manager login
- Includes user_data script
- Clean, simple, production-ready structure

---

## 🧰 Prerequisites
- Terraform v1.5+
- AWS CLI v2
- AWS credentials configured:
```
aws configure
```

---

## ⚙️ How to Use
### 1. Initialize Terraform
```
terraform init
```

### 2. Validate configuration
```
terraform validate
```

### 3. Show execution plan
```
terraform plan -out tfplan
```

### 4. Apply changes
```
terraform apply tfplan
```

---

## 🖥️ Connect to the EC2 Instance
### ✔ SSM Session Manager (recommended)
```
aws ssm start-session --target <instance_id>
```

### ✔ SSH (optional)
Only if a key pair was added:
```
ssh ec2-user@<public_ip>
```

---

## 🔧 Variables
Edit inside `variables.tf`.

| Name | Description | Default |
|------|-------------|---------|
| aws_region | AWS region | ap-south-1 |
| instance_type | EC2 size | t3.micro |
| my_ip | Your IP for SSH | 0.0.0.0/0 |

---

## 📦 Outputs
- `instance_id`
- `public_ip`
- `ssh_command`
- `ssm_connect_hint`

---

## 🔒 Security Notes
- Update `my_ip` to your **actual IP/32** for secure SSH.
- Do NOT commit `.tfstate`, `.tfvars`, or AWS keys.
- SSM Session Manager is the recommended access method.

---

## 🧹 Destroy Resources
```
terraform destroy -auto-approve
```

---

## 📜 License
Free to use and modify for personal or learning projects.
