#!/bin/bash

WPCLI="/usr/local/bin/wp"

echo "=================================================="
echo " WordPress Action Scheduler Cleanup Utility"
echo "=================================================="
echo ""

# Check if WP-CLI exists
if [ ! -f "$WPCLI" ]; then

    echo "[1/4] WP-CLI not found"
    echo "Installing WP-CLI..."

    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar >/dev/null 2>&1

    chmod +x wp-cli.phar

    sudo mv wp-cli.phar "$WPCLI"

    if [ $? -eq 0 ]; then
        echo "WP-CLI installed successfully"
    else
        echo "WP-CLI installation failed"
        exit 1
    fi

else

    echo "[1/4] WP-CLI detected"

    CURRENT_VERSION=$($WPCLI --version | awk '{print $2}')

    echo "Current version: $CURRENT_VERSION"

    echo ""
    echo "[2/4] Updating WP-CLI..."

    UPDATE_OUTPUT=$($WPCLI cli update --yes 2>&1)

    if echo "$UPDATE_OUTPUT" | grep -q "Success"; then

        NEW_VERSION=$($WPCLI --version | awk '{print $2}')

        echo "WP-CLI updated successfully"
        echo "Updated version: $NEW_VERSION"

    else

        echo "WP-CLI already up to date or update failed"

    fi
fi

echo ""
echo "[3/4] Searching for WordPress installations..."
echo ""

# Find WordPress roots
find /home -type f -name "wp-config.php" -print0 | while IFS= read -r -d '' file; do

    WP_PATH=$(dirname "$file")

    echo "--------------------------------------------------"
    echo "Found WordPress path:"
    echo "$WP_PATH"

    # Detect directory owner
    SITE_USER=$(stat -c '%U' "$WP_PATH")

    echo "Detected site owner: $SITE_USER"

    echo "Validating WordPress installation..."

    sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" core is-installed >/dev/null 2>&1

    if [ $? -eq 0 ]; then

        echo "Valid WordPress installation confirmed"

        echo "Running Action Scheduler cleanup..."

        CLEAN_OUTPUT=$(sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" action-scheduler clean \
            --status=complete,canceled,failed \
            --before='7 days ago' 2>&1)

        if [ $? -eq 0 ]; then
            echo "Cleanup completed successfully"
        else
            echo "Cleanup failed"
            echo "$CLEAN_OUTPUT"
        fi

    else

        echo "Skipped invalid WordPress installation"

    fi

    echo ""

done

echo "=================================================="
echo "[4/4] All WordPress sites processed"
echo "Cleanup task completed"
echo "=================================================="
