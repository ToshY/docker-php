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

variable "DEFAULT_PHP_VERSION" {
    default = "8.4"
}

variable "DEFAULT_FLAVOR" {
    default = "fpm"
}

variable "DEFAULT_OS" {
    default = "bookworm"
}

variable "DEFAULT_TARGET" {
    default = "base"
}

variable "PHP_OS_MAP" {
    default = {
        "8.1" = "bookworm"
        "8.2" = "bookworm"
        "8.3" = "bookworm"
        "8.4" = "bookworm"
        "8.5" = "bookworm"
    }
}

variable "FLAVOR_OS_MAP" {
    default = {
        "cli" = "bookworm,alpine"
        "apache" = "bookworm" # apache flavor has no alpine os image
        "fpm" = "bookworm,alpine"
        "zts" = "bookworm,alpine"
    }
}

variable "TARGETS" {
    default = [
        "base",
        "ffmpeg"
    ]
}

function "tag" {
    params = [registry, php-version, os, target, php-flavor]
    result = [
        "${registry}/${REPOSITORY_IMAGE}:${php-version}-${php-flavor}-${os}${target == DEFAULT_TARGET ? "" : "-${target}"}",
        # Only default PHP version + default flavor + default OS + default target gets 'latest'
        php-version == DEFAULT_PHP_VERSION && php-flavor == DEFAULT_FLAVOR && os == DEFAULT_OS && target == DEFAULT_TARGET ? "${registry}/${REPOSITORY_IMAGE}:latest" : "",
        # Only default PHP version + default OS gets short tags
        php-version == DEFAULT_PHP_VERSION && os == DEFAULT_OS ? "${registry}/${REPOSITORY_IMAGE}:${php-flavor}-${os}${target == DEFAULT_TARGET ? "" : "-${target}"}" : "",
    ]
}

function "php_major_minor" {
    params = [v]
    result = _parse_php_major_minor(v, regexall("(?P<major>\\d+)\\.(?P<minor>\\d+)", v)[0])
}

function "_parse_php_major_minor" {
    params = [v, m]
    result = "${m.major}.${m.minor}"
}

function "php_version" {
    params = [v]
    result = _php_version(v, regexall("(?P<major>\\d+)\\.(?P<minor>\\d+)", v)[0])
}

function "_php_version" {
    params = [v, m]
    result = "${m.major}.${m.minor}" == DEFAULT_PHP_VERSION ? [v, "${m.major}.${m.minor}", "${m.major}"] : [v, "${m.major}.${m.minor}"]
}

function "php_flavor_os_variants" {
    params = []
    result = flatten([
        for php_version in split(",", PHP_VERSIONS) : [
            for flavor in keys(FLAVOR_OS_MAP) : [
                for php_os in split(",", lookup(PHP_OS_MAP, php_major_minor(php_version), DEFAULT_OS)) : [
                    for flavor_os in split(",", FLAVOR_OS_MAP[flavor]) : (
                        php_os == flavor_os ? {
                            php_version = php_version
                            flavor = flavor
                            os = flavor_os
                        } : null
                    )
                ]
            ]
        ]
    ])
}

function "filter_nulls" {
    params = [list]
    result = [for item in list : item if item != null]
}

target "default" {
    name = "php-${replace(variant.php_version, ".", "-")}-${variant.flavor}-${variant.os}-${tgt}"
    matrix = {
        variant = filter_nulls(php_flavor_os_variants())
        tgt = TARGETS
    }
    contexts = {
        php-base = "docker-image://php:${variant.php_version}-${variant.flavor}-${variant.os}"
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
            for pv in php_version(variant.php_version) :
            [
                for registry in split(",", REGISTRY_USERS) :
                flatten([
                    tag(registry, pv, variant.os, tgt, variant.flavor),
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