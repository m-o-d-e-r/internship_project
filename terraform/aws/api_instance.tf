
resource "aws_key_pair" "api_key_pair" {
  key_name   = "api_instance_key"
  public_key = var.api_public_key
}


resource "aws_subnet" "api_subnet" {
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
  ami           = var.vm_ami
  instance_type = "t2.micro"

  key_name = aws_key_pair.api_key_pair.key_name

  associate_public_ip_address = true
  subnet_id                   = aws_subnet.api_subnet.id
  vpc_security_group_ids = [
    aws_security_group.schedule_security_group.id,
    aws_security_group.dbs_security_group.id
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
    update_hosts          = base64encode(file("./scripts/update_hosts.sh"))
    db_address            = aws_db_instance.postgres.address
    redis_address         = aws_elasticache_cluster.redis.cache_nodes[0].address
#    mongo_address         = aws_docdb_cluster_instance.mongo_cluster_instance.endpoint
    restore_db_script     = base64encode(file("./scripts/restore_db.sh"))
  })

  depends_on = [
    aws_instance.sftp,
    aws_db_instance.postgres,
    aws_elasticache_cluster.redis,
#    aws_docdb_cluster_instance.mongo_cluster_instance
  ]
}
