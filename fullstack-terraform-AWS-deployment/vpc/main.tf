# custum vpc creation

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "web-tier-sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "web-tier-sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "app-tier-sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "app-tier-sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "web-tier-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "app-tier-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
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
