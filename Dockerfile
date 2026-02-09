# STAGE 1: Build & Runtime
FROM php:8.2-fpm-alpine

# 1. Install Nginx, Supervisor, and ipmitool
# Alpine's 'apk' repository is updated much more frequently than Debian Stable
RUN apk add --no-cache \
    nginx \
    supervisor \
    ipmitool \
    bash \
    libzip-dev

RUN apk upgrade --no-cache && \
    rm -rf /var/cache/apk/*
    
# 2. Install PHP extensions
RUN docker-php-ext-install bcmath pcntl zip

# 3. Configure Nginx (Update your nginx.conf to use 'user nginx;')
COPY ./docker/nginx.conf /etc/nginx/http.d/default.conf

# 4. Configure Supervisor
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 5. Set up app
WORKDIR /var/www/html
COPY ./ipmi-server/rootfs/app /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Pull composer binary from the aliased stage
COPY --from=composer_stage /usr/bin/composer /usr/bin/composer

# Install app dependencies and clean up
# hadolint ignore=DL3018
RUN apk add --no-cache \
        php82-phar \
        php82-mbstring && \
    php82 /usr/bin/composer --working-dir /var/www/html install && \
    apk del \
        php82-phar \
        php82-mbstring && \
    rm /usr/bin/composer

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]