
output "vm_ip" {
  value = libvirt_domain.schedule_app.network_interface[0].addresses[0]
}
