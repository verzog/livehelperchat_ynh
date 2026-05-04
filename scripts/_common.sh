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

    # Normalize root path "/" to empty so __PATH__/ becomes "/" not "//"
    # and so the sub-path SSO catch blocks (which would self-redirect at root)
    # can be stripped before substitution.
    if [[ "$tpl_path" == "/" ]]; then
        tpl_path=""
        sed -i '/# LHC_SUBPATH_REWRITE_START/,/# LHC_SUBPATH_REWRITE_END/d' "$file"
        sed -i '/# LHC_SUBPATH_SSO_CATCH_START/,/# LHC_SUBPATH_SSO_CATCH_END/d' "$file"
    fi

    sed -i \
        -e "s|__APP__|${app}|g" \
        -e "s|__NAME__|${app}|g" \
        -e "s|__PHP_VERSION__|${php_version}|g" \
        -e "s|__INSTALL_DIR__|${install_dir}|g" \
        -e "s|__DOMAIN__|${tpl_domain}|g" \
        -e "s|__PATH__|${tpl_path}|g" \
        "$file"
}

# Set application writable permissions consistently across lifecycle scripts.
set_lhc_permissions() {
    chmod 770 "$install_dir/settings/"
    chmod 770 "$install_dir/var/"
    chmod -R 770 "$install_dir/var/storage"
    chmod -R 770 "$install_dir/var/userphoto"
    chmod -R 770 "$install_dir/var/storageform"
    chmod -R 770 "$install_dir/var/storageadmintheme"
    chmod -R 770 "$install_dir/var/botphoto"
    chmod -R 770 "$install_dir/var/bottrphoto"
    chmod -R 770 "$install_dir/var/storageinvitation"
    chmod -R 770 "$install_dir/var/storagedocshare"
    chmod -R 770 "$install_dir/var/storagetheme"
    chmod -R 770 "$install_dir/var/tmpfiles"
    chmod -R 770 "$install_dir/cache/"
}

# Recreate cache directories in a consistent way after install/upgrade actions.
prepare_lhc_cache_dirs() {
    rm -rf "$install_dir/cache"/*
    rm -rf "$install_dir/var/cacheconfig"/*

    mkdir -p "$install_dir/cache/cacheconfig"
    mkdir -p "$install_dir/cache/compiledtemplates"
    mkdir -p "$install_dir/cache/translations"
    mkdir -p "$install_dir/cache/userinfo"
    mkdir -p "$install_dir/var/cacheconfig"

    chmod 770 "$install_dir/cache/cacheconfig"
    chmod 770 "$install_dir/cache/compiledtemplates"
    chmod 770 "$install_dir/cache/translations"
    chmod 770 "$install_dir/cache/userinfo"
    chmod 770 "$install_dir/var/cacheconfig"

    chown -R "$app:www-data" "$install_dir/cache"
    chown -R "$app:www-data" "$install_dir/var/cacheconfig"
}

# Keep schema workarounds in one place until upstream includes fixes.
apply_lhc_schema_workarounds() {
    mysql -u "$db_user" -p"$db_pwd" "$db_name" << 'SQLEOF'
CREATE TABLE IF NOT EXISTS `lh_abstract_proactive_chat_invitation_one_time` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `vid_id` bigint(20) NOT NULL,
  `chat_id` bigint(20) DEFAULT NULL,
  `chat_variables` longtext,
  `invited_date` bigint(20) NOT NULL,
  `invited` tinyint(1) NOT NULL DEFAULT 0,
  `accepted` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `vid_id` (`vid_id`),
  KEY `chat_id` (`chat_id`),
  KEY `invited_date` (`invited_date`)
) ENGINE=InnoDB CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `lh_departament_custom_work_hours`
  ADD COLUMN IF NOT EXISTS `repetitiveness` int(11) unsigned NOT NULL DEFAULT 0;
SQLEOF
}
