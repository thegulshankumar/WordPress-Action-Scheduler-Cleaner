#!/bin/bash

# ==================================================
# WordPress Action Scheduler Cleaner
# Automated WooCommerce scheduled action cleanup
# ==================================================

WPCLI="/usr/local/bin/wp"

echo "=================================================="
echo " WordPress Action Scheduler Cleaner"
echo "=================================================="
echo ""

# --------------------------------------------------
# STEP 1 - Check WP-CLI
# --------------------------------------------------

echo "[1/4] Checking WP-CLI installation..."
echo ""

if [ ! -f "$WPCLI" ]; then

    echo "WP-CLI not found"
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

    CURRENT_VERSION=$($WPCLI --allow-root --version | awk '{print $2}')

    echo "WP-CLI detected"
    echo "Current version: $CURRENT_VERSION"

fi

echo ""

# --------------------------------------------------
# STEP 2 - Update WP-CLI
# --------------------------------------------------

echo "[2/4] Checking for WP-CLI updates..."
echo ""

UPDATE_OUTPUT=$($WPCLI --allow-root cli update --yes 2>&1)

if echo "$UPDATE_OUTPUT" | grep -qi "success"; then

    NEW_VERSION=$($WPCLI --allow-root --version | awk '{print $2}')

    echo "WP-CLI updated successfully"
    echo "Updated version: $NEW_VERSION"

else

    echo "WP-CLI already up to date"

fi

echo ""

# --------------------------------------------------
# STEP 3 - Scan WordPress Sites
# --------------------------------------------------

echo "[3/4] Scanning WordPress installations..."
echo ""

TOTAL_SITES=0
CLEANED_SITES=0
FAILED_SITES=0

for USER_DIR in /home/*; do

    # Skip invalid directories
    [ ! -d "$USER_DIR" ] && continue

    SITE_USER=$(basename "$USER_DIR")

    # Common hosting structure
    WP_PATH="$USER_DIR/public_html"

    # Skip if wp-config.php missing
    if [ ! -f "$WP_PATH/wp-config.php" ]; then
        continue
    fi

    TOTAL_SITES=$((TOTAL_SITES + 1))

    echo "--------------------------------------------------"
    echo "Site Owner : $SITE_USER"
    echo "WordPress  : $WP_PATH"
    echo ""

    echo "Validating WordPress installation..."

    sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" core is-installed >/dev/null 2>&1

    if [ $? -ne 0 ]; then

        echo "Invalid WordPress installation"
        FAILED_SITES=$((FAILED_SITES + 1))
        echo ""

        continue

    fi

    echo "Valid WordPress installation detected"
    echo ""

    echo "Running Action Scheduler cleanup..."

    CLEAN_OUTPUT=$(sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" action-scheduler clean \
        --status=complete,canceled,failed \
        --before='7 days ago' 2>&1)

    if [ $? -eq 0 ]; then

        echo "Cleanup completed successfully"
        CLEANED_SITES=$((CLEANED_SITES + 1))

    else

        echo "Cleanup failed"
        echo "$CLEAN_OUTPUT"

        FAILED_SITES=$((FAILED_SITES + 1))

    fi

    echo ""

done

echo "=================================================="
echo "[4/4] Cleanup Summary"
echo "=================================================="
echo ""

echo "Total WordPress Sites : $TOTAL_SITES"
echo "Successfully Cleaned  : $CLEANED_SITES"
echo "Failed Sites          : $FAILED_SITES"

echo ""
echo "Cleanup task completed"
echo "=================================================="
