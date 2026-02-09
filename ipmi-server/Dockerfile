# Stage 1: Define composer for DL3022 compliance
FROM composer:2.8.5 AS composer_stage

# Stage 2: Main build
ARG BUILD_FROM=ghcr.io/hassio-addons/base:19.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set environment variables
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0 \
    LANG=C.UTF-8 \
    APP_DIR="/app"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base and install dependencies
# hadolint ignore=DL3003,DL3018
RUN apk update && \
    apk add --no-cache \
        ipmitool \
        nginx=1.28.2-r0 \
        php82 \
        php82-fpm \
        php82-openssl \
        php82-json \
        php82-ctype \
        php82-session \
        php82-tokenizer \
        php82-opcache \
        php82-iconv \
        php82-xml && \
    mkdir -p /app/cache /app/var/cache/prod /var/tmp/nginx && \
    chmod -R 777 /app/var/

# Copy root filesystem
COPY rootfs /

# Pull composer binary from the aliased stage (Fixes DL3022)
COPY --from=composer_stage /usr/bin/composer /usr/bin/composer

# Install app dependencies and clean up in one layer (Fixes DL3059/DL3018)
# hadolint ignore=DL3018
RUN apk add --no-cache \
        php82-phar \
        php82-mbstring && \
    php82 /usr/bin/composer --working-dir /app install && \
    apk del \
        php82-phar \
        php82-mbstring && \
    rm /usr/bin/composer

# Consolidated permissions (Fixes DL3059)
RUN if [ -d /app ]; then chown -R nginx /app; fi && \
    chown -R nginx /var/lib/nginx && \
    chmod -R 777 /var/lib/nginx && \
    if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi && \
    if [ -f /entrypoint.sh ]; then chmod 755 /entrypoint.sh; fi

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com{BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com{BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
