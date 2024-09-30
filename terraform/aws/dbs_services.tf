# TODO: configure network

resource "aws_subnet" "dbs_subnet_1" {
  vpc_id            = aws_vpc.schedule_vpc.id
  cidr_block        = "192.168.10.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "dbs-subnet-1"
  }
}

resource "aws_subnet" "dbs_subnet_2" {
  vpc_id            = aws_vpc.schedule_vpc.id
  cidr_block        = "192.168.20.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "dbs-subnet-2"
  }
}

resource "aws_route_table_association" "dbs1_public_route_association" {
  subnet_id      = aws_subnet.dbs_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "dbs2_public_route_association" {
  subnet_id      = aws_subnet.dbs_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}



# redis configuration
resource "aws_elasticache_subnet_group" "schedule_redis_subnet_group" {
  name = "schedule-redis-subnet-group"

  subnet_ids = [
    aws_subnet.dbs_subnet_1.id,
    aws_subnet.dbs_subnet_2.id
  ]

  tags = {
    Name = "schedule-redis-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "schedule-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis4.0"
  engine_version       = "4.0.10"
  port                 = 6379

  security_group_ids = [
    aws_security_group.dbs_security_group.id,
    aws_security_group.schedule_security_group.id
  ]

  subnet_group_name = aws_elasticache_subnet_group.schedule_redis_subnet_group.name
}
# redis configuration end


# postgres configuration
resource "aws_db_subnet_group" "schedule_db_subnet_group" {
  name = "schedule-db-subnet-group"
  subnet_ids = [
    aws_subnet.dbs_subnet_1.id,
    aws_subnet.dbs_subnet_2.id
  ]

  tags = {
    Name = "schedule-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 10
  db_name              = "schedule" # get from env
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t4g.micro"
  username             = "super_mega_user" # get from env
  password             = "password"        # get from env
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.dbs_security_group.id,
    aws_security_group.schedule_security_group.id
  ]

  db_subnet_group_name = aws_db_subnet_group.schedule_db_subnet_group.name
}
# postgres configuration end


# mongo configuration
#resource "aws_db_subnet_group" "schedule_mongo_subnet_group" {
#  name = "schedule-mongo-subnet-group"
#  subnet_ids = [
#    aws_subnet.dbs_subnet_1.id,
#    aws_subnet.dbs_subnet_2.id
#  ]
#
#  tags = {
#    Name = "schedule-mongo-subnet-group"
#  }
#}
#
#resource "aws_docdb_cluster" "mongo_cluster" {
#  cluster_identifier  = "schedule-docdb"
#  engine              = "docdb"
#  engine_version      = "4.0"
#  master_username     = "username"
#  master_password     = "password"
#  port                = 27017
#  skip_final_snapshot = true
#
#  vpc_security_group_ids = [
#    aws_security_group.dbs_security_group.id,
#    aws_security_group.schedule_security_group.id
#  ]
#
#  db_subnet_group_name = aws_db_subnet_group.schedule_mongo_subnet_group.name
#}
#
#resource "aws_docdb_cluster_instance" "mongo_cluster_instance" {
#  identifier         = "schedule-docdb-instance"
#  cluster_identifier = aws_docdb_cluster.mongo_cluster.id
#  instance_class     = "db.t3.medium"
#}
# mongo configuration end
