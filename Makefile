VERSION = 1.0
API_COMMAND = docker exec -u 1000 -ti $$(docker-compose ps -q api-command)
API_QUERY = docker exec -u 1000 -ti $$(docker-compose ps -q api-query)
NGINX = docker exec -ti $$(docker-compose ps -q nginx)
REDIS = docker exec -ti $$(docker-compose ps -q redis)
RABBITMQ = docker exec -ti $$(docker-compose ps -q rabbitmq)
CD_API_COMMAND = cd /var/www &&
CD_API_QUERY = cd /var/www &&
CS_OPTION =

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

## BASH
bash-api-command: ## [api-command] bash
	$(API_COMMAND) bash

bash-api-query: ## [api-query] bash
	$(API_QUERY) bash

bash-nginx: ## [nginx] bash
	$(NGINX) sh

bash-rabbitmq: ## [rabbitmq] bash
	$(RABBITMQ) bash

bash-redis: ## [redis] bash
	$(REDIS) redis-cli

## PHPUNIT
phpunit-api-command: ## [api-command] phpunit
	$(API_COMMAND) bin/phpunit --colors

phpunit-api-query: ## [api-query] phpunit
	$(API_QUERY) bin/phpunit --colors

## CACHE & LOGS
clean-cache-and-logs-api-command: clean-cache-api-command clean-logs-api-command ## [api-command] clear the cache & the logs
clean-cache-and-logs-api-query: clean-cache-api-query clean-logs-api-query ## [api-query] clear the cache & the logs

clean-cache-api-command: ## [api-command] clear the cache
	$(API_COMMAND) sh -c "$(CD_API) mkdir -p var/cache && rm -rf var/cache/* && chmod 777 var/cache || true"

clean-logs-api-command: ## [api-command] clear the logs
	$(API_COMMAND) sh -c "$(CD_API) mkdir -p var/logs && rm -rf var/logs/* && chmod 777 var/logs || true"

cache-clear-api-command: ## [api-command] console c:c
	$(API_COMMAND) bin/console cache:clear --env=$(ENV) --no-debug --ansi || true

clean-cache-api-query: ## [api-query] clear the cache
	$(API_QUERY) sh -c "$(CD_API) mkdir -p var/cache && rm -rf var/cache/* && chmod 777 var/cache || true"

clean-logs-api-query: ## [api-query] clear the logs
	$(API_QUERY) sh -c "$(CD_API) mkdir -p var/logs && rm -rf var/logs/* && chmod 777 var/logs || true"

cache-clear-api-query: ## [api-query] console c:c
	$(API_QUERY) bin/console cache:clear --env=$(ENV) --no-debug --ansi || true

## COMPOSER
composer-install-api-command: ## [api-command] composer install
	@$(API_COMMAND) composer install --ansi --no-interaction || true

composer-update-api-command: ## [api-command] composer update
	@$(API_COMMAND) php -d memory_limit=-1 /usr/local/bin/composer update --ansi --no-interaction || true

composer-install-api-query: ## [api-query] composer install
	@$(API_QUERY) composer install --ansi --no-interaction || true

composer-update-api-query: ## [api-query] composer update
	@$(API_QUERY) php -d memory_limit=-1 /usr/local/bin/composer update --ansi --no-interaction || true

## PHP-CS-FIXER
cs-api-command: ## [api-command] check style
	$(API_COMMAND) vendor/bin/php-cs-fixer fix src   --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true
	$(API_COMMAND) vendor/bin/php-cs-fixer fix tests --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true

cs-api-query: ## [api-query] check style
	$(API_QUERY) vendor/bin/php-cs-fixer fix src   --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true
	$(API_QUERY) vendor/bin/php-cs-fixer fix tests --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true

######### TOOLS #########
up: pull compose-up ps ## docker-compose up
compose-up:
	docker-compose up -d

pull: ## docker-compose pull
	docker-compose pull

down: ## docker-compose down
	docker-compose down

start: ## docker-compose start
	docker-compose start

stop: ## docker-compose stop
	docker-compose stop

ps:	## docker-compose ps
	docker-compose ps
