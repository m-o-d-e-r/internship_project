
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
  name = "schedule-db"
  image = docker_image.postgres.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  volumes {
    volume_name = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
}

resource "docker_container" "schedule_mongo" {
  name = "schedule-mongo"
  image = docker_image.mongo.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }

  volumes {
    volume_name = docker_volume.mongo_data.name
    container_path = "/data/db"
  }
}


resource "docker_container" "schedule_redis" {
  name = "schedule-redis"  
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.schedule_network.id
  }
}
