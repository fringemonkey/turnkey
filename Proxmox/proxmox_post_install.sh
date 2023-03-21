#!/bin/bash

# Run with 
# wget https://raw.githubusercontent.com/fringemonkey/turnkey/3751920478010397078b1760d677c9a6b98ab313/Proxmox/proxmox_post_install.sh && chmod +x proxmox_post_install.sh && ./proxmox_post_install.sh
#

# Update the package index and upgrade existing packages
echo "Updating and upgrading packages..."
apt-get update && apt-get -y upgrade

# Secure the server using Linux and Proxmox best practices
echo "Securing the server..."

# Disable root login via SSH
echo "Disabling root login via SSH..."
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart ssh

# Install Fail2Ban for protection against brute force attacks
echo "Installing Fail2Ban..."
apt-get -y install fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# Perform post-install steps recommended on GitHub
echo "Performing post-install steps..."
# Add contrib and non-free repositories
echo "Adding contrib and non-free repositories..."
sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list

# Update package index and install necessary packages
echo "Updating package index and installing necessary packages..."
apt-get update && apt-get -y install vim htop tmux

# Configure dark mode for the Proxmox web interface
echo "Configuring dark mode..."

# Clone the Discord-like theme repository
echo "Cloning the Discord-like theme repository..."
apt-get -y install git
git clone https://github.com/Weilbyte/PVEDiscordDark.git /tmp/PVEDiscordDark

# Run the install script from the repository
echo "Running the install script..."
bash /tmp/PVEDiscordDark/install.sh

# Remove the temporary repository folder
echo "Removing temporary repository folder..."
rm -rf /tmp/PVEDiscordDark

# Restart the Proxmox services
echo "Restarting Proxmox services..."
systemctl restart pveproxy pvestatd

echo "Post-install script complete! The server is now secured, post-install steps are applied, and dark mode is enabled."
