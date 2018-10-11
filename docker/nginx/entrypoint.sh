#!/bin/ash

set -e

echo "add api-command"
cp /etc/nginx/tmp/api-command.conf /etc/nginx/conf.d/

echo "add api-query"
cp /etc/nginx/tmp/api-query.conf /etc/nginx/conf.d/

exec "$@"
