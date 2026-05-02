# YunoHost Package Review - livehelperchat_ynh

## Summary
This is a comprehensive review of the livehelperchat_ynh package against YunoHost v2 packaging standards. The package is mostly well-structured but has several issues that should be addressed before publication.

**Review Date:** 2026-05-02  
**Format Version:** v2  
**YunoHost Version Required:** >= 11.2

---

## Critical Issues (Must Fix)

### 1. Empty Maintainers List
**File:** `manifest.toml:12`  
**Severity:** Critical

```toml
maintainers = []
```

**Issue:** The maintainers field is empty. Every YunoHost package must have at least one maintainer listed for support and maintenance purposes.

**Fix:** Add maintainer(s) with proper format:
```toml
[[maintainers]]
name = "Your Name"
email = "your.email@example.com"
```

**Reference:** [YunoHost Manifest Documentation](https://doc.yunohost.org/en/dev/packaging/manifest/)

---

### 2. Placeholder SHA256 Hash
**File:** `manifest.toml:60`  
**Severity:** Critical

```toml
sha256 = "REPLACE_WITH_ACTUAL_SHA256_AFTER_DOWNLOAD"
```

**Issue:** The SHA256 hash is a placeholder and must be replaced with the actual hash of the source tarball. This is essential for security and integrity verification.

**Fix:** Calculate and replace with actual SHA256:
```bash
curl -sL "https://github.com/LiveHelperChat/livehelperchat/releases/download/4.74/4.74v-with-dependencies.tgz" | sha256sum
```

---

## Major Issues (Should Fix)

### 3. Missing Installation Script Setup
**File:** `scripts/install`  
**Severity:** Major

**Issue:** The install script doesn't explicitly create the cron job. The cron job is only added in the upgrade script, which means a fresh install won't have it scheduled until an upgrade occurs.

**Fix:** Add the following section after PHP-FPM/NGINX configuration:

```bash
#=================================================
# SETUP CRON JOB
#=================================================
ynh_script_progression "Setting up cron job..."

ynh_config_add --template="lhc_cron" --destination="/etc/cron.d/$app"
```

---

### 4. No Optional `config` Script
**File:** `scripts/` directory  
**Severity:** Major

**Issue:** The package doesn't include an optional `config` script. While not required, many YunoHost apps provide configuration management scripts to allow post-installation settings changes.

**Recommendation:** Consider adding a `config` script to allow administrators to:
- Modify admin email address
- Adjust PHP settings (upload limits, timeout, etc.)
- Configure cron frequency

---

## Minor Issues (Nice to Have)

### 5. Minimal README.md
**File:** `README.md`  
**Severity:** Minor

**Current content:**
```markdown
# livehelperchat_ynh
Yunohost installer for LHC
```

**Issue:** The README is very minimal. While YunoHost auto-generates the main README from the manifest, this file should contain development-specific information.

**Recommendation:** Expand with:
```markdown
# livehelperchat_ynh

YunoHost package for Live Helper Chat - an open-source live support chat application.

## Development

To contribute to this package:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `yunohost app install /path/to/repo`
5. Submit a pull request

### Testing
Run the automated tests:
```bash
yunohost app test livehelperchat
```

See `tests.toml` for test configuration.
```

---

### 6. Database Restoration Issue
**File:** `scripts/restore:36`  
**Severity:** Minor

**Current code:**
```bash
ynh_mysql_db_shell < db.sql
```

**Issue:** This helper doesn't exist in standard YunoHost helpers. Should use `ynh_mysql_db_shell` or the correct helper.

**Recommendation:** Verify the correct helper name or use standard MySQL import:
```bash
mysql -u "$db_user" -p"$db_pwd" "$db_name" < db.sql
```

Or use the proper YunoHost helper if available.

---

### 7. Settings File Path Handling
**File:** `scripts/install:93-95`  
**Severity:** Minor

**Current code:**
```bash
ynh_replace --match="php_session_cookie_name = ''" \
            --replace="php_session_cookie_name = '${app}_session'" \
            --file="$settings_file"
```

**Issue:** The match pattern assumes empty string. If the default file already has a value or different format, this replacement will fail silently.

**Recommendation:** Use more robust pattern matching:
```bash
ynh_replace --match="php_session_cookie_name = .*" \
            --replace="php_session_cookie_name = '${app}_session'" \
            --file="$settings_file"
```

---

### 8. Permission and Ownership Consistency
**File:** `scripts/install, restore, upgrade`  
**Severity:** Minor

**Issue:** Files are copied/restored but there's inconsistent handling of:
- Directory permissions (755 for most, but some dirs might need 775)
- Settings file ownership (sometimes app:www-data, sometimes app only)

**Recommendation:** Review and standardize permission model, especially for:
```bash
# For writable directories
chmod 775 "$install_dir/var/storage"
chmod 775 "$install_dir/cache/"

# For configuration files
chmod 640 "$settings_file"
chown "$app:www-data" "$settings_file"
```

---

### 9. Error Handling in Scripts
**File:** `All scripts`  
**Severity:** Minor

**Issue:** Scripts don't explicitly set error handling at the top. While YunoHost helpers handle many cases, explicit error handling is a best practice.

**Recommendation:** Add to the beginning of each script:
```bash
#!/bin/bash
set -u
source _common.sh
source /usr/share/yunohost/helpers
ynh_abort_if_errors
```

---

### 10. Documentation About URL Structure
**File:** `doc/DESCRIPTION.md`  
**Severity:** Minor

**Issue:** The description mentions the path structure but could be clearer about the install path configuration.

**Recommendation:** Add a section:
```markdown
## Configuration

The installation path can be customized during installation. Default is `/lhc`.

For a fresh install, access the application at `https://yourdomain.tld/lhc/` and follow the web installer.
```

---

## Standards Compliance Checklist

| Item | Status | Notes |
|------|--------|-------|
| Manifest Format (v2) | ✅ Pass | Using manifest.toml correctly |
| Package ID Format | ✅ Pass | `livehelperchat` is valid |
| License Declaration | ✅ Pass | AGPL-3.0 specified |
| Required Scripts | ✅ Pass | install, remove, backup, restore, upgrade, change_url present |
| Architecture Support | ✅ Pass | `all` is appropriate for PHP app |
| Database Handling | ⚠️ Warning | See issue #6 above |
| Dependencies | ✅ Pass | Properly declared in manifest |
| Maintainers | ❌ **FAIL** | Empty list - **CRITICAL** |
| Checksums | ❌ **FAIL** | Placeholder hash - **CRITICAL** |
| Static Assets CORS | ✅ Pass | Properly configured in nginx.conf |
| Cron Job | ⚠️ Warning | Only set in upgrade, not install |
| Permissions | ✅ Pass | Using YunoHost's permission system |
| Multi-instance Support | ✅ Pass | Enabled in manifest |

---

## Code Quality Issues

### 10. Variable Quoting
Multiple places use unquoted variables which could cause issues with spaces:
```bash
# Bad
ynh_safe_rm "$install_dir/cache/"

# Good - but context dependent - some variables are controlled by YunoHost
```
This is generally fine since YunoHost variables are controlled, but good practice to quote.

---

## Recommendations for Publishing

Before submitting to the official YunoHost app store:

1. ✅ **MUST:** Add maintainer(s) to manifest
2. ✅ **MUST:** Replace SHA256 placeholder with actual value
3. ✅ **SHOULD:** Fix database restoration helper
4. ✅ **SHOULD:** Add cron job to install script
5. ✅ **SHOULD:** Improve README with development info
6. ✅ **NICE:** Add optional config script for post-install settings
7. ✅ **NICE:** Expand documentation in DESCRIPTION.md

---

## Comparison with example_ynh

The package structure is sound and follows the example_ynh template well:
- Proper script organization ✅
- Correct use of YunoHost helpers ✅
- Appropriate manifest structure ✅
- Configuration templates match patterns ✅

Main differences to note:
- example_ynh might have different maintainer information
- example_ynh would have actual SHA256 values
- Some deployment patterns may differ based on application type

---

## Resources

- [YunoHost Packaging Guide](https://doc.yunohost.org/en/packaging_apps)
- [YunoHost Manifest Specification](https://doc.yunohost.org/en/dev/packaging/manifest/)
- [YunoHost Packaging v2](https://doc.yunohost.org/en/packaging_v2)
- [App Resources Documentation](https://doc.yunohost.org/en/dev/packaging/resources/)

