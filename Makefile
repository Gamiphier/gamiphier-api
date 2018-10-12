VERSION = 1.0

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help all build-proto build-docker

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help 

docker-build-and-push-all: docker-build-all docker-push-all ## build and push all docker images

## BUILD
docker-build-all: docker-build-api-command docker-build-api-query docker-build-nginx ## build all docker images

docker-build-api-command: ## build the docker image for api-command
	docker build -t gamiphier/php-api-command:v$(VERSION) docker/php-api-command

docker-build-api-query: ## build the docker image for api-query
	docker build -t gamiphier/php-api-query:v$(VERSION) docker/php-api-query

docker-build-nginx: ## build the docker image for nginx
	docker build -t gamiphier/nginx:v$(VERSION) docker/nginx

## PUSH
docker-push-all: docker-push-api-command docker-push-api-query docker-push-nginx ## push all docker images

docker-push-api-command: ## push the docker image for api-command
	docker push gamiphier/php-api-command:v$(VERSION)

docker-push-api-query: ## push the docker image for api-query
	docker push gamiphier/php-api-query:v$(VERSION)

docker-push-nginx: ## push the docker image for nginx
	docker push gamiphier/nginx:v$(VERSION)

