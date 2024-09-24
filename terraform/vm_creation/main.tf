
resource "libvirt_volume" "fedora_iso" {
  name   = "fedora_image"
  source = "${path.module}/os_image/${var.vm_os_image_name}"
  format = var.vm_os_image_format
}

resource "libvirt_volume" "fedora_disk" {
  name = "fedora_disk"
  size = "21474836480"
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.yml")
}

resource "libvirt_cloudinit_disk" "fedora_cloud_init" {
  name      = "fedora_cloudinit.iso"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_network" "schedule_app_network" {
  name = "schedule_app_network"

  mode   = "bridge"
  bridge = "virbr0"
}

resource "libvirt_domain" "schedule_app" {
  name = var.vm_name

  cloudinit = libvirt_cloudinit_disk.fedora_cloud_init.id

  vcpu = var.vm_vcpu
  cpu {
    mode = "host-passthrough"
  }

  memory = var.vm_memory

  network_interface {
    network_id     = libvirt_network.schedule_app_network.id
    hostname       = "mega-host"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.fedora_iso.id
    scsi      = true
  }

  disk {
    volume_id = libvirt_volume.fedora_disk.id
  }
}
