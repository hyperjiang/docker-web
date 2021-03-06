FROM ubuntu:18.04
LABEL maintainer="hyperjiang@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN mkdir -p /tmp/temp
WORKDIR /tmp/temp

RUN apt-get update && \
    apt-get install -y -q build-essential software-properties-common \
    cron curl git gnupg net-tools unzip wget \
    libbz2-dev zlib1g-dev libzip-dev libxml2-dev libxslt-dev libtidy-dev \
    libfreetype6-dev libpng-dev libgmp-dev libgmp3-dev libssl-dev \
    librdkafka-dev libmcrypt-dev

COPY sources.list ./
RUN wget http://nginx.org/keys/nginx_signing.key \
    && apt-key add nginx_signing.key \
    && cat ./sources.list >> /etc/apt/sources.list \
    && add-apt-repository ppa:ondrej/php \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get update && apt-get install -y nodejs yarn nginx

# install php5.6
RUN apt install -y -q \
    php5.6-bcmath \
    php5.6-bz2 \
    php5.6-curl \
    php5.6-dev \
    php5.6-fpm \
    php5.6-gd \
    php5.6-gmp \
    php5.6-imap \
    php5.6-intl \
    php5.6-mbstring \
    php5.6-mcrypt \
    php5.6-mysql \
    php5.6-pgsql \
    php5.6-soap \
    php5.6-sqlite3 \
    php5.6-tidy \
    php5.6-xdebug \
    php5.6-xml \
    php5.6-xmlrpc \
    php5.6-xsl \
    php5.6-zip

RUN pecl channel-update pecl.php.net \
    && pecl -d php_suffix=5.6 install mongodb-1.4.4 && pecl uninstall -r mongodb-1.4.4 \
    && echo "\n" | pecl install redis-3.1.6 && pecl uninstall -r redis-3.1.6 \
    && pecl -d php_suffix=5.6 install swoole-1.9.23 && pecl uninstall -r swoole-1.9.23 \
    && pecl -d php_suffix=5.6 install rdkafka-3.0.5 && pecl uninstall -r rdkafka-3.0.5 \
    && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.0.2/protoc-3.0.2-linux-x86_64.zip \
    && unzip protoc-3.0.2-linux-x86_64.zip -d /protoc && \
    mv /protoc/bin/protoc /bin/ && \
    rm -rf /protoc/ && \
    git clone --single-branch --branch php5 https://github.com/allegro/php-protobuf.git \
        && cd php-protobuf \
        && phpize \
        && ./configure \
        && make \
        && make install;

RUN sed -i \
        -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" \
        -e "s/post_max_size = 8M/post_max_size = 100M/g" \
        -e "s/short_open_tag = Off/short_open_tag = On/g" \
        /etc/php/5.6/fpm/php.ini

COPY php5/mongodb.ini /etc/php/5.6/mods-available/mongodb.ini
COPY php5/protobuf.ini /etc/php/5.6/mods-available/protobuf.ini
COPY php5/rdkafka.ini /etc/php/5.6/mods-available/rdkafka.ini
COPY php5/redis.ini /etc/php/5.6/mods-available/redis.ini
COPY php5/swoole.ini /etc/php/5.6/mods-available/swoole.ini
RUN ln -s /etc/php/5.6/mods-available/mongodb.ini /etc/php/5.6/fpm/conf.d/20-mongodb.ini \
    && ln -s /etc/php/5.6/mods-available/mongodb.ini /etc/php/5.6/cli/conf.d/20-mongodb.ini \
    && ln -s /etc/php/5.6/mods-available/protobuf.ini /etc/php/5.6/fpm/conf.d/20-protobuf.ini \
    && ln -s /etc/php/5.6/mods-available/protobuf.ini /etc/php/5.6/cli/conf.d/20-protobuf.ini \
    && ln -s /etc/php/5.6/mods-available/rdkafka.ini /etc/php/5.6/fpm/conf.d/20-rdkafka.ini \
    && ln -s /etc/php/5.6/mods-available/rdkafka.ini /etc/php/5.6/cli/conf.d/20-rdkafka.ini \
    && ln -s /etc/php/5.6/mods-available/redis.ini /etc/php/5.6/fpm/conf.d/20-redis.ini \
    && ln -s /etc/php/5.6/mods-available/redis.ini /etc/php/5.6/cli/conf.d/20-redis.ini \
    && ln -s /etc/php/5.6/mods-available/swoole.ini /etc/php/5.6/fpm/conf.d/20-swoole.ini \
    && ln -s /etc/php/5.6/mods-available/swoole.ini /etc/php/5.6/cli/conf.d/20-swoole.ini

