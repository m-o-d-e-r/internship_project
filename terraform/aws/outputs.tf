
output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "sftp_instance_public_ip" {
  value = aws_instance.sftp.public_ip
}

output "api_instance_public_ip" {
  value = aws_instance.api.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

#output "mongo_endpoint" {
#  value = aws_docdb_cluster_instance.mongo_cluster_instance.endpoint
#}
