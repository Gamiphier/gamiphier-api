FROM php:7.2.9-fpm-stretch

RUN apt-get update \
    && apt-get install -y --no-install-recommends \ 
    vim curl debconf apt-transport-https apt-utils \
    build-essential locales acl wget zip unzip  

COPY php.ini /etc/php/7.2.9/php.ini

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
	mv composer.phar /usr/local/bin/composer

RUN wget --no-check-certificate https://phar.phpunit.de/phpunit-6.5.3.phar && \
    mv phpunit*.phar phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

RUN groupadd dev -g 1000
RUN useradd dev -g dev -d /home/dev -m

RUN rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

WORKDIR /var/www/

EXPOSE 9000
CMD ["php-fpm"]
