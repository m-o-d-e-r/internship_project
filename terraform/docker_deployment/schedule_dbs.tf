
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

resource "docker_image" "redis" {
  name = "redis:latest"
}

resource "docker_image" "mongo" {
  name = "mongo:latest"
}



resource "docker_container" "schedule_db" {
  name  = "schedule-db"
  image = docker_image.postgres.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}",
  ]
}

resource "docker_container" "schedule_mongo" {
  name  = "schedule-mongo"
  image = docker_image.mongo.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  volumes {
    volume_name    = docker_volume.mongo_data.name
    container_path = "/data/db"
  }

  env = [
    "MONGO_INITDB_DATABASE=${var.mongo_initdb_database}",
    "MONGO_INITDB_ROOT_USERNAME=${var.mongo_initdb_root_username}",
    "MONGO_INITDB_ROOT_PASSWORD=${var.mongo_initdb_root_password}"
  ]
}


resource "docker_container" "schedule_redis" {
  name  = "schedule-redis"
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }
}
