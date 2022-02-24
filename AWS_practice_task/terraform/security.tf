################################################################################
# Security group
################################################################################

#  security group for EC2 instances
resource "aws_security_group" "wordpress-sg" {
  name        = "${var.name}-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = "${aws_vpc.wordpress-vpc.id}"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      security_groups = [aws_security_group.alb-sg.id]
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
    }
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.ssh_access_ip}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-sg"
  }
}

#  security group for load balancer
resource "aws_security_group" "alb-sg" {
  name        = "${var.name}-alb-sg"
  description = "Allow HTTP, HTTPS  load balancer security group"
  vpc_id      = "${aws_vpc.wordpress-vpc.id}"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-alb-sg"
  }
}

#  security group for access to EFS from EC2
resource "aws_security_group" "efs-sg" {
  name        = "${var.name}-efs-sg"
  description = "Allow inbound efs traffic from ec2"
  vpc_id      = "${aws_vpc.wordpress-vpc.id}"

  ingress {
    security_groups = [aws_security_group.wordpress-sg.id]
    from_port       = 2049
    to_port         = 2049 
    protocol        = "tcp"
  }     
  egress {
    security_groups = [aws_security_group.wordpress-sg.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
    Name = "${var.name}-efs-sg"
  }
} 

#  security group for access to MYSQL from EC2
resource "aws_security_group" "db-sg" {
  name        = "${var.name}-db-sg"
  description = "Allow inbound mysql traffic from ec2"
  vpc_id      = "${aws_vpc.wordpress-vpc.id}"

  ingress {
    security_groups = [aws_security_group.wordpress-sg.id]
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
  }
  egress {
    security_groups = [aws_security_group.wordpress-sg.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
    Name = "${var.name}-db-sg"
  }
}
