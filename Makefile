DEFAULT_DOCKER_NET := game

GCR_REGISTRY := gcr.io/voyager-01-285603
DO_REGISTRY := registry.digitalocean.com/voyager
REGISTRY := $(DO_REGISTRY)

API_SERVER_IMAGE := $(REGISTRY)/api-server:0.5.13
GAME_SERVER_IMAGE := $(REGISTRY)/game-server:0.5.12
BOTRUNNER_IMAGE := $(REGISTRY)/botrunner:0.5.11
TIMER_IMAGE := $(REGISTRY)/timer:0.5.1

NATS_SERVER_IMAGE := $(REGISTRY)/nats:2.1.7-alpine3.11
REDIS_IMAGE := $(REGISTRY)/redis:6.0.9
POSTGRES_IMAGE := $(REGISTRY)/postgres:12.5

.PHONE: login
login:
	docker login --username c1a5bd86f63f2882b8a11671bce3bae92e8355abf6e23613d7758a824c8f5082 --password c1a5bd86f63f2882b8a11671bce3bae92e8355abf6e23613d7758a824c8f5082 registry.digitalocean.com

.PHONY: pull
pull: login	
	docker pull $(API_SERVER_IMAGE)
	docker pull $(GAME_SERVER_IMAGE)
	docker pull $(NATS_SERVER_IMAGE)
	docker pull $(REDIS_IMAGE)
	docker pull $(POSTGRES_IMAGE)
	docker pull $(BOTRUNNER_IMAGE)
	docker pull $(TIMER_IMAGE)

.PHONY: load-data
load-data:
	docker exec -it docker_api-server_1 node build/script-tests/testdriver.js ./script-tests/script/

.PHONY: create-network
create-network:
	@docker network create $(DEFAULT_DOCKER_NET) 2>/dev/null || true

.PHONY: stack-up
stack-up: create-network login
	cd docker && \
		> .env && \
		echo "API_SERVER_IMAGE=$(API_SERVER_IMAGE)" >> .env && \
		echo "GAME_SERVER_IMAGE=$(GAME_SERVER_IMAGE)" >> .env && \
		echo "NATS_SERVER_IMAGE=$(NATS_SERVER_IMAGE)" >> .env && \
		echo "REDIS_IMAGE=$(REDIS_IMAGE)" >> .env && \
		echo "POSTGRES_IMAGE=$(POSTGRES_IMAGE)" >> .env && \
		echo "BOTRUNNER_IMAGE=$(BOTRUNNER_IMAGE)" >> .env && \
		echo "TIMER_IMAGE=$(TIMER_IMAGE)" >> .env && \
		echo "PROJECT_ROOT=$(PWD)" >> .env && \
		docker-compose up -d

.PHONY: stack-logs
stack-logs:
	cd docker && docker-compose logs -f

.PHONY: stack-down
stack-down:
	cd docker && docker-compose down

.PHONY: stack-clean
stack-clean:
	docker volume rm -f docker_db-data

.PHONY: stack-reset
stack-reset: create-network login 
	cd docker && docker-compose down
	docker volume rm -f docker_db-data
	cd docker && \
		> .env && \
		echo "API_SERVER_IMAGE=$(API_SERVER_IMAGE)" >> .env && \
		echo "GAME_SERVER_IMAGE=$(GAME_SERVER_IMAGE)" >> .env && \
		echo "NATS_SERVER_IMAGE=$(NATS_SERVER_IMAGE)" >> .env && \
		echo "REDIS_IMAGE=$(REDIS_IMAGE)" >> .env && \
		echo "POSTGRES_IMAGE=$(POSTGRES_IMAGE)" >> .env && \
		echo "BOTRUNNER_IMAGE=$(BOTRUNNER_IMAGE)" >> .env && \
		echo "TIMER_IMAGE=$(TIMER_IMAGE)" >> .env && \
		echo "PROJECT_ROOT=$(PWD)" >> .env && \
		docker-compose up -d
#
# Usage:
#
# BOTRUNNER_SCRIPT=botrunner_scripts/river-action-3-bots.yaml make botrunner
# BOTRUNNER_SCRIPT=botrunner_scripts/river-action-2-bots-1-human.yaml make botrunner
#
.PHONY: botrunner
botrunner:
	@DOCKER_NET=$(DEFAULT_DOCKER_NET) \
		BOTRUNNER_IMAGE=$(BOTRUNNER_IMAGE) \
		BOTRUNNER_SCRIPT=$(BOTRUNNER_SCRIPT) \
		./botrunner.sh

botrunner-sh:
	@DOCKER_NET=$(DEFAULT_DOCKER_NET) BOTRUNNER_IMAGE=$(BOTRUNNER_IMAGE) BOTRUNNER_SCRIPT=$(BOTRUNNER_SCRIPT) /bin/sh

.PHONY: seat-change
seat-change:
	BOTRUNNER_SCRIPT=botrunner_scripts/seat-change.yaml make botrunner

.PHONY: nlh-full
nlh-full: reset-db
	BOTRUNNER_SCRIPT=botrunner_scripts/play-many-hands.yaml make botrunner

wait-list:
	BOTRUNNER_SCRIPT=botrunner_scripts/waitlist.yaml make botrunner

reset-db:
	curl -X POST -v  -H 'Content-Type: application/json' -d '{"query":"mutation {resetDB}"}' http://localhost:9501/graphql
