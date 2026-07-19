# :material-package: Images

All target images are based on a `common` base image that is build with the following binaries and extensions:

### :material-package-variant: Binaries

```text
composer:2.10
mlocati/php-extension-installer:2.11
```

### :material-elephant: PHP extensions

```text
mysqli
pdo_mysql
exif
ftp
gd
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

Contains additional [OpenTelemetry](https://opentelemetry.io/) **PHP extensions** for observability. Uses the `http/protobuf` transport, which is fork-safe and works with PHP-FPM without any additional extensions.

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
    - [`protobuf`](https://github.com/protocolbuffers/protobuf/tree/main/php): Significant performance improvement for `http/protobuf` OTLP exporting.

!!! note
    The `otel` image inherits the libraries from the `base` image.

### OTEL + FFmpeg

Combines the `otel` PHP extensions with the `ffmpeg` media-processing libraries in a single image, useful when an observability-instrumented PHP service also needs audio/video/image tooling.

**PHP extensions** (in addition to `common`):

```text
opentelemetry
protobuf
```

**Libraries** (in addition to `common`):

```text
zip
unzip
ffmpeg
mkvtoolnix
libimage-exiftool-perl
```

!!!tip "Container suffixed with `-otel-ffmpeg`"
    ```shell
    ghcr.io/toshy/php:8.5-fpm-trixie-otel-ffmpeg
    ```

!!! note
    The `otel-ffmpeg` image inherits the libraries from the `base` image and combines the additions of the `ffmpeg` and `otel` targets.

### OTEL (gRPC)

Extends the `otel` image with the `grpc` PHP extension for services that use the `grpc` OTLP transport.

```text
opentelemetry
protobuf
grpc
```

!!!tip "Container suffixed with `-otel-grpc`"
    ```shell
    ghcr.io/toshy/php:8.5-fpm-trixie-otel-grpc
    ```

!!! info

    - [`grpc`](https://github.com/grpc/grpc): A modern, open source, high-performance remote procedure call (RPC) framework that can run anywhere.

!!! warning
    `ext-grpc` initialises background threads at extension load time. Under PHP-FPM, which uses `fork()` to spawn workers, this can cause mutex corruption in long-running workers (SIGABRT from abseil's `mutex.cc`). This image is intended for PHP CLI / Messenger consumers that do not fork. For PHP-FPM use the `otel` image with `http/protobuf` transport instead.

!!! note
    The `otel-grpc` image inherits the libraries from the `base` image and the extensions from the `otel` target.

### OTEL (gRPC) + FFmpeg

Combines the `otel-grpc` PHP extensions with the `ffmpeg` media-processing libraries.

**PHP extensions** (in addition to `common`):

```text
opentelemetry
protobuf
grpc
```

**Libraries** (in addition to `common`):

```text
zip
unzip
ffmpeg
mkvtoolnix
libimage-exiftool-perl
```

!!!tip "Container suffixed with `-otel-grpc-ffmpeg`"
    ```shell
    ghcr.io/toshy/php:8.5-fpm-trixie-otel-grpc-ffmpeg
    ```

!!! warning
    See the gRPC warning in the `otel-grpc` section above.

!!! note
    The `otel-grpc-ffmpeg` image inherits the libraries from the `base` image and combines the additions of the `ffmpeg` and `otel-grpc` targets.

