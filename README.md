# WordPress Action Scheduler Cleaner

Automated WP-CLI utility to clean old WooCommerce Action Scheduler data.

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/56031746-bd36-41f2-b7c0-1f1dffd19dc1" />

## Who Is This For?

This utility is useful for:

- WooCommerce websites with large scheduled action tables
- WordPress hosting providers
- VPS/server administrators
- Agencies managing multiple WordPress sites
- Developers using WP-CLI maintenance workflows

## Features

- Auto detects WordPress installations
- Installs or updates WP-CLI
- Cleans completed, failed, and canceled actions
- Runs using actual site owner permissions
- Supports multiple WordPress sites
- Cron compatible


## Installation

```bash
git clone https://github.com/thegulshankumar/WordPress-Action-Scheduler-Cleaner.git

cd WordPress-Action-Scheduler-Cleaner

chmod +x install-wp-action-scheduler-cleaner.sh

./install-wp-action-scheduler-cleaner.sh
```

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/thegulshankumar/WordPress-Action-Scheduler-Cleaner/main/install.sh | sudo bash
```

## Usage

```bash
wp-action-scheduler-cleaner
```

## License

GNU General Public License v3.0 (GPL-3.0)

---

![Linux](https://img.shields.io/badge/Linux-Compatible-brightgreen)
![WP-CLI](https://img.shields.io/badge/WP--CLI-Supported-blue)
![WooCommerce](https://img.shields.io/badge/WooCommerce-Compatible-purple)
![License](https://img.shields.io/badge/License-GPLv3-yellow)
