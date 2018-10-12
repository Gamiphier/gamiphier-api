FROM nginx:1-alpine

EXPOSE 80 443

COPY ./vhosts/api-command.conf /etc/nginx/tmp/api-command.conf
COPY ./vhosts/api-query.conf /etc/nginx/tmp/api-query.conf
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]