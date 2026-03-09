# Enterprise AWS Infrastructure – Terraform (Modular & Scalable)

## Executive Summary

This repository contains **enterprise‑grade, production‑ready AWS infrastructure** defined using **Terraform**. The infrastructure is modular, scalable, and designed with long‑term maintainability in mind. It follows real‑world DevOps and Cloud Engineering best practices and is suitable for production use as well as portfolio demonstration.

The current implementation provisions a **public frontend hosting environment** using **AWS VPC + EC2 + NGINX**, with a clear roadmap for scaling to high availability and fully managed services.

---

## Key Design Principles

- Infrastructure as Code (IaC)
- Modular Terraform architecture
- Stable resource addressing (`for_each` over `count`)
- Separation of concerns (network vs compute)
- Safe updates with minimal blast radius
- Designed for future expansion

---

## High‑Level Architecture

```
Internet
   |
Internet Gateway
   |
Public Route Table (0.0.0.0/0)
   |
Public Subnets (Multi‑AZ)
   |
EC2 Instance (NGINX – Frontend)
```

---

## Repository Structure

```
.
├── main.tf
├── variables.tf
├── provider.tf
├── versions.tf
├── output.tf
├── README.md
├── AdityaSSHkey.pub
└── modules
    ├── vpc-creation
    │   ├── Vpc_main.tf
    │   ├── vpc_variables.tf
    │   ├── vpc_output.tf
    │   └── vpc_versions.tf
    └── ec2_creation
        ├── ec2_main.tf
        ├── ec2_variables.tf
        ├── ec2_outputs.tf
        └── ec2_versions.tf
```

---

## Module Overview

### VPC Module (`modules/vpc-creation`)

**Responsibilities:**
- Create a custom VPC with DNS support
- Create public subnets using `for_each` and maps
- Attach Internet Gateway
- Configure public routing
- Associate subnets with route table

**Engineering Decisions:**
- Map‑based subnet definition prevents index‑based recreation
- AZ selection is dynamic
- IPv6 support can be enabled later

---

### EC2 Module (`modules/ec2_creation`)

**Responsibilities:**
- Create Security Group (HTTP + SSH)
- Launch EC2 instance (Amazon Linux)
- Install and start NGINX via user_data
- Assign public IP

**Engineering Decisions:**
- AMI selected dynamically
- Easy migration path to SSM, ALB, ASG

---

## Variables

| Variable | Description |
|--------|-------------|
| region | AWS region |
| vpc_cidr | CIDR block for VPC |
| public_subnets | Map of subnet names to CIDRs |
| azs | Optional AZ override |
| instance_type | EC2 instance type |
| key_name | SSH key pair |
| ingress_ssh_cidr | SSH allowed CIDR |
| tags | Common resource tags |

---

## Outputs (Live Deployment)

```
ec2_http_url    = http://13.233.190.140
ec2_instance_id = i-04c2ec85b7364fd5d
ec2_public_ip   = 13.233.190.140
ec2_public_dns = ec2-13-233-190-140.ap-south-1.compute.amazonaws.com

public_subnet_ids = {
  public-a = subnet-07a84c44c216874bb
  public-b = subnet-0a99c48eb44592e7d
}
```

---

## Deployment Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## Frontend Deployment

The EC2 instance serves frontend applications using **NGINX**.

**Supported:**
- React (build)
- Next.js (static export)
- Vue
- HTML/CSS/JS

Deployment path:
```
/usr/share/nginx/html
```

Restart NGINX after deployment:
```bash
sudo systemctl restart nginx
```

---

## Security Considerations

- Minimal ports exposed (80, 22)
- SSH access can be restricted or removed
- Designed to migrate to SSM Session Manager
- No secrets hard‑coded

---

## Scalability & Roadmap

### Phase 1 (Current)
- VPC + Public Subnets
- EC2 + NGINX

### Phase 2
- Private subnets
- NAT Gateway
- SSM‑only access

### Phase 3
- Application Load Balancer
- Auto Scaling Group
- Multi‑AZ frontend

### Phase 4 (Enterprise)
- S3 + CloudFront
- HTTPS (ACM)
- WAF
- CI/CD pipelines
- Remote Terraform state

---

## Intended Use

- Enterprise‑style Terraform reference
- DevOps / Cloud portfolio project
- Interview‑ready infrastructure example
- Startup MVP infrastructure

---

## Author

**Aditya Kumar**  
CAD Engineer | Cloud & DevOps  
Location: Gurugram, Haryana  
Project: ProjectSwing

---

## Final Notes

- Terraform state files should not be committed in production repositories
- Always review `terraform plan` before apply
- Use remote state for team collaboration

---

✅ Enterprise‑grade  
✅ Upgrade‑safe  
