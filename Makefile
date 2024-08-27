
run:
	docker compose -f docker-compose.yaml up --build

dbs:
	docker compose -f docker-compose.dbs.yaml up --build

build_web:
	docker build -f ./Dockerfile.web -t scheduler_web .

build_api:
	docker build -f ./Dockerfile.api -t scheduler_api .
