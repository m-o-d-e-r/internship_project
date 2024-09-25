
resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_volume" "mongo_data" {
  name = "mongo_data"
}
