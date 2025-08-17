## :material-sticker-text: Quickstart

All images can be pulled from [ghcr.io/toshy/php](https://ghcr.io/toshy/php).

### :simple-gnubash: Shell

Run a container.

```shell
docker run --rm -it ghcr.io/toshy/php:8.4-cli-bookworm
```

### :simple-docker: Dockerfile

Extend an image.

```Dockerfile
FROM ghcr.io/toshy/php:8.4-fpm-bookworm
```

### :simple-docker: Compose

Use as a compose service.

```yaml
services:
  php:
    image: ghcr.io/toshy/php:8.4-fpm-bookworm
```

## :octicons-container-24: Flavors, versions and OS


```shell
ghcr.io/toshy/php:<version>-<flavor>-<os>(-<target>)
```

- Contains the following PHP versions: `8.1`, `8.2`, `8.3`, `8.4`.
- Contains the following flavors: `cli`, `fpm`, `apache`, `zts`
- Contains the following OS: `bookworm`.
- Contains the following [targets](images.md#targets): `base`, `ffmpeg`, `otel`.

!!!question

    - The `8.4` version is the default version (also tagged as `latest`).
    - The `base` target is the default image and does not have a `target` suffix.