#!/bin/bash

# Enable error trapping
set -e
trap 'echo -e "\033[31mError: Command failed at line $LINENO\033[0m"' ERR

# Define a variable to store the current step
current_step_file=".current_step"

# Load the current step from the file, or start from the first step
if [ -f "$current_step_file" ]; then
    current_step=$(cat "$current_step_file")
else
    current_step=1
fi

# Define the progress bar function
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

# Define the total number of steps
TOTAL_STEPS=8

# Execute each step based on the current step value
while [ $current_step -le $TOTAL_STEPS ]; do
    case $current_step in
        1)
            echo "1. Updating and upgrading packages..."
            apt-get update > /dev/null 2>&1 && apt-get -y upgrade > /dev/null 2>&1
            ;;

        2)
            echo "2. Securing the server..."
            echo "   - Disabling root login via SSH..."
            sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config > /dev/null 2>&1
            systemctl restart ssh > /dev/null 2>&1
            ;;

        3)
            echo "3. Installing Fail2Ban..."
            apt-get -y install fail2ban > /dev/null 2>&1
            systemctl enable fail2ban > /dev/null 2>&1
            systemctl start fail2ban > /dev/null 2>&1
            ;;

        4)
            echo "4. Performing post-install steps..."
            echo "   - Adding contrib and non-free repositories..."
            sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list > /dev/null 2>&1
            apt-get update > /dev/null 2>&1 && apt-get -y install vim htop tmux > /dev/null 2>&1
            ;;

        5)
            echo "5. Configuring dark mode..."
            echo "   - Cloning the PVEDiscordDark repository..."
            apt-get -y install git > /dev/null 2>&1
            git clone https://github.com/Weilbyte/PVEDiscordDark.git /tmp/PVEDiscordDark > /dev/null 2>&1
            ;;

        6)
            echo "6. Running the install script..."
            cd /tmp/PVEDiscordDark
            ./install.sh > /dev/null 2>&1
            cd ~
            ;;

        7)
            echo "7. Removing temporary repository folder..."
            rm -rf /tmp/PVEDiscordDark > /dev/null 2>&1
            ;;

        8)
            echo "8. Restarting Proxmox services..."
            systemctl restart pveproxy pvestatd > /dev/null 2>&1
            ;;
    esac

    #
