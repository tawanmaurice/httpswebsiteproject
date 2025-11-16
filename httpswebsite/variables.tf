variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging"
}

variable "owner" {
  type        = string
  description = "Owner tag"
}

variable "domain_name" {
  type        = string
  description = "Full domain name for the app (e.g. site.tawanperry.top)"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 hosted zone ID for the root domain"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "desired_capacity" {
  type        = number
  description = "ASG desired capacity"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "ASG min size"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "ASG max size"
  default     = 3
}
