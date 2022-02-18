################################################################################
# EFS File System
################################################################################

resource "aws_efs_file_system" "wordpress-efs" {
   creation_token = "aws_key"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "${var.name}-EFS"
   }
 }


resource "aws_efs_mount_target" "efs-mt" {
   count = length(var.az)
   file_system_id  = aws_efs_file_system.wordpress-efs.id
   subnet_id = aws_subnet.wordpress-subnet[count.index].id
   security_groups = [aws_security_group.efs-sg.id]
 }

 
 # apt-get install -y nfs-common
 # yum -y install nfs-utils
