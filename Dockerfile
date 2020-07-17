FROM ubuntu:18.04
LABEL maintainer="hyperjiang@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p /tmp/temp
WORKDIR /tmp/temp

COPY sources.list ./

RUN apt-get update && \
    apt-get install -y -q build-essential software-properties-common \
    cron curl git gnupg net-tools unzip wget \
    libbz2-dev zlib1g-dev libzip-dev libxml2-dev libxslt-dev libtidy-dev \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    libgmp-dev libgmp3-dev libssl-dev librdkafka-dev libmcrypt-dev

RUN add-apt-repository ppa:ondrej/php

RUN wget http://nginx.org/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && cat ./sources.list >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y nginx

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get install -y nodejs

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

# install php5.6

# install php7.2
RUN apt-get install -y -q \
    php7.2-bcmath \
    php7.2-bz2 \
    php7.2-curl \
    php7.2-dev \
    php7.2-fpm \
    php7.2-gd \
    php7.2-imap \
    php7.2-intl \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-pear \
    php7.2-pgsql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-tidy \
    php7.2-xdebug \
    php7.2-xml \
    php7.2-xmlrpc \
    php7.2-xsl \
    php7.2-zip

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN pecl channel-update pecl.php.net
RUN echo "\n" | pecl install apcu-5.1.18
RUN pecl install grpc-1.29.1;
RUN echo "\n" | pecl install mcrypt-1.0.3;
RUN pecl install mongodb-1.7.4;
RUN pecl install protobuf-3.12.2;
RUN pecl install rdkafka-4.0.3;
RUN echo "\n\n" | pecl install redis-5.2.2;
RUN pecl install seaslog-2.1.0;
RUN echo "yes\nyes\nyes\nyes\n" | pecl install swoole-4.5.2;
RUN pecl install yac-2.2.1;
RUN pecl install yaf-3.2.3;

COPY php7/apcu.ini /etc/php/7.2/mods-available/apcu.ini
COPY php7/grpc.ini /etc/php/7.2/mods-available/grpc.ini
COPY php7/mcrypt.ini /etc/php/7.2/mods-available/mcrypt.ini
COPY php7/mongodb.ini /etc/php/7.2/mods-available/mongodb.ini
COPY php7/protobuf.ini /etc/php/7.2/mods-available/protobuf.ini
COPY php7/rdkafka.ini /etc/php/7.2/mods-available/rdkafka.ini
COPY php7/redis.ini /etc/php/7.2/mods-available/redis.ini
COPY php7/seaslog.ini /etc/php/7.2/mods-available/seaslog.ini
COPY php7/swoole.ini /etc/php/7.2/mods-available/swoole.ini
COPY php7/yac.ini /etc/php/7.2/mods-available/yac.ini
COPY php7/yaf.ini /etc/php/7.2/mods-available/yaf.ini
RUN ln -s /etc/php/7.2/mods-available/apcu.ini /etc/php/7.2/fpm/conf.d/20-apcu.ini
RUN ln -s /etc/php/7.2/mods-available/apcu.ini /etc/php/7.2/cli/conf.d/20-apcu.ini
RUN ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/fpm/conf.d/20-grpc.ini
RUN ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/cli/conf.d/20-grpc.ini
RUN ln -s /etc/php/7.2/mods-available/mcrypt.ini /etc/php/7.2/fpm/conf.d/20-mcrypt.ini
RUN ln -s /etc/php/7.2/mods-available/mcrypt.ini /etc/php/7.2/cli/conf.d/20-mcrypt.ini
RUN ln -s /etc/php/7.2/mods-available/mongodb.ini /etc/php/7.2/fpm/conf.d/20-mongodb.ini
RUN ln -s /etc/php/7.2/mods-available/mongodb.ini /etc/php/7.2/cli/conf.d/20-mongodb.ini
RUN ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/fpm/conf.d/20-protobuf.ini
RUN ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/cli/conf.d/20-protobuf.ini
RUN ln -s /etc/php/7.2/mods-available/rdkafka.ini /etc/php/7.2/fpm/conf.d/20-rdkafka.ini
RUN ln -s /etc/php/7.2/mods-available/rdkafka.ini /etc/php/7.2/cli/conf.d/20-rdkafka.ini
RUN ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/fpm/conf.d/20-redis.ini
RUN ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/cli/conf.d/20-redis.ini
RUN ln -s /etc/php/7.2/mods-available/seaslog.ini /etc/php/7.2/fpm/conf.d/20-seaslog.ini
RUN ln -s /etc/php/7.2/mods-available/seaslog.ini /etc/php/7.2/cli/conf.d/20-seaslog.ini
RUN ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/20-swoole.ini
RUN ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/20-swoole.ini
RUN ln -s /etc/php/7.2/mods-available/yac.ini /etc/php/7.2/fpm/conf.d/20-yac.ini
RUN ln -s /etc/php/7.2/mods-available/yac.ini /etc/php/7.2/cli/conf.d/20-yac.ini
RUN ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/fpm/conf.d/20-yaf.ini
RUN ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/cli/conf.d/20-yaf.ini

RUN sed -i \
        -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" \
        -e "s/post_max_size = 8M/post_max_size = 100M/g" \
        -e "s/short_open_tag = Off/short_open_tag = On/g" \
        /etc/php/7.2/fpm/php.ini

# clean up temp files
RUN rm -rf /var/lib/apt/lists/* /tmp/temp/

RUN mkdir -p /app/public
WORKDIR /app

EXPOSE 443 80

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.php /app/index.php

COPY start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["/start.sh"]
