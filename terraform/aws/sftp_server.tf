
resource "aws_key_pair" "sftp_key_pair" {
  key_name   = "sftp_instance_key"
  public_key = var.sftp_public_key
}


resource "aws_subnet" "sftp_subnet" {
  vpc_id     = aws_vpc.schedule_vpc.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "sftp-subnet"
  }
}


resource "aws_route_table_association" "sftp_public_route_association" {
  subnet_id      = aws_subnet.sftp_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_instance" "sftp" {
  ami           = var.vm_ami
  instance_type = "t2.micro"

  key_name = aws_key_pair.sftp_key_pair.key_name

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.sftp_subnet.id
  vpc_security_group_ids = [
    aws_security_group.schedule_security_group.id,
    aws_security_group.dbs_security_group.id
  ]

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  tags = {
    Name = "sftp"
  }

  user_data_replace_on_change = true
  user_data = templatefile("./config/sftp_cloud_init.yaml", {
    sftp_public_key = var.sftp_public_key
  })

  provisioner "local-exec" {
    command = "REMOTE_SFTP_IP=${self.public_ip} make sync"
  }
}
