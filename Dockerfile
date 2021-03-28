FROM nginx:latest
LABEL maintainer="Iván Hernández Cazorla (Coruja Digital) <ivan@corujadigital.tech>"

ARG COMPOSER_VERSION=1.10.20

# Update and upgrade
RUN apt-get -y update && apt-get -y upgrade 

# Install PHP packages
RUN apt-get install -y php-fpm php-gd php-mysql php-cli php-common php-curl php-opcache php-json php-intl php-mbstring php-xml

# Install another packages required

RUN apt-get -y install \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev \
	libbz2-dev \
	libxslt-dev \
	libldap2-dev \
	imagemagick \
	curl \
	git \
	unzip \
	wget \
	supervisor

# Use www-data user
RUN sed -i 's/user  nginx/user  www-data/g' /etc/nginx/nginx.conf

# Install and setup Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if ( hash( 'SHA384', file_get_contents( '/tmp/composer-setup.php' )) !== trim( file_get_contents( '/tmp/composer-setup.sig' ))) { unlink( '/tmp/composer-setup.php' ); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm -rf /tmp/composer-setup.php
