#!/bin/bash

# Clone the repository and navigate to the turnkey directory
git clone https://github.com/fringemonkey/turnkey.git /opt/turnkey

# Run the other scripts from the repository
/opt/turnkey/masternode_setup/create_proxmox_template.sh
/opt/turnkey/masternode_setup/configure_proxmox.sh
/opt/turnkey/masternode_setup/create_vyos_router.sh
/opt/turnkey/masternode_setup/create_sandbox_networks.sh

# Remove the cloned repository
rm -rf /opt/turnkey