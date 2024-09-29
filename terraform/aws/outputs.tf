
output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "sftp_instance_public_ip" {
  value = aws_instance.sftp.public_ip
}

output "api_instance_public_ip" {
  value = aws_instance.api.public_ip
}
