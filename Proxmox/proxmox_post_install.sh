#!/bin/bash

# To run the script, use the following one-liner:
# wget https://raw.githubusercontent.com/fringemonkey/turnkey/main/Proxmox/proxmox_post_install.sh && chmod +x proxmox_post_install.sh && ./proxmox_post_install.sh

source error_catching.sh

current_step=${1:-1}

while [ $current_step -le $TOTAL_STEPS ]; do
    case $current_step in
        1) echo "1. Updating and upgrading packages..."; apt-get update > /dev/null 2>&1 && apt-get -y upgrade > /dev/null 2>&1 ;;
        2) echo "2. Securing the server..."; sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config > /dev/null 2>&1 && systemctl restart ssh > /dev/null 2>&1 ;;
        3) echo "3. Installing Fail2Ban..."; apt-get -y install fail2ban > /dev/null 2>&1 && systemctl enable fail2ban > /dev/null 2>&1 && systemctl start fail2ban > /dev/null 2>&1 ;;
        4) echo "4. Performing post-install steps..."; sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list > /dev/null 2>&1 && apt-get update > /dev/null 2>&1 && apt-get -y install vim htop tmux > /dev/null 2>&1 ;;
        5) echo "5. Configuring dark mode..."; apt-get -y install git > /dev/null 2>&1 && git clone https://github.com/Weilbyte/PVEDiscordDark.git /tmp/PVEDiscordDark > /dev/null 2>&1 ;;
        6) echo "6. Running the install script..."; cd /tmp/PVEDiscordDark && ./install.sh > /dev/null 2>&1 && cd ~ ;;
        7) echo "7. Removing temporary repository folder..."; rm -rf /tmp/PVEDiscordDark > /dev/null 2>&1 ;;
        8) echo "8. Restarting Proxmox services..."; systemctl restart pveproxy pvestatd > /dev/null 2>&1 ;;
        9) echo "Post-install script complete! The server is now secured, post-install steps are performed, and dark mode is enabled." > /dev/null 2>&1 ;;
    esac

    progress_bar $TOTAL_STEPS $current_step
    echo -e "\n"
    current_step=$((current_step + 1))
done


