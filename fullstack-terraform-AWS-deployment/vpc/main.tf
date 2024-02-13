# custum vpc creation

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat_gatway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.10.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

}

resource "aws_subnet" "web-tier-sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

}

resource "aws_subnet" "web-tier-sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
}
resource "aws_subnet" "app-tier-sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "app-tier-sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.3.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "db-tier-sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.5.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
}
resource "aws_subnet" "db-tier-sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "11.0.6.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "public-subnet-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "web-tier-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gatway.id
  }
}

resource "aws_route_table" "app-tier-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gatway.id
  }
}

resource "aws_route_table" "db-tier-RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gatway.id
  }
}

resource "aws_route_table_association" "rta0" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-subnet-RT.id
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.web-tier-sub1.id
  route_table_id = aws_route_table.web-tier-RT.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.web-tier-sub2.id
  route_table_id = aws_route_table.web-tier-RT.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.app-tier-sub1.id
  route_table_id = aws_route_table.app-tier-RT.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.app-tier-sub2.id
  route_table_id = aws_route_table.app-tier-RT.id
}

resource "aws_route_table_association" "rta5" {
  subnet_id      = aws_subnet.db-tier-sub1.id
  route_table_id = aws_route_table.db-tier-RT.id
}
resource "aws_route_table_association" "rta6" {
  subnet_id      = aws_subnet.db-tier-sub2.id
  route_table_id = aws_route_table.db-tier-RT.id
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "Web-sg"
  }
}
