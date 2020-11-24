DEFAULT_DOCKER_NET := game

.PHONY: pull
pull: 
	docker pull gcr.io/voyager-01-285603/api-server:0.1.14
	docker pull gcr.io/voyager-01-285603/game-server:0.1.1
	docker pull gcr.io/voyager-01-285603/nats-server:0.1.1
	docker pull gcr.io/voyager-01-285603/redis:6.0.9
	docker pull gcr.io/voyager-01-285603/postgres:12.5
 
.PHONY: load-data
load-data:
	docker exec -it docker_api-server_1 node build/script-tests/testdriver.js ./script-tests/script/

.PHONY: create-network
create-network:
	@docker network create $(DEFAULT_DOCKER_NET) 2>/dev/null || true

.PHONY: stack-up
stack-up: create-network
	cd docker && docker-compose up -d

.PHONY: stack-down
stack-down:
	cd docker && docker-compose down

.PHONY: stack-clean
stack-clean:
	docker volume rm -f docker_db-data

