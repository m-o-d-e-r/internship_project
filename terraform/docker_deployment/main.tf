
resource "docker_image" "schedule_api" {
  name = "schedule_api"

  build {
    context = "../../"
    dockerfile = "Dockerfile.api"
  }
}

resource "docker_image" "schedule_web" {
  name = "schedule_web"

  build {
    context = "../../"
    dockerfile = "Dockerfile.web"
  }
}

resource "docker_image" "schedule_nginx" {
  name = "schedule_nginx"

  build {
    context = "../../"
    dockerfile = "Dockerfile.nginx-proxy"
  }
}


resource "docker_container" "schedule_api" {
  name = "schedule-api"
  image = docker_image.schedule_api.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }
}

resource "docker_container" "schedule_web" {
  name =  "schedule-web"
  image = docker_image.schedule_web.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }
}

resource "docker_container" "schedule_nginx" {
  name = "schedule-nginx"
  image = docker_image.schedule_nginx.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }
}
