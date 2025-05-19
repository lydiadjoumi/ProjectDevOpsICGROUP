resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_file" {
  filename        = var.filename
  content         = tls_private_key.tls_key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.tls_key.public_key_openssh
}
