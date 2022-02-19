################################################################################
# Key
################################################################################

resource "tls_private_key" "aws_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.key_name}"
  public_key = tls_private_key.aws_key.public_key_openssh
} 

resource "local_file" "public_key_openssh" {
  content  = tls_private_key.aws_key.public_key_openssh
  filename = "./keys/${var.key_name}.pub"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.aws_key.private_key_pem
  filename = "./keys/${var.key_name}.pem"
}

resource "null_resource" "chmod" {
  depends_on = [local_file.private_key_pem]

  triggers = {
    key = tls_private_key.aws_key.private_key_pem
  }

  provisioner "local-exec" {
    command = "chmod 600 ./keys/${var.key_name}.pem"
  }
}

resource "null_resource" "delete_folder" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ./keys"
  }
}
