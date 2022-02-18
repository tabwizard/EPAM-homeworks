################################################################################
# Security group
################################################################################

resource "aws_security_group" "wordpress-sg" {
  name        = "${local.name}-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = "${aws_vpc.wordpress-vpc.id}"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
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

  # Allow all outbound traffic.
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
    Name = "${local.name}-vpc"
  }
}

################################################################################
# Subnets 
################################################################################

resource "aws_subnet" "wordpress-subnet-2a" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "10.2.1.0/24"
  availability_zone = "${local.region}a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${local.name}-subnet-2a"
  }
}

resource "aws_subnet" "wordpress-subnet-2b" {
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "10.2.2.0/24"
  availability_zone = "${local.region}b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${local.name}-subnet-2b"
  }
}

################################################################################
# Internet gateway and Routing
################################################################################

resource "aws_internet_gateway" "wordpress-gw" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"

  tags = {
    Name = "${local.name}-gw"
  }
}

/* Routing table for private subnets */
resource "aws_route_table" "wordpress-route-table" {
  vpc_id = "${aws_vpc.wordpress-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.wordpress-gw.id}"
  }
  tags = {
    Name = "${local.name}-route-table"
  }
}

/* Route table associations */
resource "aws_route_table_association" "subnet-2a" {
  subnet_id      = "${aws_subnet.wordpress-subnet-2a.id}"
  route_table_id = "${aws_route_table.wordpress-route-table.id}"
}
resource "aws_route_table_association" "subnet-2b" {
  subnet_id      = "${aws_subnet.wordpress-subnet-2b.id}"
  route_table_id = "${aws_route_table.wordpress-route-table.id}"
}

