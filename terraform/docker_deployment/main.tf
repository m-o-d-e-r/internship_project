
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

  depends_on = [
    docker_container.schedule_db,
    docker_container.schedule_mongo,
    docker_container.schedule_redis
  ]

  env = [
    "REACT_APP_API_BASE_URL=http://${data.terraform_remote_state.vm.outputs.vm_ip}:8080/api"
  ]
}

resource "docker_container" "schedule_web" {
  name =  "schedule-web"
  image = docker_image.schedule_web.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  depends_on = [
    docker_container.schedule_api
  ]
}

resource "docker_container" "schedule_nginx" {
  name = "schedule-nginx"
  image = docker_image.schedule_nginx.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  ports {
    internal = 80
    external = 8080
  }

  depends_on = [
    docker_container.schedule_api,
    docker_container.schedule_web
  ]
}
