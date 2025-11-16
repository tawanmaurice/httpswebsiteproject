# HTTPS Auto Scaling Web App on AWS (Terraform)

This project shows how I used **Terraform** to build a **highly available, HTTPS-secured web application** on AWS with:

- A custom domain (example): `https://site.tawanperry.top`
- An **Application Load Balancer (ALB)** handling HTTP and HTTPS
- An **Auto Scaling Group (ASG)** of EC2 instances
- **ACM (AWS Certificate Manager)** for TLS certificates
- **Route 53** for DNS and certificate validation
- A **user data script** that serves a simple web page from each instance

---

## 1. What I Built (High Level)

**Goal:** Deploy a small web app that:

- Runs on multiple EC2 instances in an **Auto Scaling Group**
- Is fronted by an **Application Load Balancer**
- Is reachable via a **friendly domain name** with valid **HTTPS**
- Can automatically **recover and scale** when instances fail or load increases

**Key AWS resources (via Terraform):**

### VPC + Subnets
- 1 VPC for isolation
- Public and private subnets across multiple AZs for high availability

### Security Groups
- **ALB SG**  
  - Allows inbound HTTP (80) and HTTPS (443) from the internet
- **EC2 SG**  
  - Only allows inbound HTTP from the ALB SG

### Launch Template + Auto Scaling Group
- Launch template includes:
  - AMI, instance type
  - SSH key pair (optional)
  - Security group
  - **User data script** (installs web server and serves a basic page)
- Auto Scaling Group:
  - Spans multiple subnets
  - Uses a target group for health checks
  - Has scaling policy based on CPU utilization

### Application Load Balancer (ALB)
- Internet-facing ALB
- HTTP listener (port 80)
  - Redirects HTTP → HTTPS
- HTTPS listener (port 443) using ACM certificate
- Forwards to a target group that contains the ASG instances

### ACM Certificate + Validation
- Public cert for the app domain  
- DNS validation via a Route 53 CNAME record

### Route 53
- Hosted zone for `tawanperry.top` (existing)
- CNAME record for ACM validation
- **A (alias) record** that points `site.tawanperry.top` to the ALB

---

## 2. Folder Structure

```text
httpswebsite/
├── 0-auth.tf              # Provider + backend (if used)
├── 1-vpc.tf               # VPC and basic networking
├── 2-subnets.tf           # Public + private subnets
├── 3-igw.tf               # Internet gateway and routes
├── 4-nat.tf               # NAT gateway for private subnets
├── 5-route.tf             # Route tables + associations
├── 6-sg01-all.tf          # Security groups (ALB + EC2)
├── 7-launchtemplate.tf    # EC2 launch template (user data, SG, AMI, type)
├── 8-targetgroup.tf       # Target group for the ALB
├── 9-loadbalancer.tf      # Application Load Balancer + listeners
├── 10-autoscalinggroup.tf # Auto Scaling Group definition
├── 11-route53.tf          # DNS records (ALB alias + ACM validation)
├── 12-acm-https.tf        # ACM certificate + validation
├── variables.tf           # Input variables
├── terraform.tfvars       # Local, not committed (contains my values)
└── README.md

3. Step-by-Step: How I Built This (Perfect Flow)

This describes the clean, ideal workflow — no debugging steps, just the correct build sequence.

Step 1 — Initialize the Project

Create a project folder and Terraform file structure.
Add provider info:

provider "aws" {
  region = var.aws_region
}


Define variables inside variables.tf:

variable "aws_region" {}
variable "project_name" {}
variable "owner" {}

variable "domain_name" {}
variable "hosted_zone_id" {}

variable "instance_type" {}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}


Create terraform.tfvars:

aws_region     = "us-east-1"
project_name   = "httpswebsite"
owner          = "Tawan"

domain_name    = "site.tawanperry.top"
hosted_zone_id = "Z08251753K2EPRDDMCRCV"

instance_type    = "t3.micro"
desired_capacity = 2
min_size         = 1
max_size         = 3

Step 2 — Build Networking

Using files 1–5:

Create VPC

Create public and private subnets

Create Internet Gateway

Create NAT Gateway

Add route tables + associations

This provides high-availability networking across AZs.

Step 3 — Security Groups

In 6-sg01-all.tf:

ALB SG → allow 80/443 from everyone

EC2 SG → allow port 80 only from ALB SG

This ensures secure, layered access.

Step 4 — Launch Template & Auto Scaling Group

Launch Template

Select AMI

Set instance type

Add EC2 SG

User data script:

#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo "<h1>Samurai Katana — Tawan Perry, Cloud Engineer</h1>" > /var/www/html/index.html
echo "Served from $(hostname -f)" >> /var/www/html/index.html


ASG

Subnets → private subnets

Reference launch template

Attach Target Group

Add scaling policy if needed

Step 5 — Application Load Balancer

In 9-loadbalancer.tf:

Internet-facing ALB

Public subnets

ALB SG

Listeners:

HTTP (80) → redirect to HTTPS

HTTPS (443) → forward to target group

In 8-targetgroup.tf:

Target type: instance

Health check: /

Step 6 — HTTPS with ACM

In 12-acm-https.tf:

Request certificate for the domain:

domain_name = var.domain_name
validation_method = "DNS"


Terraform automatically reads ACM validation options and creates the corresponding CNAME record in Route 53.

Then aws_acm_certificate_validation finalizes the certificate.

Step 7 — Route 53 DNS

In 11-route53.tf:

CNAME record for ACM validation

A (alias) record for the ALB:

alias {
  name                   = aws_lb.app1_alb.dns_name
  zone_id                = aws_lb.app1_alb.zone_id
  evaluate_target_health = true
}


This ties the ALB to your domain.

Step 8 — Deploy with Terraform

Run:

terraform fmt
terraform init
terraform validate
terraform plan
terraform apply


Terraform will build the full environment:

Networking

Security

Launch template

ASG

ALB

HTTPS certificate

DNS validation

Domain pointing to ALB

Visit the domain:

https://site.tawanperry.top


You will see your custom web page served from the EC2 instance.

4. Tear Down
terraform destroy


Destroys all infrastructure safely.

5. What This Demonstrates (For Recruiters)

Full Infrastructure-as-Code (IaC) project

Multi-AZ, highly available architecture

Real-world ALB + ASG pattern

Complete HTTPS/TLS implementation

Automated DNS validation

Scalable web application built the same way companies deploy production apps

This project shows capability in modern AWS deployments and Terraform-based automation.
