FROM php-base AS common

LABEL maintainer="ToshY (github.com/ToshY)"

COPY --from=ghcr.io/composer/docker:2.8 /usr/bin/composer /usr/local/bin/composer

COPY --from=ghcr.io/mlocati/php-extension-installer:2.8 /usr/bin/install-php-extensions /usr/local/bin/

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN <<EOT sh
  set -ex
  install-php-extensions mysqli \
    pdo_mysql \
    exif \
    ftp \
    gd \
    imap \
    opcache \
    soap \
    zip \
    intl \
    gettext \
    sysvsem \
    amqp \
    redis \
    pcntl
EOT

WORKDIR /app

FROM common AS base

RUN <<EOT sh
  set -ex
  apt-get update
  apt-get install -y \
    software-properties-common \
    zip \
    unzip
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT

FROM common AS ffmpeg

RUN <<EOT sh
  set -ex
  apt-get update
  apt-get install -y \
    software-properties-common  \
    zip \
    unzip \
    ffmpeg \
    mkvtoolnix \
    libimage-exiftool-perl \
    libjxl0.7=0.7.0-10+deb12u1
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT

FROM common AS otel

RUN <<EOT sh
  set -ex
  apt-get update
  apt-get install -y \
    software-properties-common \
    zip \
    unzip
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT

RUN <<EOT sh
  set -ex
  install-php-extensions opentelemetry \
    grpc \
    protobuf
EOT