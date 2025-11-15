########################
# SG for EC2 instances
########################
resource "aws_security_group" "app1-sg01-servers" {
  name        = "app1-sg01-servers"
  description = "Allow HTTP from ALB to EC2 instances"
  vpc_id      = aws_vpc.app1.id

  # Allow HTTP from anywhere (simple version)
  # If you want to be stricter later, you can lock this
  # to the ALB SG instead of 0.0.0.0/0.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app1-sg01-servers"
    Owner   = "Tawan"
    Planet  = "terraform-training"
    Service = "dev"
  }
}

########################
# SG for ALB (what you already had)
########################
resource "aws_security_group" "app1-sg02-LB01" {
  name        = "app1-sg02-LB01"
  description = "Allow HTTP/HTTPS from the internet to ALB"
  vpc_id      = aws_vpc.app1.id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "app1-sg02-LB01"
    Owner   = "Tawan"
    Planet  = "terraform-training"
    Service = "dev"
  }
}
