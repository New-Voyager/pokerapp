.PHONY: load-data
load-data:
	docker exec -it docker_api-server_1 node build/script-tests/testdriver.js ./script-tests/script/

.PHONY: stack-up
stack-up:
	cd docker && docker-compose up

.PHONY: stack-down
stack-down:
	cd docker && docker-compose down

.PHONY: stack-clean
stack-clean:
	docker volume rm -f docker_db-data

