# livehelperchat_ynh

YunoHost package for Live Helper Chat - an open-source live support chat application.

## Development

This repository contains the YunoHost packaging for Live Helper Chat. To contribute:

### Prerequisites

- A YunoHost instance for testing
- Basic knowledge of bash scripting
- Understanding of YunoHost packaging format v2

### Development Setup

1. Fork and clone this repository:
   ```bash
   git clone https://github.com/yourusername/livehelperchat_ynh.git
   cd livehelperchat_ynh
   ```

2. Install the package locally for testing:
   ```bash
   yunohost app install /path/to/livehelperchat_ynh
   ```

3. Make your changes to the scripts or manifest

4. Test the installation, upgrade, and restoration processes

### Testing

Run the automated test suite:
```bash
yunohost app test livehelperchat
```

The test configuration is defined in `tests.toml` and includes:
- Basic installation test
- Upgrade test
- Backup and restore test
- URL change test
- Manifest coherence test
- Web path accessibility test

### Project Structure

- `manifest.toml` - Application metadata and resource declarations
- `scripts/` - Installation, upgrade, backup, restore, and configuration scripts
- `conf/` - Configuration templates (nginx, PHP-FPM, cron)
- `doc/` - Application documentation
- `tests.toml` - Test configuration

### Key Scripts

- `install` - Sets up the application, database, and services
- `upgrade` - Updates the application while preserving data
- `remove` - Uninstalls the application and cleans up resources
- `backup` - Creates backups for restoration
- `restore` - Restores from backups
- `change_url` - Handles domain/path changes
- `config` - Optional post-installation configuration

### Common Tasks

**Test a local change:**
```bash
yunohost app remove livehelperchat
yunohost app install /path/to/livehelperchat_ynh
```

**View application logs:**
```bash
tail -f /var/log/livehelperchat/cron.log
```

**SSH into the app directory:**
```bash
cd /var/www/livehelperchat
ls -la
```

### Contributing

1. Create a feature branch: `git checkout -b feature/my-improvement`
2. Make your changes
3. Test thoroughly with `yunohost app test livehelperchat`
4. Commit with clear messages
5. Push to your fork and submit a pull request

### Resources

- [YunoHost Packaging Guide](https://doc.yunohost.org/en/packaging_apps)
- [YunoHost Manifest Specification](https://doc.yunohost.org/en/dev/packaging/manifest/)
- [Live Helper Chat Documentation](https://doc.livehelperchat.com)
- [YunoHost Helpers Reference](https://doc.yunohost.org/en/dev/packaging/scripts/helpers_v2.1/)
