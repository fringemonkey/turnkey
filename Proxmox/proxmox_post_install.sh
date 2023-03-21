#!/bin/bash

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

# Install the dark theme package
echo "Installing the dark theme package..."
apt-get -y install proxmox-theme-dark

# Enable the dark mode
echo "Enabling dark mode..."
echo "DATA_DIR=\"/usr/share/pve-manager\"
CSS_EXT_FILE=\"$DATA_DIR/ext6/ext-theme-gray/ext-theme-gray-all.css\"
CSS_DARK_FILE=\"$DATA_DIR/ext6/proxmox-theme-dark/proxmox-theme-dark-all.css\"

if [ -f \"$CSS_DARK_FILE\" ]; then
    echo \"Dark mode enabled.\"
    mv \"$CSS_EXT_FILE\" \"$CSS_EXT_FILE.bak\"
    ln -s \"$CSS_DARK_FILE\" \"$CSS_EXT_FILE\"
else
    echo \"Error: Dark mode CSS file not found.\"
    exit 1
fi" > /usr/local/bin/enable-darkmode.sh
chmod +x /usr/local/bin/enable-darkmode.sh
/usr/local/bin/enable-darkmode.sh

# Restart the Proxmox services
echo "Restarting Proxmox services..."
systemctl restart pveproxy pvestatd

echo "Post-install script complete! The server is now secured, post-install steps are applied, and dark mode is enabled."
