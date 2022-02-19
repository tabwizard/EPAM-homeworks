################################################################################
# VPC 
################################################################################

resource "aws_vpc" "wordpress-vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

################################################################################
# Subnets 
################################################################################

resource "aws_subnet" "wordpress-subnet" {  
  count             = length(var.az)
  vpc_id            = aws_vpc.wordpress-vpc.id
  cidr_block        = "${var.subnet_cidr[count.index]}"
  availability_zone = "${var.region}${var.az[count.index]}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.name}-subnet-2${var.az[count.index]}"
  }
}

resource "aws_db_subnet_group" "wordpress-db-subnet" {
  name       = "wordpress-db-subnet"
  subnet_ids = [aws_subnet.wordpress-subnet[0].id, aws_subnet.wordpress-subnet[1].id]
  tags = {
    Name = "wordpress-db-subnet"
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

#  Routing table for default internet gateway
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

#  Route table associations 
resource "aws_route_table_association" "subnet-association" {
  count          = length(var.az)
  subnet_id      = "${aws_subnet.wordpress-subnet[count.index].id}"
  route_table_id = "${aws_route_table.wordpress-route-table.id}"
}
