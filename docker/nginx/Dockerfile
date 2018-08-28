FROM nginx:1-alpine

EXPOSE 80 443

COPY ./vhosts/api.conf /etc/nginx/tmp/api.conf
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]