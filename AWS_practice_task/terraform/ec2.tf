################################################################################
# Instances
################################################################################
resource "aws_instance" "wordpress" {
  count                  = length(var.az)
  ami                    = data.aws_ami.ubuntu_server.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.aws_key.key_name
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id] 
  subnet_id              = aws_subnet.wordpress-subnet[count.index].id
  depends_on             = [aws_internet_gateway.wordpress-gw]
  user_data = <<-EOF
    #!/usr/bin/env bash
    sudo apt-get update -y
    sudo apt-get install -y apache2
    myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script!"  >  /var/www/html/index.html
    sudo ufw allow 'Apache'
    sudo systemctl enable --now apache2.service
  EOF
  tags = {
    Name = "${var.name}-${var.az[count.index]}"
  }
}

# user_data = file("${path.module}/startup.sh")
