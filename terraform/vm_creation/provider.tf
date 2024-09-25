terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.0"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}
