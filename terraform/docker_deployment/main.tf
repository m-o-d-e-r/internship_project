
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

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx.image_id
  name  = "my_nginx"
  ports {
    internal = 80
    external = 80
  }
}
