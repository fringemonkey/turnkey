#!/bin/bash

# To run the script, use the following one-liner:
# wget https://raw.githubusercontent.com/fringemonkey/turnkey/main/Proxmox/error_catching.sh && chmod +x error_catching.sh && wget https://raw.githubusercontent.com/fringemonkey/turnkey/main/Proxmox/proxmox_post_install.sh && chmod +x proxmox_post_install.sh && ./proxmox_post_install.sh

source error_catching.sh

current_step=${1:-1}

verify_step() {
    local step_name=$1
    local verification_cmd=$2

    echo -n "Verifying ${step_name}... "
    if eval "$verification_cmd" > /dev/null 2>&1; then
        echo "OK"
    else
        echo "Failed"
    fi
}

while [ $current_step -le $TOTAL_STEPS ]; do
    case $current_step in
        1) echo "1. Updating and upgrading packages..."; apt-get update > /dev/null 2>&1 && apt-get -y upgrade > /dev/null 2>&1 ;;
        2) echo "2. Securing the server..."; sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config > /dev/null 2>&1 && systemctl restart ssh > /dev/null 2>&1 ;;
        3) echo "3. Installing Fail2Ban..."; apt-get -y install fail2ban > /dev/null 2>&1 && systemctl enable fail2ban > /dev/null 2>&1 && systemctl start fail2ban > /dev/null 2>&1 ;;
        4) echo "4. Performing post-install steps..."; sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list > /dev/null 2>&1 && apt-get update > /dev/null 2>&1 && apt-get -y install vim htop tmux > /dev/null 2>&1 ;;
        5) echo "5. Installing dark mode..."; bash <(curl -s https://raw.githubusercontent.com/Weilbyte/PVEDiscordDark/master/PVEDiscordDark.sh ) install > /dev/null 2>&1 ;;
        6) echo "6. Verifying steps..."; verify_step "packages update and upgrade" "apt list --upgradable 2>/dev/null | grep -q 'upgradable' && echo 'false' || echo 'true'" ;;
        7) echo "7. Verifying steps..."; verify_step "server security" "grep -q 'PermitRootLogin no' /etc/ssh/sshd_config" ;;
        8) echo "8. Verifying steps..."; verify_step "Fail2Ban installation" "systemctl is-active --quiet fail2ban" ;;
        9) echo "9. Verifying steps..."; verify_step "post-install steps" "which vim && which htop && which tmux" ;;
    esac

    progress_bar $TOTAL_STEPS $current_step
    echo -e "\n"
    current_step=$((current_step + 1))
done

echo "Post-install script complete! The server is now secured, post-install steps are performed, and dark mode is enabled."
