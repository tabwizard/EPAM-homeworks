################################################################################
# Instances
################################################################################
resource "aws_instance" "wordpress" {
  count                  = length(var.az)
  ami                    = data.aws_ami.ubuntu_server.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id] 
  subnet_id              = aws_subnet.wordpress-subnet[count.index].id
  depends_on             = [aws_internet_gateway.wordpress-gw, aws_efs_mount_target.efs-mt, aws_db_instance.wordpress-db]
  user_data = <<-EOF
    #!/usr/bin/env bash
    sudo apt-get update -y
    sudo mkdir -p /var/www/html
    sudo apt-get install -y nfs-common
    mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${aws_efs_file_system.wordpress-efs.id}".efs."${var.region}".amazonaws.com:/ /var/www/html
    sudo apt-get install -y apache2 php php-mysql php-dom php-gd
    sudo apt-get install -y php-{pear,cgi,common,curl,mbstring,mysqlnd,bcmath,json,xml,intl,zip,imap,imagick}
    sudo chown -R ubuntu:www-data /var/www
    sudo find /var/www -type d -exec chmod 2775 {} \;
    sudo find /var/www -type f -exec chmod 0664 {} \;
    sudo ufw allow 'Apache'
    sudo systemctl enable --now apache2.service
    cd /tmp
    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm /tmp/latest.tar.gz
    cd /var/www/html
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${var.db_name}/g" wp-config.php
    sed -i "s/username_here/${var.db_admin}/g" wp-config.php
    sed -i "s/password_here/${var.db_password}/g" wp-config.php
    sed -i "s/localhost/${aws_db_instance.wordpress-db.address}/g" wp-config.php
    cat <<EOF2 >>/var/www/html/wp-config.php
      define( 'FS_METHOD', 'direct' );
      define('WP_MEMORY_LIMIT', '256M');
    EOF2
    chown -R ubuntu:www-data /var/www/html
    chmod -R 774 /var/www/html
    rm /var/www/html/index.html
    sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
    cat <<EOF3 >/var/www/html/ip.php
    <?php
    \$localIP = getHostByName(getHostName());
    echo "Server IP: ";
    echo \$localIP;
    ?>
    EOF3
    sleep 30
    sudo systemctl restart apache2.service
    echo "${aws_efs_file_system.wordpress-efs.id}".efs."${var.region}".amazonaws.com:/ /var/www/html nfs4 defaults,_netdev 0 0 | sudo tee --append /etc/fstab
  EOF
  tags = {
    Name = "${var.name}-${var.az[count.index]}"
  }
}
