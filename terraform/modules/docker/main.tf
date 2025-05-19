resource "aws_instance" "ec2_project" {
  ami                    = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  vpc_security_group_ids  = [var.security_group_id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  # On transfert le script docker.sh sur la machine distante
  provisioner "file" {
    source      = "${path.module}/../../script/docker.sh"
    destination = "/tmp/docker.sh"

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # On exécute le script docker.sh sur la machine distante
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/docker.sh",
      "sudo /tmp/docker.sh"
    ]

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # On enregistre l'IP publique localement
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ./ip/docker_ip.txt"
  }

  tags = {
    Name = var.instance_name
  }
}
