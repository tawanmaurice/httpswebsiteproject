########################################
# NAT Gateway + Elastic IP
########################################

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]  # ensure IGW exists first

  tags = {
    Name    = "nat-eip"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}

# NAT Gateway in a PUBLIC subnet (required)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name    = "nat-gateway"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }

  depends_on = [aws_eip.nat]
}

