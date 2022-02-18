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
  depends_on             = [aws_internet_gateway.wordpress-gw, aws_efs_mount_target.efs-mt]
  user_data = <<-EOF
    #!/usr/bin/env bash
    sudo apt-get update -y
    sudo mkdir -p /var/www/html
    sudo apt-get install -y nfs-common
    mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${aws_efs_file_system.wordpress-efs.id}".efs."${var.region}".amazonaws.com:/ /var/www/html
    sudo apt-get install -y apache2
    myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script!"  >  /var/www/html/index"${count.index}".html
    sudo ufw allow 'Apache'
    sudo systemctl enable --now apache2.service
    echo "${aws_efs_file_system.wordpress-efs.id}".efs."${var.region}".amazonaws.com:/ /var/www/html nfs4 defaults,_netdev 0 0 | sudo tee --append /etc/fstab
  EOF
  tags = {
    Name = "${var.name}-${var.az[count.index]}"
  }
}

# user_data = file("${path.module}/startup.sh")
