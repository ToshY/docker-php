<h1 align="center">🐋 Docker PHP </h1>

<div align="center">
    <div>Customised <a href="https://hub.docker.com/_/php">PHP 8.1+</a> docker images.</div>
    <br />
    <img src="https://img.shields.io/github/actions/workflow/status/toshy/docker-php/security.yml?branch=main&label=Security" alt="Security" />
</div>

## 📦 Images

All images can be pulled from [ghcr.io/toshy/php](https://ghcr.io/toshy/php).

## 🐳 Dockerfile

#### Binaries

```text
composer:2.8
mlocati/php-extension-installer:2.7.0
```

#### PHP extensions

```text
mysqli-stable
pdo_mysql-stable
exif-stable
gd-stable
imagick-stable
imap-stable
opcache-stable
soap-stable
zip-stable
intl-stable
gettext-stable
sysvsem-stable
amqp-stable
redis-stable
pcntl-stable
```

#### Working directory

```text
/app
```

#### Additional packages

| Package \ Image              | `fpm-bookworm`  | `fpm-bookworm-ffmpeg` |
|:-----------------------------|:---------------:|:---------------------:|
| `software-properties-common` |        ✅        |           ✅           |
| `zip`                        |        ✅        |           ✅           |
| `unzip`                      |        ✅        |           ✅           |
| `nano`                       |                 |           ✅           |
| `ffmpeg`                     |                 |           ✅           |
| `mkvtoolnix`                 |                 |           ✅           |
| `libimage-exiftool-perl`     |                 |           ✅           |

## ❕ License

This repository comes with a [MIT license](./LICENSE).
