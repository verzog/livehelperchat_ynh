# Full Code Review — `livehelperchat_ynh`

## Scope and methodology

This review evaluates this YunoHost package against:

1. Current YunoHost packaging v2 expectations (manifest/resources model, script behavior, backup/restore, config templating, tests structure).
2. Current Live Helper Chat upstream setup requirements and runtime expectations.

Review date: **2026-05-04**.

---

## Executive summary

The package is in **good overall shape** and uses modern packaging v2 structure correctly (`manifest.toml` with resources, helper-based scripts, tests file present). The package also aligns with current upstream LHC baseline requirements by targeting PHP 8.3 and MySQL/MariaDB.

However, there are several issues worth fixing before calling it production-grade:

- **High priority:** install/upgrade scripts currently include extensive in-place upstream source patching via `sed`, which is fragile across upstream releases.
- **Medium priority:** script idempotency and maintainability can be improved (duplicated cache directory setup in install, repeated permission blocks across scripts).
- **Medium priority:** hardcoded `php_version="8.3"` in `_common.sh` may drift from YunoHost defaults and from future package metadata changes.

No blocker-level issue was found in packaging format compliance itself.

---

## Standards compliance matrix

## 1) Package structure and manifest (YunoHost v2)

✅ **Compliant**

- Uses `packaging_format = 2`.
- Declares upstream metadata, integration constraints, install questions, and resources in manifest v2 style.
- Uses `resources.sources`, `resources.install_dir`, `resources.permissions`, `resources.apt`, and `resources.database`.

Notes:
- Maintainer is now properly declared (no longer empty).
- Source checksum is present and not a placeholder.

## 2) Scripts and helper usage

✅ **Mostly compliant** with opportunities to harden.

Positive points:
- Standard script prolog is present (`set -u`, source helpers, `ynh_abort_if_errors`).
- Installation/upgrade/restore scripts are complete and include service reloads.
- Cron job is installed on install and refreshed on upgrade.

Risks:
- Heavy direct `sed` patching of upstream PHP install files in `scripts/install` is brittle against upstream formatting changes and could silently fail in future LHC versions.

## 3) Backup/restore and upgrade behavior

✅ **Functionally present**

- Restore includes app dir + database import + nginx/php-fpm/cron restoration.
- Upgrade preserves `settings/settings.ini.php` via `ynh_setup_source --keep=...`.

Risk:
- Schema drift fixes are executed through ad-hoc SQL and install-time source rewriting; long-term maintenance burden is high.

## 4) LHC upstream setup requirements alignment

✅ **Aligned (current)**

- Upstream docs require PHP 8.2+ and MySQL/MariaDB with JSON support; package targets PHP 8.3 + MariaDB.
- NGINX/PHP-FPM integration is present.

Caveat:
- If upstream eventually requires newer PHP minor versions, hardcoded php version in `_common.sh` will need manual bump.

---

## Findings and recommendations

## High priority

### H1 — Fragile upstream patching strategy in `scripts/install`

The installer patches multiple upstream files (`cli/lib/install.php` and `install-cli.php`) with line/regex-based `sed` edits before running CLI setup.

Why this matters:
- Any upstream refactor/formatting tweak can break regex anchors.
- Failures may be non-obvious and only appear at runtime.

Recommendation:
- Move patches into dedicated, versioned patch files and apply them with a deterministic patching workflow (or better: avoid patching entirely once upstream fixes are available).
- Gate these patches by explicit upstream version checks and fail loudly if patch context does not match.

## Medium priority

### M1 — Hardcoded PHP version in `_common.sh`

`php_version="8.3"` is fixed in script logic.

Why this matters:
- Divergence risk if package metadata or distro defaults evolve.

Recommendation:
- Either keep this explicit but document it as an intentional support ceiling, or derive dynamically in one place based on package policy.

### M2 — Duplicate/verbose permission and cache setup blocks

`install`, `upgrade`, and `restore` repeat many `chmod -R 770` calls; `install` has repeated cache directory creation/chown sections.

Why this matters:
- Increases maintenance cost and diff noise.

Recommendation:
- Centralize repeated logic into helper functions in `_common.sh` (e.g., `set_lhc_permissions`, `prepare_lhc_cache_dirs`) and call them from scripts.

### M3 — Direct SQL maintenance statements mixed into lifecycle scripts

Install/upgrade/restore include manual `CREATE TABLE IF NOT EXISTS` and `ALTER TABLE` statements to compensate upstream schema issues.

Why this matters:
- Valid workaround today, but can become stale as upstream DB schema evolves.

Recommendation:
- Track these as explicit compatibility migrations with comments referencing upstream issue IDs and applicable version ranges; periodically revalidate against latest upstream release.

## Low priority

### L1 — README links and terminology drift

`README.md` still points to older doc URLs in places and could better distinguish upstream app docs vs package maintenance docs.

Recommendation:
- Keep docs links consistent with current YunoHost dev doc routes and include tested YunoHost/PHP/LHC version matrix.

---

## Suggested action plan

1. **Stabilize installer patching** (highest impact).
2. **Refactor shared permission/cache logic** into `_common.sh` helpers.
3. **Version-govern compatibility SQL** and annotate with upstream references.
4. **Document supported matrix** (YunoHost, PHP, LHC release) in README.

---

## Local repository artifacts reviewed

- `manifest.toml`
- `scripts/_common.sh`
- `scripts/install`
- `scripts/upgrade`
- `scripts/restore`
- `scripts/remove`
- `scripts/change_url`
- `scripts/backup`
- `scripts/config`
- `conf/nginx.conf`
- `conf/php-fpm.conf`
- `conf/lhc_cron`
- `tests.toml`
- `README.md`

