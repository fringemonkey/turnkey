#!/bin/bash

# Add dark mode theme to Proxmox
echo "deb http://download.proxmox.com/debian/pve buster pvetest" > /etc/apt/sources.list.d/pve-enterprise.list
apt-get update
apt-get install -y proxmox-theme-dark

# Configure Proxmox settings if needed
# Add any specific Proxmox configuration commands here
