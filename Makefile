.PHONY: help
PROJECT_NAME ?= ah-bird-box-api
DOCKER_COMPOSE_FILE := docker-compose.yml
TARGET_MAX_CHAR_NUM=10

# a variable that stores application's container id if the container is running
CONTAINER_ID := $(shell docker-compose -f docker-compose.yml ps -q api)
ifeq ($(CONTAINER_ID),)
	CONTAINER := $(shell docker-compose -f docker-compose.yml ps -q api)
else
	CONTAINER := $(shell docker ps -q --no-trunc | grep $$(docker-compose -f docker-compose.yml ps -q api))
endif

# function that displays an error to user if the application is not running
define container_err
	${INFO} "Please execute \"make start\" on a different terminal tab before running this command"
endef

## Show help
help:
	@echo ''
	@echo 'How to use:'
	@echo '${YELLOW} make ${RESET} ${GREEN}<target> [options]${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		message = match(lastLine, /^## (.*)/); \
		if (message) { \
			command = substr($$1, 0, index($$1, ":")-1); \
			message = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} %s\n", command, message; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

## Generate .env file from the provided sample
env:
	${INFO} "Generating .env file from the sample"
	@ cp .env.sample .env
	@ echo " "
	${SUCCESS} ".env file generated successfully, edit the file with appropriate values"

## Start local development server containers
start:
	@ ${INFO} "Building required docker images"
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) build api
	@ ${INFO} "Build Completed successfully"
	@ echo " "
	@ ${INFO} "Starting local development server"
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) up

## Stop local development server containers
stop:
	${INFO} "Stop development server containers"
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) down -v
	${INFO} "All containers stopped successfully"

## Remove all development containers and volumes
clean:
	${INFO} "Cleaning your local environment"
	${INFO} "Note all volumes will be destroyed"
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) down -v
	@ docker images -q -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
	${INFO} "Removing dangling images"
	@ docker images -q -f dangling=true -f label=application=$(PROJECT_NAME) | xargs -I ARGS docker rmi -f ARGS
	@ docker system prune
	${INFO} "Clean complete"

## [ service ] Ssh into service container
ssh:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Open api container terminal"
	@ docker-compose -f $(DOCKER_COMPOSE_FILE) exec api bash
endif

## run migrations, the application needs to be running using make start
migrate:
ifeq ($(CONTAINER),)
	$(call container_err)
else
	${INFO} "Running authors haven migrations"
	@docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec api python3 manage.py makemigrations
	@docker-compose -f $(DOCKER_DEV_COMPOSE_FILE) exec api python3 manage.py migrate
	${SUCCESS} "Migration executed successfully"
endif

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
NC := "\e[0m"
RESET  := $(shell tput -Txterm sgr0)
# Shell Functions
INFO := @bash -c 'printf "\n"; printf $(YELLOW); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
SUCCESS := @bash -c 'printf "\n"; printf $(GREEN); echo "===> $$1"; printf "\n"; printf $(NC)' SOME_VALUE
