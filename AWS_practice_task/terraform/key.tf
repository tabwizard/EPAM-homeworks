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
