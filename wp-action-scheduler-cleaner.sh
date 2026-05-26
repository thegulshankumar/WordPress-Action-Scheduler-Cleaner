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
# STEP 1 - Validate WP-CLI
# --------------------------------------------------

if [ ! -f "$WPCLI" ]; then

    echo "WP-CLI not found"
    echo "Please run installer again"
    echo ""

    exit 1

fi

echo "[1/3] Scanning WordPress installations..."
echo ""

TOTAL_SITES=0
CLEANED_SITES=0
FAILED_SITES=0

# --------------------------------------------------
# STEP 2 - Scan WordPress Sites
# --------------------------------------------------

find /home -type f -name "wp-config.php" -print0 | while IFS= read -r -d '' file; do

    WP_PATH=$(dirname "$file")

    SITE_USER=$(stat -c '%U' "$WP_PATH")

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

# --------------------------------------------------
# STEP 3 - Cleanup Summary
# --------------------------------------------------

echo "=================================================="
echo "[3/3] Cleanup Summary"
echo "=================================================="
echo ""

echo "Total WordPress Sites : $TOTAL_SITES"
echo "Successfully Cleaned  : $CLEANED_SITES"
echo "Failed Sites          : $FAILED_SITES"

echo ""
echo "Cleanup task completed"
echo "=================================================="
