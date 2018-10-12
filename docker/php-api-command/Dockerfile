FROM php:7.2.9-fpm-stretch

RUN apt-get update && \
    apt-get install -y curl vim libuv1-dev wget git-core libmcrypt-dev libssl1.0-dev zlib1g-dev \
            libicu-dev g++ make cmake libgmp-dev uuid-dev debconf apt-transport-https apt-utils \
            build-essential locales acl zip unzip libcurl4-openssl-dev && \
    apt-get autoclean -y && \
    apt-get clean -y

# PHP extention
# Install PECL extensions
RUN pecl install xdebug && docker-php-ext-enable xdebug && \
    pecl install channel://pecl.php.net/redis-3.1.6 && docker-php-ext-enable redis && \
    pecl install apcu  && docker-php-ext-enable apcu

RUN docker-php-ext-install \
        bcmath \
        intl \
        mbstring \
        pcntl \
        shmop \
        curl \
        zip

COPY php.ini /usr/local/etc/php/php.ini
COPY conf.d/global.ini /usr/local/etc/php/conf.d/global.ini

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
	mv composer.phar /usr/local/bin/composer

RUN groupadd dev -g 1000
RUN useradd dev -g dev -d /home/dev -m

RUN rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

WORKDIR /var/www/

EXPOSE 9000
CMD ["php-fpm"]
