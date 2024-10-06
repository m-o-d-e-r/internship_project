
output "schedule_web" {
  value = module.schedule_web.instance_public_ip
}

output "schedule_api" {
  value = module.schedule_api.instance_public_ip
}

output "schedule_dbs" {
  value = module.schedule_dbs.instance_public_ip
}
