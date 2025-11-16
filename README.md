# HTTPS Auto Scaling Website – Terraform + Route 53 + ACM

This project deploys a **highly available, HTTPS-protected web application** on AWS using **Terraform only** (no console clicks once configured).

The stack includes:

- A custom domain: **https://site.tawanperry.top**
- An **Application Load Balancer (ALB)** terminating HTTPS
- An **Auto Scaling Group (ASG)** of EC2 instances in private subnets
- **Route 53** DNS with an alias record pointing to the ALB
- **ACM** (AWS Certificate Manager) certificate with DNS validation
- A custom VPC with public / private subnets, Internet Gateway, and NAT Gateway

> This project is meant to show real-world AWS infrastructure skills, not just a single EC2 instance.

---

## Architecture Overview

**Region:** `us-east-1`

**Main components**

- **VPC `app1`**
  - 3 × public subnets (for ALB & NAT)
  - 3 × private subnets (for EC2 instances / ASG)
  - Internet Gateway + public route table
  - NAT Gateway + private route table

- **Security Groups**
  - `app1-sg02-LB01`: ALB security group  
    - Inbound: 80/443 from the Internet  
    - Outbound: to EC2 security group
  - `app1-sg01-servers`: EC2 instances  
    - Inbound: 80 from ALB security group  
    - Outbound: full Internet via NAT

- **Compute**
  - **Launch Template** `app1_LT`  
    - Amazon Linux 2
    - User data installs a web server and serves a sample page
  - **Auto Scaling Group** `app1_asg`  
    - Min: 1, Desired: 2, Max: 3
    - Spans the three private subnets
    - Target tracking policy on **ASG average CPU (75%)**

- **Load Balancing**
  - **ALB** `app1-load-balancer`
    - Public, internet-facing
    - Listeners:
      - `80` → redirect to HTTPS (301)
      - `443` → forward to target group
  - **Target Group** `app1-target-group`
    - Target type: `instance`
    - Port: 80
    - Health checks on `/` with HTTP 200 expected

- **DNS & TLS**
  - **Route 53 hosted zone**: `tawanperry.top`
  - **A record alias**: `site.tawanperry.top` → ALB
  - **ACM certificate** requested in `us-east-1`
  - DNS validation wired using a `CNAME` record managed by Terraform

---

## Terraform Layout

Key files:

- `1-vpc.tf` – VPC, subnets, route tables, IGW, NAT
- `4-nat.tf` – Elastic IP + NAT Gateway & private routes
- `6-sg01-all.tf` – Security groups for ALB and EC2 instances
- `7-launchtemplate.tf` – Launch template with user data
- `8-targetgroup.tf` – ALB target group and health checks
- `9-loadbalancer.tf` – ALB and listeners
- `10-autoscalinggroup.tf` – Auto Scaling Group + scaling policy
- `11-route53.tf` – Hosted zone data + Route 53 alias record
- `12-acm-https.tf` – ACM certificate & DNS validation record
- `variables.tf` / `terraform.tfvars` – Inputs like CIDR blocks, instance type, etc.

**Important:** the repo **does not** track:

- `.terraform/`
- `terraform.tfstate` / `terraform.tfstate.backup`
- Provider binaries (like the ~247MB `terraform-provider-aws_*.exe`)

Those are all ignored and removed from Git history using `git-filter-repo`.

---

## How to Deploy

From the project folder:

```bash
terraform init          # download providers, set up backend
terraform plan          # preview changes
terraform apply         # deploy infrastructure
# when prompted:
# Enter a value: yes
