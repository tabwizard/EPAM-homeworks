################################################################################
# Security group
################################################################################

resource "aws_security_group" "wordpress-sg" {
  name        = "${var.name}-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
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
}

resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
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
}

################################################################################
# VPC 
################################################################################

resource "aws_vpc" "wordpress-vpc" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

################################################################################
# Subnets 
################################################################################

resource "aws_subnet" "wordpress-subnet" {     # -2a
  count             = length(var.az)
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "${var.subnet_cidr[count.index]}"
  availability_zone = "${var.region}${var.az[count.index]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.name}-subnet-2${var.az[count.index]}"
  }
}

################################################################################
# Internet gateway and Routing
################################################################################

resource "aws_internet_gateway" "wordpress-gw" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"

  tags = {
    Name = "${var.name}-gw"
  }
}

/* Routing table for default internet gateway */
resource "aws_route_table" "wordpress-route-table" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.wordpress-gw.id}"
  }
  tags = {
    Name = "${var.name}-route-table"
  }
}

/* Route table associations */
resource "aws_route_table_association" "subnet-association" {
  count          = length(var.az)
  subnet_id      = "${aws_subnet.wordpress-subnet[count.index].id}"
  route_table_id = "${aws_route_table.wordpress-route-table.id}"
}
