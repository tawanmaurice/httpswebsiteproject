# HTTPS Auto Scaling Web App on AWS (Terraform)

This project shows how I used **Terraform** to build a **highly available, HTTPS-secured web application** on AWS with:

- A custom domain: **https://site.tawanperry.top**
- An **Application Load Balancer (ALB)** handling HTTP and HTTPS
- An **Auto Scaling Group (ASG)** of EC2 instances
- **ACM** (AWS Certificate Manager) for TLS certificates
- **Route 53** for DNS and certificate validation
- A custom **user data** script that serves a simple web page from each instance

---

## 1. What I Built (High-Level)

**Goal:** Deploy a small web app that:

- Runs on multiple EC2 instances in an **Auto Scaling Group**
- Is fronted by an **Application Load Balancer**
- Is reachable via a **friendly domain name** with **valid HTTPS**
- Can automatically recover and scale when instances fail or load increases

**Key AWS resources (via Terraform):**

- **VPC + Subnets**
  - 1 VPC for isolation
  - Public and private subnets across multiple AZs (for HA)

- **Security Groups**
  - ALB SG: allows inbound HTTP (80) and HTTPS (443) from the internet
  - EC2 SG: only allows inbound HTTP from the ALB SG

- **Launch Template + Auto Scaling Group**
  - Launch template defines:
    - AMI, instance type, key pair
    - Security group
    - **User data** script (installs web server + serves a basic page)
  - Auto Scaling Group:
    - Spans multiple subnets
    - Uses a target group for health checks
    - Has scaling policy based on CPU utilization

- **Application Load Balancer (ALB)**
  - Internet-facing ALB
  - HTTP listener (port 80)
  - HTTPS listener (port 443) using ACM certificate
  - Forwards to the target group that contains ASG instances

- **ACM Certificate + Validation**
  - Public cert for `site.tawanperry.top`
  - DNS validation via a Route 53 CNAME record

- **Route 53**
  - Hosted zone for `tawanperry.top` (existing)
  - CNAME record for **ACM validation**
  - A-record alias that points `site.tawanperry.top` to the ALB

---

## 2. Folder Structure

```text
httpswebsite/
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
  ├── terraform.tfvars        # local, not committed (contains my values)
  ├── .gitignore
  └── README.md
