#!/bin/ash

set -e

echo "add api"
cp /etc/nginx/tmp/api.conf /etc/nginx/conf.d/

exec "$@"
