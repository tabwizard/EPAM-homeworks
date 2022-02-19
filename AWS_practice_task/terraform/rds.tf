################################################################################
# RDS MYSQL
################################################################################
resource "aws_db_instance" "wordpress-db" {
  engine = "mysql"
  engine_version = "5.7"
  allocated_storage = 20
  instance_class = "db.t2.micro"
  multi_az = true
  db_subnet_group_name    = aws_db_subnet_group.wordpress-db-subnet.id
  vpc_security_group_ids = ["${aws_security_group.db-sg.id}"]
  db_name = "${var.db_name}"
  username = "${var.db_admin}"
  password = "${var.db_password}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  tags = {
    Name = "${var.db_name}"
  }
}
