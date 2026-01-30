# :material-package: Images

All target images are based on a `common` base image that is build with the following binaries and extensions:

### :material-package-variant: Binaries

```text
composer:2.8
mlocati/php-extension-installer:2.8
```

### :material-elephant: PHP extensions

```text
mysqli
pdo_mysql
exif
gd
imagick
opcache
soap
zip
intl
gettext
sysvsem
amqp
redis
pcntl
```

### :material-folder: Working directory

```text
/app
```

## :simple-target: Targets

### Base

Contains additional **libraries** that are useful for a majority of projects.

```text
zip
unzip
```

!!!tip "Container"
    ```shell
    ghcr.io/toshy/php:8.5-fpm-trixie
    ```

### FFmpeg

Contains additional **libraries** that are useful for audio, video and image processing.

```text
ffmpeg
mkvtoolnix
libimage-exiftool-perl
```

!!!tip "Container suffixed with `-ffmpeg`"
    ```shell
    ghcr.io/toshy/php:8.5-fpm-trixie-ffmpeg
    ```

!!! info

    - [`ffmpeg`](https://ffmpeg.org/): A complete, cross-platform solution to record, convert and stream audio and video.
    - [`mkvtoolnix`](https://mkvtoolnix.download/): MKVToolNix is a set of tools to create, alter and inspect Matroska files under Linux, other Unices and Windows.
    - [`libimage-exiftool-perl`](https://packages.debian.org/source/sid/libimage-exiftool-perl): A library and program to read and write meta information in multimedia files.

!!! note
    The `ffmpeg` image inherits the libraries from the `base` image.

### OTEL

Contains additional [OpenTelemetry](https://opentelemetry.io/) **PHP extensions** that are useful for observability.

```text
opentelemetry
protobuf
```

!!!tip "Container suffixed with `-otel`"
    ```shell
    ghcr.io/toshy/php:8.5-fpm-trixie-otel
    ```

!!! info

    - [`opentelemetry`](https://opentelemetry.io/docs/what-is-opentelemetry/): High-quality, ubiquitous, and portable telemetry to enable effective observability.
    - [`grpc`](https://github.com/grpc/grpc): A modern, open source, high-performance remote procedure call (RPC) framework that can run anywhere.
    - [`protobuf`](https://github.com/protocolbuffers/protobuf/tree/main/php): Significant performance improvement for otlp+protobuf exporting.

!!! note
    The `otel` image inherits the libraries from the `base` image.
