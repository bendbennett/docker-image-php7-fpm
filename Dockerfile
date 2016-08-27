FROM ubuntu:14.04

MAINTAINER Benjamin Bennett <bennett.d.ben@gmail.com>

# Required so that ppa:ondrej/php repository can be added
RUN apt-get update && apt-get install -y \
    software-properties-common

# Required to make PHP 7 packages available
RUN apt-get update && LC_ALL=C.UTF-8 add-apt-repository -y \
    ppa:ondrej/php

# Install PHP 7 packages
RUN apt-get update && apt-get install -y \
    mcrypt \
    php-pear \
    php7.0-cli \
    php7.0-curl \
    php7.0-dev \
    php7.0-fpm \
    php7.0-intl \
    php7.0-json \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysql \
    php7.0-xml \
    php7.0-zip \
    pkg-config

# Install and link MongoDB extension
RUN pecl install mongodb
RUN echo "extension=mongodb.so" > /etc/php/7.0/mods-available/mongodb.ini
RUN ln -sf /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/fpm/conf.d/20-mongodb.ini
RUN ln -sf /etc/php/7.0/mods-available/mongodb.ini /etc/php/7.0/cli/conf.d/20-mongodb.ini

# PHP-FPM Configuration
RUN sed -i '/^listen /c listen = 0.0.0.0:9000' /etc/php/7.0/fpm/pool.d/www.conf
RUN mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT ["php-fpm7.0", "-F"]
