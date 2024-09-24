terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "fedora_iso" {
  name   = "fedora_image"
  source = "${path.module}/os_image/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"
  format = "qcow2"
}

resource "libvirt_volume" "fedora_disk" {
  name = "fedora_disk"
  size = "21474836480"
}

data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.yml")
}

resource "libvirt_cloudinit_disk" "fedora_cloud_init" {
  name           = "fedora_cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
}

resource "libvirt_network" "schedule_app_network" {
  name = "schedule_app_network"

  mode = "bridge"
  bridge = "virbr0"
}

resource "libvirt_domain" "schedule_app" {
  name = "schedule_app"

  cloudinit = libvirt_cloudinit_disk.fedora_cloud_init.id

  vcpu = 2
  cpu {
    mode = "host-passthrough"
  }

  memory = "2048"

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
