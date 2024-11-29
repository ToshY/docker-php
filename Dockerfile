FROM php-base AS common

LABEL maintainer="ToshY (github.com/ToshY)"

COPY --from=ghcr.io/composer/docker:2.8 /usr/bin/composer /usr/local/bin/composer

COPY --from=ghcr.io/mlocati/php-extension-installer:2.7 /usr/bin/install-php-extensions /usr/local/bin/

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN <<EOT sh
  set -ex
  install-php-extensions mysqli-stable \
        pdo_mysql-stable \
        exif-stable \
        ftp-stable \
        gd-stable \
        imap-stable \
        opcache-stable \
        soap-stable \
        zip-stable \
        intl-stable \
        gettext-stable \
        sysvsem-stable \
        amqp-stable \
        redis-stable \
        pcntl-stable
  apt-get update
  apt-get install libexpat1=2.5.0-1+deb12u1
EOT

WORKDIR /app

FROM common AS base

RUN <<EOT sh
  set -ex
  apt-get install -y \
      software-properties-common \
      zip \
      unzip
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT

FROM common AS ffmpeg

RUN <<EOT sh
  apt-get install -y \
      software-properties-common  \
      nano \
      zip \
      unzip \
      ffmpeg \
      mkvtoolnix \
      libimage-exiftool-perl
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT
