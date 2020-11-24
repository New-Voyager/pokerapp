DEFAULT_DOCKER_NET := game
API_SERVER_IMAGE := gcr.io/voyager-01-285603/api-server:0.1.16
GAME_SERVER_IMAGE := gcr.io/voyager-01-285603/game-server:0.1.1
NATS_SERVER_IMAGE := gcr.io/voyager-01-285603/nats-server:0.1.1
REDIS_IMAGE := gcr.io/voyager-01-285603/redis:6.0.9
POSTGRES_IMAGE := gcr.io/voyager-01-285603/postgres:12.5
BOTRUNNER_IMAGE := gcr.io/voyager-01-285603/botrunner:0.1.2

.PHONY: pull
pull: 
	docker pull $(API_SERVER_IMAGE)
	docker pull $(GAME_SERVER_IMAGE)
	docker pull $(NATS_SERVER_IMAGE)
	docker pull $(REDIS_IMAGE)
	docker pull $(POSTGRES_IMAGE)
	docker pull $(BOTRUNNER_IMAGE)
 
.PHONY: load-data
load-data:
	docker exec -it docker_api-server_1 node build/script-tests/testdriver.js ./script-tests/script/

.PHONY: create-network
create-network:
	@docker network create $(DEFAULT_DOCKER_NET) 2>/dev/null || true

.PHONY: stack-up
stack-up: create-network
	cd docker && \
		> .env && \
		echo "API_SERVER_IMAGE=$(API_SERVER_IMAGE)" >> .env && \
		echo "GAME_SERVER_IMAGE=$(GAME_SERVER_IMAGE)" >> .env && \
		echo "NATS_SERVER_IMAGE=$(NATS_SERVER_IMAGE)" >> .env && \
		echo "REDIS_IMAGE=$(REDIS_IMAGE)" >> .env && \
		echo "POSTGRES_IMAGE=$(POSTGRES_IMAGE)" >> .env && \
		docker-compose up -d

.PHONY: stack-down
stack-down:
	cd docker && docker-compose down

.PHONY: stack-clean
stack-clean:
	docker volume rm -f docker_db-data

