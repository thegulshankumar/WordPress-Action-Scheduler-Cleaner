#!/bin/bash

echo "=================================================="
echo " WordPress Action Scheduler Cleaner Installer"
echo "=================================================="
echo ""

# --------------------------------------------------
# Check WP-CLI
# --------------------------------------------------

if [ ! -f "/usr/local/bin/wp" ]; then

    echo "[1/3] WP-CLI not detected"
    echo "Installing WP-CLI..."
    echo ""

    curl -fsSL -o wp-cli.phar \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x wp-cli.phar

    sudo mv wp-cli.phar /usr/local/bin/wp

    if [ $? -eq 0 ]; then

        echo "WP-CLI installed successfully"

    else

        echo "WP-CLI installation failed"
        exit 1

    fi

else

    WP_VERSION=$(/usr/local/bin/wp --allow-root --version | awk '{print $2}')

    echo "[1/3] WP-CLI detected"
    echo "Version: $WP_VERSION"

fi

echo ""

# --------------------------------------------------
# Install Cleanup Utility
# --------------------------------------------------

echo "[2/3] Downloading cleanup utility..."
echo ""

curl -fsSL \
https://raw.githubusercontent.com/thegulshankumar/WordPress-Action-Scheduler-Cleaner/main/wp-action-scheduler-cleaner.sh \
-o /usr/local/bin/wp-action-scheduler-cleaner

if [ $? -eq 0 ]; then

    chmod +x /usr/local/bin/wp-action-scheduler-cleaner

    echo "Cleanup utility installed successfully"

else

    echo "Failed to install cleanup utility"
    exit 1

fi

echo ""

# --------------------------------------------------
# Installation Completed
# --------------------------------------------------

echo "[3/3] Installation completed successfully"
echo ""

echo "Run manually using:"
echo "wp-action-scheduler-cleaner"

echo ""
echo "Recommended cron job:"
echo "0 3 * * * /usr/local/bin/wp-action-scheduler-cleaner >> /var/log/wp-cleanup.log 2>&1"

echo ""
echo "Edit cron jobs using:"
echo "crontab -e"

echo ""
echo "=================================================="
echo " Installation Finished Successfully"
echo "=================================================="
