#!/bin/bash

# ==================================================
# WordPress Action Scheduler Cleaner Installer
# ==================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
WHITE='\033[1;37m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==================================================${NC}"
echo -e "${WHITE} WordPress Action Scheduler Cleaner Installer${NC}"
echo -e "${BLUE}==================================================${NC}"
echo ""

# --------------------------------------------------
# Check WP-CLI
# --------------------------------------------------

if [ ! -f "/usr/local/bin/wp" ]; then

    echo -e "${YELLOW}[1/3] WP-CLI not detected${NC}"
    echo -e "${WHITE}Installing WP-CLI...${NC}"
    echo ""

    curl -fsSL -o wp-cli.phar \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

    chmod +x wp-cli.phar

    sudo mv wp-cli.phar /usr/local/bin/wp

    if [ $? -eq 0 ]; then

        echo -e "${GREEN}WP-CLI installed successfully${NC}"

    else

        echo -e "${RED}WP-CLI installation failed${NC}"
        exit 1

    fi

else

    WP_VERSION=$(/usr/local/bin/wp --allow-root --version | awk '{print $2}')

    echo -e "${GREEN}[1/3] WP-CLI detected${NC}"
    echo -e "${WHITE}Version:${NC} ${BLUE}$WP_VERSION${NC}"

fi

echo ""

# --------------------------------------------------
# Install Cleanup Utility
# --------------------------------------------------

echo -e "${YELLOW}[2/3] Downloading cleanup utility...${NC}"
echo ""

curl -fsSL \
https://raw.githubusercontent.com/thegulshankumar/WordPress-Action-Scheduler-Cleaner/main/wp-action-scheduler-cleaner.sh \
-o /usr/local/bin/wp-action-scheduler-cleaner

if [ $? -eq 0 ]; then

    chmod +x /usr/local/bin/wp-action-scheduler-cleaner

    echo -e "${GREEN}Cleanup utility installed successfully${NC}"

else

    echo -e "${RED}Failed to install cleanup utility${NC}"
    exit 1

fi

echo ""

# --------------------------------------------------
# Installation Completed
# --------------------------------------------------

echo -e "${GREEN}[3/3] Installation completed successfully${NC}"
echo ""

echo -e "${WHITE}Run manually using:${NC}"
echo -e "${BLUE}wp-action-scheduler-cleaner${NC}"

echo ""
echo -e "${WHITE}Recommended cron job:${NC}"
echo -e "${BLUE}0 3 * * * /usr/local/bin/wp-action-scheduler-cleaner >> /var/log/wp-cleanup.log 2>&1${NC}"

echo ""
echo -e "${WHITE}Edit cron jobs using:${NC}"
echo -e "${BLUE}crontab -e${NC}"

echo ""
echo -e "${BLUE}==================================================${NC}"
echo -e "${GREEN} Installation Finished Successfully${NC}"
echo -e "${BLUE}==================================================${NC}"
