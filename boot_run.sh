#!/bin/bash

# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[1;33m'
# NC='\033[0m' # No Color

# Check weather the setup-file exists
if [ ! -f setup_done ]; then
    echo "setup.sh not found"
    echo "updating your package repository before running this script"
    update_pkg=$(sudo apt update && apt upgrade -y)
    echo "sudo password required to update your package repository"
    echo "password: "
    read -s password
    
    if [ "$update_pkg" != "0" ]; then
        echo "$update_pkg"
        
    fi
    "${RED} Error: failed to update your package repository"
    exit 1

fi