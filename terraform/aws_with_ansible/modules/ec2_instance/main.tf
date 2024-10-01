
resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type

  key_name = var.key_name

  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  tags = {
    Name = var.instance_name
  }
}
