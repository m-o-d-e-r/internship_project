
resource "aws_key_pair" "web_key_pair" {
  key_name   = "web_instance_key"
  public_key = var.web_public_key
}


resource "aws_subnet" "web_subnet" {
  vpc_id     = aws_vpc.schedule_vpc.id
  cidr_block = "192.168.100.0/24"

  tags = {
    Name = "web-subnet"
  }
}


resource "aws_route_table_association" "web_public_route_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_instance" "web" {
  ami           = var.vm_ami
  instance_type = "t2.micro"

  key_name = aws_key_pair.web_key_pair.key_name

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.web_subnet.id
  vpc_security_group_ids = [
    aws_security_group.schedule_security_group.id
  ]

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  tags = {
    Name = "web"
  }

  user_data_replace_on_change = true
  user_data = templatefile("./config/web_cloud_init.yaml", {
    web_public_key        = var.web_public_key
    sftp_instance_ip      = aws_instance.sftp.private_ip
    sftp_user_private_key = base64encode(file("./keys/id_ed25519"))
    download_web_tar      = base64encode(file("./scripts/download_web_tar.sh"))
  })

  depends_on = [
    aws_instance.sftp
  ]
}
