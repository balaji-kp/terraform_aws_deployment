resource "aws_eip" "lb" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "NAT_GATEWAY" {

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.lb.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.web-tier-sub1.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
}