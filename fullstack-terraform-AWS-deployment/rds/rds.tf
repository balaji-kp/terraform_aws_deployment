#creating mysql-rds 

resource "aws_db_instance" "my-test-sql" {
  instance_class          = "db.t3.micro"
  engine                  = "mysql"
  engine_version          = "5.7"
  multi_az                = false
  storage_type            = "gp2"
  allocated_storage       = 10
  username                = "admin"
  password                = "password"
  apply_immediately       = "true"
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids  = [aws_security_group.db-tier-sg.id]
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = [var.db-tier-sub1,var.db-tier-sub2]
}

resource "aws_security_group" "db-tier-sg" {
  name   = "db-tier-sg"
  vpc_id = var.vpc-id
}

resource "aws_security_group_rule" "my-rds-sg-rule" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.db-tier-sg.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_rule" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.db-tier-sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

