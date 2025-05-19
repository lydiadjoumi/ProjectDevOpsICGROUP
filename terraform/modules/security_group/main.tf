resource "aws_security_group" "sg_project" {
  name = var.security_groups_name

  dynamic "ingress" {
    for_each = var.security_groups_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

  # Autoriser tout le trafic sortant
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_groups_name
  }
  module "security_group" {
  source                = "./modules/security_group"
  security_groups_name  = "my-sg"
  security_groups_ports = [22, 80, 443]
}

}
