
resource "docker_image" "dbs_provision_img" {
  name = "dbs_provision"

  build {
    context    = "."
    dockerfile = "Dockerfile.provision"
  }
  triggers = {
    dockerfile_sha1 = sha1(file("${path.module}/Dockerfile.provision"))
    entrypoint_sha1 = sha1(file("${path.module}/entrypoint.sh"))
  }

}


resource "docker_container" "dbs_provision" {
  name  = "schedule-dbs-provision"
  image = docker_image.dbs_provision_img.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  must_run = false

  env = [
    "DB_HOST=schedule-db",
    "PGPASSWORD=${var.postgres_password}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_DB=${var.postgres_db}"
  ]

  depends_on = [
    docker_container.schedule_nginx
  ]
}
