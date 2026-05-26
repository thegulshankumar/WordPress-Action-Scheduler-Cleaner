#!/bin/bash

echo "=============================================="
echo " Installing WordPress Action Scheduler Cleaner"
echo "=============================================="
echo ""

# --------------------------------------------------
# Install WP-CLI if missing
# --------------------------------------------------

if [ ! -f "/usr/local/bin/wp" ]; then

    echo "WP-CLI not found"
    echo "Installing WP-CLI..."

    curl -fsSL -o wp-cli.phar \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x wp-cli.phar

    sudo mv wp-cli.phar /usr/local/bin/wp

    echo "WP-CLI installed successfully"
    echo ""

else

    echo "WP-CLI already installed"
    echo ""

fi

# --------------------------------------------------
# Download latest cleaner utility
# --------------------------------------------------

echo "Downloading cleanup utility..."

curl -fsSL \
https://raw.githubusercontent.com/thegulshankumar/WordPress-Action-Scheduler-Cleaner/main/wp-action-scheduler-cleaner.sh \
-o /usr/local/bin/wp-action-scheduler-cleaner

# --------------------------------------------------
# Make executable
# --------------------------------------------------

chmod +x /usr/local/bin/wp-action-scheduler-cleaner

echo ""
echo "Installation completed successfully"
echo ""

echo "Run using:"
echo "wp-action-scheduler-cleaner"
echo ""
echo "Example:"
echo "wp-action-scheduler-cleaner"
echo "=============================================="
