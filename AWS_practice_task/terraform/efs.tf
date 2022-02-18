################################################################################
# EFS File System
################################################################################

resource "aws_efs_file_system" "wordpress-efs" {
  creation_token = "my-product"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${local.name}-efs"
  }
}