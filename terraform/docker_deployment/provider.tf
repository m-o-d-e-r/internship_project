terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "tcp://${data.terraform_remote_state.vm.outputs.vm_ip}:2375"
}

data "terraform_remote_state" "vm" {
  backend = "local"
  config = {
    path = "../vm_creation/terraform.tfstate"
  }
}
