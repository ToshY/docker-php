variable "REPOSITORY_IMAGE" {
    default = "php"
}

variable "REGISTRY_USERS" {
    default = "ghcr.io/toshy"
}

variable "SHA" {}

variable "VERSION" {
    default = "main"
}

variable "PHP_VERSIONS" {
    default = "8.1,8.2,8.3,8.4"
}

variable DEFAULT_PHP_VERSION {
    default = "8.4"
}

function "tag" {
    params = [registry, php-version, os, target, php-flavor]
    result = [
        // Tag "${php-version}-${php-flavor}-${os}-${target}"
        "${registry}/${REPOSITORY_IMAGE}:${php-version}-${php-flavor}-${os}${target == "base" ? "" : "-${target}"}",
        // Tag "latest"
        php-version == DEFAULT_PHP_VERSION && os == "bookworm" && target == "base" ? "${registry}/${REPOSITORY_IMAGE}:latest" : "",
        // Tag "${php-flavor}-${os}-${target}"
        php-version == DEFAULT_PHP_VERSION ? "${registry}/${REPOSITORY_IMAGE}:${php-flavor}-${os}${target == "base" ? "" : "-${target}"}" : "",
    ]
}

function "php_version" {
    params = [v]
    result = _php_version(v, regexall("(?P<major>\\d+)\\.(?P<minor>\\d+)", v)[0])
}

function "_php_version" {
    params = [v, m]
    result = "${m.major}.${m.minor}" == DEFAULT_PHP_VERSION ? [v, "${m.major}.${m.minor}", "${m.major}"] : [v, "${m.major}.${m.minor}"]
}

target "default" {
    name = "php-${replace(php-version, ".", "-")}-${php-flavor}-${os}-${tgt}"
    matrix = {
        php-version = split(",", PHP_VERSIONS)
        php-flavor = [
            "fpm"
        ]
        os = [
            "bookworm"
        ]
        tgt = [
            "base",
            "ffmpeg"
        ]
    }
    contexts = {
        php-base = "docker-image://php:${php-version}-${php-flavor}-${os}"
    }
    dockerfile = "Dockerfile"
    context = "./"
    target = tgt
    platforms = [
        "linux/amd64",
        "linux/386",
        "linux/arm/v7",
        "linux/arm64",
    ]
    tags = sort(distinct(flatten(
        [
            for pv in php_version(php-version) :
            [
                for registry in split(",", REGISTRY_USERS) :
                flatten([
                    tag(registry, pv, os, tgt, php-flavor),
                ])
            ]
        ])))
    labels = {
        "org.opencontainers.image.created" = "${timestamp()}"
        "org.opencontainers.image.revision" = SHA
        "org.opencontainers.image.version" = VERSION
        "org.opencontainers.image.vendor" = "ToshY"
    }
}
