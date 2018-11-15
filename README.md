# Gamiphier API

Based on the CQRS specification.

    -> API Command
    -> API Query
    -> Nginx as frontal
    -> Redis for symfony cache
    -> RabbitMQ as EventBus
    -> MongoDB as DB

## Installation (with docker & docker-compose)

    /etc/hosts:
    127.0.0.1   dev.api-command.gamiphier.fr
    127.0.0.1   dev.api-query.gamiphier.fr

    git clone git@github.com:Gamiphier/gamiphier-api.git
    cd gamiphier-api
    make up
    make composer-install-api-command
    make composer-install-api-query

## OAuthV2 Server

https://oauth2.thephpleague.com/
https://www.thinktocode.com/2018/10/18/league-oauth-2-0-server-with-symfony-introduction/


-----------
CustomerWay.fr (c) 2018
