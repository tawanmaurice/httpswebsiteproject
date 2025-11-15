# this  makes  vpc.id which is aws_vpc.app1.id
resource "aws_vpc" "app1" {
  cidr_block = "10.112.0.0/16"

  tags = {
    Name = "main-vpc"
    Service = "dev"
    Owner = "Tawan"
    Planet = "terraform-training"
  }
}