# install php7.2
RUN apt install -y -q \
    php7.2-bcmath \
    php7.2-bz2 \
    php7.2-curl \
    php7.2-dev \
    php7.2-fpm \
    php7.2-gd \
    php7.2-gmp \
    php7.2-imap \
    php7.2-intl \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-pgsql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-tidy \
    php7.2-xdebug \
    php7.2-xml \
    php7.2-xmlrpc \
    php7.2-xsl \
    php7.2-zip

RUN pecl channel-update pecl.php.net \
    && echo "\n" | pecl -d php_suffix=7.2 install apcu-5.1.18 \
    && pecl -d php_suffix=7.2 install grpc-1.29.1 \
    && echo "\n" | pecl -d php_suffix=7.2 install mcrypt-1.0.3 \
    && pecl -d php_suffix=7.2 install mongodb-1.7.5 \
    && pecl -d php_suffix=7.2 install protobuf-3.12.3 \
    && pecl -d php_suffix=7.2 install rdkafka-4.0.3 \
    && echo "\n\n" | pecl -d php_suffix=7.2 install redis-5.3.1 \
    && pecl -d php_suffix=7.2 install seaslog-2.1.0 \
    && echo "yes\nyes\nyes\nyes\n" | pecl -d php_suffix=7.2 install swoole-4.5.2 \
    && pecl -d php_suffix=7.2 install yac-2.2.1 \
    && pecl -d php_suffix=7.2 install yaf-3.2.5

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
RUN ln -s /etc/php/7.2/mods-available/apcu.ini /etc/php/7.2/fpm/conf.d/20-apcu.ini \
    && ln -s /etc/php/7.2/mods-available/apcu.ini /etc/php/7.2/cli/conf.d/20-apcu.ini \
    && ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/fpm/conf.d/20-grpc.ini \
    && ln -s /etc/php/7.2/mods-available/grpc.ini /etc/php/7.2/cli/conf.d/20-grpc.ini \
    && ln -s /etc/php/7.2/mods-available/mcrypt.ini /etc/php/7.2/fpm/conf.d/20-mcrypt.ini \
    && ln -s /etc/php/7.2/mods-available/mcrypt.ini /etc/php/7.2/cli/conf.d/20-mcrypt.ini \
    && ln -s /etc/php/7.2/mods-available/mongodb.ini /etc/php/7.2/fpm/conf.d/20-mongodb.ini \
    && ln -s /etc/php/7.2/mods-available/mongodb.ini /etc/php/7.2/cli/conf.d/20-mongodb.ini \
    && ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/fpm/conf.d/20-protobuf.ini \
    && ln -s /etc/php/7.2/mods-available/protobuf.ini /etc/php/7.2/cli/conf.d/20-protobuf.ini \
    && ln -s /etc/php/7.2/mods-available/rdkafka.ini /etc/php/7.2/fpm/conf.d/20-rdkafka.ini \
    && ln -s /etc/php/7.2/mods-available/rdkafka.ini /etc/php/7.2/cli/conf.d/20-rdkafka.ini \
    && ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/fpm/conf.d/20-redis.ini \
    && ln -s /etc/php/7.2/mods-available/redis.ini /etc/php/7.2/cli/conf.d/20-redis.ini \
    && ln -s /etc/php/7.2/mods-available/seaslog.ini /etc/php/7.2/fpm/conf.d/20-seaslog.ini \
    && ln -s /etc/php/7.2/mods-available/seaslog.ini /etc/php/7.2/cli/conf.d/20-seaslog.ini \
    && ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/20-swoole.ini \
    && ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/20-swoole.ini \
    && ln -s /etc/php/7.2/mods-available/yac.ini /etc/php/7.2/fpm/conf.d/20-yac.ini \
    && ln -s /etc/php/7.2/mods-available/yac.ini /etc/php/7.2/cli/conf.d/20-yac.ini \
    && ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/fpm/conf.d/20-yaf.ini \
    && ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/cli/conf.d/20-yaf.ini

RUN sed -i \
        -e "s/upload_max_filesize = 2M/upload_max_filesize = 100M/g" \
        -e "s/post_max_size = 8M/post_max_size = 100M/g" \
        -e "s/short_open_tag = Off/short_open_tag = On/g" \
        /etc/php/7.2/fpm/php.ini

RUN curl -fsSL https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# clean up temp files
RUN rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /app
WORKDIR /app

EXPOSE 443 80

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.php /app/index.php

COPY start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["/start.sh"]
