add-git-hooks:
	@\cp git-hook.sh .git/hooks/pre-commit
	@chmod +rx .git/hooks/pre-commit

# Bind build commands to proper mode
build-all: build-dev-all
build-redis: build-dev-redis
build-postgres: build-dev-postgres
build-django: build-dev-django
build-rabbitmq: build-dev-rabbitmq
build-celery: build-dev-celery


# Build development containers
build-dev-all: build-dev-redis build-dev-postgres build-dev-django build-dev-rabbitmq build-dev-celery
build-dev-redis:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml build trader-redis
build-dev-postgres:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml build trader-postgres
build-dev-django:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml build trader-django
build-dev-rabbitmq:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml build trader-rabbitmq
build-dev-celery:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml build trader-celery


# Build production containers
build-prod-all: build-prod-redis build-prod-postgres build-prod-django
build-prod-redis:
	@docker-compose -f docker-compose.yml build trader-redis
build-prod-postgres:
	@docker-compose -f docker-compose.yml build trader-postgres
build-prod-django:
	@docker-compose -f docker-compose.yml build trader-django
build-prod-rabbitmq:
	@docker-compose -f docker-compose.yml build trader-rabbitmq
build-prod-celery:
	@docker-compose -f docker-compose.yml build trader-celery


# Rebuild docker containers - stop -> remove -> build
rebuild-all: clean-all build-all
rebuild-redis: clean-redis build-redis
rebuild-postgres: clean-postgres build-postgres
rebuild-django: clean-django build-django
rebuild-rabbitmq: clean-rabbitmq build-rabbitmq
rebuild-celery: clean-celery build-celery


run-dev:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

run-dev-no-logs:
	@docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d

migrate:
	@docker exec -t trader-django python src/manage.py migrate
makemigrations:
	@docker exec -t trader-django python src/manage.py makemigrations


# Containers and images ids
ID-REDIS=$(shell docker ps -a -q -f "name=trader-redis")
ID-POSTGRES=$(shell docker ps -a -q -f "name=trader-postgres")
ID-DJANGO=$(shell docker ps -a -q -f "name=trader-django")
ID-RABBITMQ=$(shell docker ps -a -q -f "name=trader-rabbitmq")
ID-CELERY=$(shell docker ps -a -q -f "name=trader-celery")


# Stop docker containers
stop-redis:
	-@docker stop $(ID-REDIS)
stop-postgres:
	-@docker stop $(ID-POSTGRES)
stop-django:
	-@docker stop $(ID-DJANGO)
stop-rabbitmq:
	-@docker stop $(ID-RABBITMQ)
stop-celery:
	-@docker stop $(ID-CELERY)
stop:
	@docker-compose stop


# Remove docker containers
rm-redis:
	-@docker rm --volumes $(ID-REDIS)
rm-postgres:
	-@docker rm --volumes $(ID-POSTGRES)
rm-django:
	-@docker rm --volumes $(ID-DJANGO)
rm-rabbitmq:
	-@docker rm --volumes $(ID-RABBITMQ)
rm-celery:
	-@docker rm --volumes $(ID-CELERY)
rm: rm-django rm-postgres rm-redis rm-rabbitmq rm-celery


# Remove volumes
rm-db-volume:
	@docker volume rm teamup_db-data-volume

rm-all-volumes: rm-db-volume


# Clean docker containers
clean-redis: stop-redis rm-redis
clean-postgres: stop-postgres rm-postgres
clean-django: stop-django rm-django
clean-rabbitmq: stop-rabbitmq rm-rabbitmq
clean-celery: stop-celery rm-celery
clean-all:  clean-django clean-postgres clean-redis clean-rabbitmq clean-celery rm-all-volumes


# Open shell in container
shell-redis:
	@docker exec -it trader-redis bash
shell-postgres:
	@docker exec -it trader-postgres bash
shell-django:
	@docker exec -it trader-django bash
shell-celery:
	@docker exec -it trader-celery bash


# Logs
logs:
	@docker-compose logs -f
logs-redis:
	@docker logs -f trader-redis
logs-postgres:
	@docker logs -f trader-postgres
logs-django:
	docker-compose.test.yml@docker logs -f trader-django
logs-rabbitmq:
	@docker logs -f trader-rabbitmq
logs-celery:
	@docker logs -f trader-celery


# utils
dev-reload:
	@bash dev-reload.sh
createsu:
	@docker exec trader-django python src/manage.py createsu

monitor-dying:
	@docker events --filter event=die --format '{{.Type}} {{.Actor.Attributes.name}} died'\
	'- exitcode: {{.Actor.Attributes.exitCode}}' | grep -ivE '(?exit|code).*0'


# Tests
# Starts containers so that we are ready to run tests in them
prepare-tests:
	-@docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d

# Run tests
test-server:
	@docker exec -t trader-django bash -c "PYTHONDONTWRITEBYTECODE=1 pytest --cov=src/ --cov-report term-missing --cov-report html src/"

test:
	@make test-server

lint:
	@bash -c "cd server/src && pipenv run flake8"

lint-in-docker:
	@docker exec -t trader-django bash -c "cd src && flake8"

wait-for-all:
	@bash wait_for_django.sh
