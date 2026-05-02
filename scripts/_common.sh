#!/bin/bash

# Common variables and helpers

# PHP version
php_version="8.3"

# apply_template FILE [DOMAIN] [PATH]
# Replaces all __PLACEHOLDER__ tokens in FILE.
# DOMAIN and PATH default to $domain and $path if not given.
apply_template() {
    local file="$1"
    local tpl_domain="${2:-$domain}"
    local tpl_path="${3:-$path}"

    sed -i \
        -e "s|__APP__|${app}|g" \
        -e "s|__NAME__|${app}|g" \
        -e "s|__PHP_VERSION__|${php_version}|g" \
        -e "s|__INSTALL_DIR__|${install_dir}|g" \
        -e "s|__DOMAIN__|${tpl_domain}|g" \
        -e "s|__PATH__|${tpl_path}|g" \
        "$file"
}
