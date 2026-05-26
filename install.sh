#!/bin/bash

# ==================================================
# WordPress Action Scheduler Cleaner Installer
# ==================================================

# Colors
GREEN='\e[1;32m'
BLUE='\e[1;34m'
RED='\e[1;31m'
WHITE='\e[1;37m'
YELLOW='\e[1;33m'
NC='\e[0m'

printf "${BLUE}==================================================${NC}\n"
printf "${WHITE} WordPress Action Scheduler Cleaner Installer${NC}\n"
printf "${BLUE}==================================================${NC}\n\n"

# --------------------------------------------------
# STEP 1 - Check WP-CLI
# --------------------------------------------------

if [ ! -f "/usr/local/bin/wp" ]; then

    printf "${YELLOW}[1/3] WP-CLI not detected${NC}\n"
    printf "${WHITE}Installing WP-CLI...${NC}\n\n"

    curl -fsSL -o wp-cli.phar \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x wp-cli.phar

    sudo mv wp-cli.phar /usr/local/bin/wp

    if [ $? -eq 0 ]; then

        printf "${GREEN}WP-CLI installed successfully${NC}\n"

    else

        printf "${RED}WP-CLI installation failed${NC}\n"
        exit 1

    fi

else

    WP_VERSION=$(/usr/local/bin/wp --allow-root --version | awk '{print $2}')

    printf "${GREEN}[1/3] WP-CLI detected${NC}\n"
    printf "${WHITE}Version:${NC} ${BLUE}%s${NC}\n" "$WP_VERSION"

fi

printf "\n"

# --------------------------------------------------
# STEP 2 - Download Cleanup Utility
# --------------------------------------------------

printf "${YELLOW}[2/3] Downloading cleanup utility...${NC}\n\n"

curl -fsSL \
https://raw.githubusercontent.com/thegulshankumar/WordPress-Action-Scheduler-Cleaner/main/wp-action-scheduler-cleaner.sh \
-o /usr/local/bin/wp-action-scheduler-cleaner

if [ $? -eq 0 ]; then

    chmod +x /usr/local/bin/wp-action-scheduler-cleaner

    printf "${GREEN}Cleanup utility installed successfully${NC}\n"

else

    printf "${RED}Failed to install cleanup utility${NC}\n"
    exit 1

fi

printf "\n"

# --------------------------------------------------
# STEP 3 - Installation Completed
# --------------------------------------------------

printf "${GREEN}[3/3] Installation completed successfully${NC}\n\n"

printf "${WHITE}Run manually using:${NC}\n"
printf "${BLUE}wp-action-scheduler-cleaner${NC}\n\n"

printf "${WHITE}Recommended cron job:${NC}\n"
printf "${BLUE}0 3 * * * /usr/local/bin/wp-action-scheduler-cleaner >> /var/log/wp-cleanup.log 2>&1${NC}\n\n"

printf "${WHITE}Edit cron jobs using:${NC}\n"
printf "${BLUE}crontab -e${NC}\n\n"

printf "${BLUE}==================================================${NC}\n"
printf "${GREEN} Installation Finished Successfully${NC}\n"
printf "${BLUE}==================================================${NC}\n"
