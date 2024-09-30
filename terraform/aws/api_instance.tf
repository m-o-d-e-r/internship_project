
resource "aws_key_pair" "api_key_pair" {
  provider = aws.eu-north-1

  key_name   = "api_instance_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAf6V4g7ahli0x4Z8D3cbC3ZeT5li7p63zldIU0Wcijj"
}


resource "aws_subnet" "api_subnet" {
  provider = aws.eu-north-1

  vpc_id     = aws_vpc.schedule_vpc.id
  cidr_block = "192.168.200.0/24"

  tags = {
    Name = "api-subnet"
  }
}


resource "aws_route_table_association" "api_public_route_association" {
  subnet_id      = aws_subnet.api_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_instance" "api" {
  provider = aws.eu-north-1

  ami           = "ami-0129bfde49ddb0ed6" # Amazon Linux
  instance_type = "t3.micro"

  key_name = aws_key_pair.api_key_pair.key_name

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.api_subnet.id
  vpc_security_group_ids = [
    aws_security_group.schedule_security_group.id
  ]

  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
  }

  tags = {
    Name = "api"
  }

  user_data_replace_on_change = true
  user_data = templatefile("./config/api_cloud_init.yaml", {
    sftp_instance_ip      = aws_instance.sftp.private_ip,
    sftp_user_private_key = base64encode(file("./keys/id_ed25519"))
    download_api_tar      = base64encode(file("./scripts/download_api_tar.sh"))
  })

  depends_on = [
    aws_instance.sftp
  ]
}