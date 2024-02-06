#creating mysql-rds 
resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10
  db_name              = "fullstack"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.mysqlSG.id]
  skip_final_snapshot  = true
}
resource "aws_security_group" "mysqlSG" {
  name_prefix = "mysqlSG"
  ingress {
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
