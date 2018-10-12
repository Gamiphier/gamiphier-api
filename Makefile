VERSION = 1.0
API_COMMAND = docker exec -ti $$(docker-compose ps -q api-command)
API_QUERY = docker exec -ti $$(docker-compose ps -q api-query)
NGINX = docker exec -ti $$(docker-compose ps -q nginx)
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
api-command-bash: bash-api-command ## [api-command] bash
bash-api-command:
	$(API_COMMAND) bash

api-query-bash: bash-api-query ## [api-query] bash
bash-api-query:
	$(API_QUERY) bash

nginx-bash: bash-nginx ## [nginx] bash
bash-nginx:
	$(NGINX) sh

## PHPUNIT
api-command-phpunit: ## [api-command] phpunit
	$(API_COMMAND) bin/phpunit --colors

api-query-phpunit: ## [api-query] phpunit
	$(API_QUERY) bin/phpunit --colors

## CACHE & LOGS
api-command-clean-cache-and-logs: api-command-clean-cache api-command-clean-logs ## [api-command] clear the cache & the logs
api-query-clean-cache-and-logs: api-query-clean-cache api-query-clean-logs ## [api-query] clear the cache & the logs

api-command-clean-cache: ## [api-command] clear the cache
	$(API_COMMAND) sh -c "$(CD_API) mkdir -p var/cache && rm -rf var/cache/* && chmod 777 var/cache || true"

api-command-clean-logs: ## [api-command] clear the logs
	$(API_COMMAND) sh -c "$(CD_API) mkdir -p var/logs && rm -rf var/logs/* && chmod 777 var/logs || true"

api-command-cache-clear: ## [api-command] console c:c
	$(API_COMMAND) bin/console cache:clear --env=$(ENV) --no-debug --ansi || true

api-query-clean-cache: ## [api-query] clear the cache
	$(API_QUERY) sh -c "$(CD_API) mkdir -p var/cache && rm -rf var/cache/* && chmod 777 var/cache || true"

api-query-clean-logs: ## [api-query] clear the logs
	$(API_QUERY) sh -c "$(CD_API) mkdir -p var/logs && rm -rf var/logs/* && chmod 777 var/logs || true"

api-query-cache-clear: ## [api-query] console c:c
	$(API_QUERY) bin/console cache:clear --env=$(ENV) --no-debug --ansi || true

## COMPOSER
api-command-composer-install: ## [api-command] composer install
	@$(API_COMMAND) composer install --ansi --no-interaction || true

api-command-composer-update: ## [api-command] composer update
	@$(API_COMMAND) php -d memory_limit=-1 /usr/local/bin/composer update --ansi --no-interaction || true

api-query-composer-install: ## [api-query] composer install
	@$(API_QUERY) composer install --ansi --no-interaction || true

api-query-composer-update: ## [api-query] composer update
	@$(API_QUERY) php -d memory_limit=-1 /usr/local/bin/composer update --ansi --no-interaction || true

## PHP-CS-FIXER
api-command-cs: ## [api-command] check style
	$(API_COMMAND) vendor/bin/php-cs-fixer fix src   --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true
	$(API_COMMAND) vendor/bin/php-cs-fixer fix tests --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true

api-query-cs: ## [api-query] check style
	$(API_QUERY) vendor/bin/php-cs-fixer fix src   --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true
	$(API_QUERY) vendor/bin/php-cs-fixer fix tests --verbose --diff --rules=@Symfony,object_operator_without_whitespace,-yoda_style $(CS_OPTION) || true

######### TOOLS #########
up: ## docker-compose up
	docker-compose pull
	docker-compose up -d

down: ## docker-compose down
	docker-compose down

start: ## docker-compose start
	docker-compose start

stop: ## docker-compose stop
	docker-compose stop

ps:	## docker-compose ps
	docker-compose ps
