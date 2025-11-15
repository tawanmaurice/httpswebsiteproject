#These are   for  public

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.112.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "main-vpc"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.112.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "main-vpc"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}


resource "aws_subnet" "public-us-east-1c" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.112.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name    = "main-vpc"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}

#these are for private
resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.112.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name    = "main-vpc"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.112.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name    = "main-vpc"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}


resource "aws_subnet" "private-us-east-1c" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.112.13.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name    = "main-vpc"
    Service = "dev"
    Owner   = "Tawan"
    Planet  = "terraform-training"
  }
}