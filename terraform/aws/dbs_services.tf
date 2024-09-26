# TODO: configure network

# redis configuration
resource "aws_elasticache_cluster" "redis" {
  provider = aws.eu-north-1
  cluster_id           = "schedule-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis4.0"
  engine_version       = "4.0.10"
  port                 = 6379
}
# redis configuration end


# postgres configuration
resource "aws_db_instance" "postgres" {
  provider = aws.eu-north-1
  allocated_storage    = 10
  db_name              = "schedule" # get from env
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t4g.micro"
  username             = "super_mega_user" # get from env
  password             = "password"        # get from env
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
}
# postgres configuration end


# mongo configuration
resource "aws_docdb_cluster" "default" {
  provider = aws.eu-west-2
  cluster_identifier      = "schedule-docdb"
  engine                  = "docdb"
  engine_version          = "5.0"
  master_username         = "username"
  master_password         = "password"
}

resource "aws_docdb_cluster_instance" "cluster_instance" {
  provider = aws.eu-west-2
  count              = 1
  identifier         = "schedule-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.default.id
  instance_class     = "db.t3.medium"
}
# mongo configuration end
