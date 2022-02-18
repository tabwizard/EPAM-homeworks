################################################################################
# Instances
################################################################################
resource "aws_instance" "wordpress-a" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu_server.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tabwizard.key_name
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id] 
  subnet_id              = aws_subnet.wordpress-subnet-2a.id
  depends_on             = [aws_internet_gateway.wordpress-gw]
  user_data = <<-EOF
    #!/usr/bin/env bash
    sudo apt-get update -y
    sudo apt-get install -y apache2
    myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script!"  >  /var/www/html/index.html
    sudo ufw allow 'Apache'
    sudo systemctl enable --now apache2.service
    ping -c 4 ya.ru
  EOF
  tags = {
    Name = "${local.name}-a"
  }
}

resource "aws_instance" "wordpress-b" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu_server.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tabwizard.key_name
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
  subnet_id              = aws_subnet.wordpress-subnet-2b.id
  depends_on             = [aws_internet_gateway.wordpress-gw]
  user_data = <<-EOF
    #!/usr/bin/env bash
    sudo apt-get update -y
    sudo apt-get install -y apache2
    myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script!"  >  /var/www/html/index.html
    sudo ufw allow 'Apache'
    sudo systemctl enable --now apache2.service
    ping -c 4 ya.ru
  EOF
  tags = {
    Name = "${local.name}-b"
  }
}


# user_data = file("${path.module}/startup.sh")