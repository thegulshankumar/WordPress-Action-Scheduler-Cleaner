#!/bin/bash

# ==================================================
# WordPress Action Scheduler Cleaner
# Automated WooCommerce scheduled action cleanup
# ==================================================

WPCLI="/usr/local/bin/wp"

# Colors
GREEN='\e[1;32m'
BLUE='\e[1;34m'
RED='\e[1;31m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
NC='\e[0m'

printf "${BLUE}==================================================${NC}\n"
printf "${WHITE} WordPress Action Scheduler Cleaner${NC}\n"
printf "${BLUE}==================================================${NC}\n\n"

# --------------------------------------------------
# STEP 1 - Validate WP-CLI
# --------------------------------------------------

if [ ! -f "$WPCLI" ]; then

    printf "${RED}WP-CLI not found${NC}\n"
    printf "${YELLOW}Please run installer again${NC}\n\n"

    exit 1

fi

printf "${GREEN}[1/3] Scanning WordPress installations...${NC}\n\n"

TOTAL_SITES=0
CLEANED_SITES=0
FAILED_SITES=0
SKIPPED_SITES=0

# --------------------------------------------------
# STEP 2 - Scan WordPress Sites
# --------------------------------------------------

while IFS= read -r -d '' file; do

    WP_PATH=$(dirname "$file")

    SITE_USER=$(stat -c '%U' "$WP_PATH")

    TOTAL_SITES=$((TOTAL_SITES + 1))

    printf "${BLUE}--------------------------------------------------${NC}\n"
    printf "${WHITE}Site Owner :${NC} ${GREEN}%s${NC}\n" "$SITE_USER"
    printf "${WHITE}WordPress  :${NC} ${BLUE}%s${NC}\n\n" "$WP_PATH"

    printf "${YELLOW}Validating WordPress installation...${NC}\n"

    sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" core is-installed >/dev/null 2>&1

    if [ $? -ne 0 ]; then

        printf "${RED}Invalid WordPress installation${NC}\n\n"

        FAILED_SITES=$((FAILED_SITES + 1))

        continue

    fi

    WP_VERSION=$(sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" core version 2>/dev/null)

    printf "${GREEN}Valid WordPress installation detected${NC}\n"
    printf "${WHITE}WordPress Version :${NC} ${GREEN}%s${NC}\n\n" "$WP_VERSION"

    printf "${YELLOW}Checking Action Scheduler availability...${NC}\n"

    sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" help action-scheduler >/dev/null 2>&1

    if [ $? -ne 0 ]; then

        printf "${YELLOW}Action Scheduler not available${NC}\n"
        printf "${YELLOW}Skipping cleanup${NC}\n\n"

        SKIPPED_SITES=$((SKIPPED_SITES + 1))

        continue

    fi

    printf "${GREEN}Action Scheduler detected${NC}\n\n"

    printf "${YELLOW}Running Action Scheduler cleanup...${NC}\n"

    CLEAN_OUTPUT=$(sudo -u "$SITE_USER" $WPCLI --path="$WP_PATH" action-scheduler clean \
        --status=complete,canceled,failed \
        --before='7 days ago' 2>&1)

    if [ $? -eq 0 ]; then

        printf "${GREEN}Cleanup completed successfully${NC}\n"

        CLEANED_SITES=$((CLEANED_SITES + 1))

    else

        printf "${RED}Cleanup failed${NC}\n"
        printf "${RED}%s${NC}\n" "$CLEAN_OUTPUT"

        FAILED_SITES=$((FAILED_SITES + 1))

    fi

    printf "\n"

done < <(find /home -type f -name "wp-config.php" -print0)

# --------------------------------------------------
# STEP 3 - Cleanup Summary
# --------------------------------------------------

printf "${BLUE}==================================================${NC}\n"
printf "${WHITE}[3/3] Cleanup Summary${NC}\n"
printf "${BLUE}==================================================${NC}\n\n"

printf "${WHITE}Total WordPress Sites :${NC} ${GREEN}%s${NC}\n" "$TOTAL_SITES"
printf "${WHITE}Successfully Cleaned  :${NC} ${GREEN}%s${NC}\n" "$CLEANED_SITES"
printf "${WHITE}Skipped Sites         :${NC} ${YELLOW}%s${NC}\n" "$SKIPPED_SITES"
printf "${WHITE}Failed Sites          :${NC} ${RED}%s${NC}\n" "$FAILED_SITES"

printf "\n"

printf "${GREEN}Cleanup task completed${NC}\n"

printf "${BLUE}==================================================${NC}\n"
