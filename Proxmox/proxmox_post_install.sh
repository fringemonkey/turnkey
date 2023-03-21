#!/bin/bash

# Run with 
# wget https://raw.githubusercontent.com/fringemonkey/turnkey/3751920478010397078b1760d677c9a6b98ab313/Proxmox/proxmox_post_install.sh && chmod +x proxmox_post_install.sh && ./proxmox_post_install.sh
#

function progress_bar() {
    local total=$1
    local current=$2
    local width=50

    local percent=$((current * 100 / total))
    local completed_width=$((current * width / total))
    local remaining_width=$((width - completed_width))

    echo -ne "\r["
    printf "%0.s#" $(seq 1 $completed_width)
    printf "%0.s " $(seq 1 $remaining_width)
    echo -ne "] $percent% "
}

TOTAL_STEPS=8
current_step=1

echo "1. Updating and upgrading packages..."
apt-get update > /dev/null 2>&1 && apt-get -y upgrade > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "2. Securing the server..."
echo "   - Disabling root login via SSH..."
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config > /dev/null 2>&1
systemctl restart ssh > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "3. Installing Fail2Ban..."
apt-get -y install fail2ban > /dev/null 2>&1
systemctl enable fail2ban > /dev/null 2>&1
systemctl start fail2ban > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "4. Performing post-install steps..."
echo "   - Adding contrib and non-free repositories..."
sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list > /dev/null 2>&1
apt-get update > /dev/null 2>&1 && apt-get -y install vim htop tmux > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "5. Configuring dark mode..."
echo "   - Cloning the Discord-like theme repository..."
apt-get -y install git > /dev/null 2>&1
git clone https://github.com/Weilbyte/PVEDiscordDark.git /tmp/PVEDiscordDark > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "6. Running the install script..."
bash /tmp/PVEDiscordDark/install.sh > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "7. Removing temporary repository folder..."
rm -rf /tmp/PVEDiscordDark > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

current_step=$((current_step + 1))
echo "8. Restarting Proxmox services..."
systemctl restart pveproxy pvestatd > /dev/null 2>&1
progress_bar $TOTAL_STEPS $current_step
echo -e "\n"

echo "Post-install script complete! The server is now secured, post-install steps are applied, and dark mode is enabled."
