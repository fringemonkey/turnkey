#!/bin/bash

# Variables
SSH_USER="your_ssh_username"
LOKI_HOST="loki"

# Step 1: Create the new master control node on the current Proxmox stack
# This script will create a new VM, perform an unattended installation of Ubuntu, and convert it into a template
echo "Step 1: Creating master control node template"
./create_master_template.sh

# Step 2: Create and configure the Proxmox node
echo "Step 2: Creating and configuring the Proxmox node"
ssh ${SSH_USER}@${LOKI_HOST} "bash -s" < configure_proxmox.sh

# Step 3: Create a VM to run the VyOS and configure DHCP with a new 10.10.1.0/16 network
echo "Step 3: Creating and configuring VyOS VM for DHCP and DNS"
ssh ${SSH_USER}@${LOKI_HOST} "bash -s" < vyos_setup.sh

# Step 4: Adjust the Proxmox settings to reflect the new network changes
echo "Step 4: Adjusting Proxmox settings for the new network"
ssh ${SSH_USER}@${LOKI_HOST} "bash -s" < adjust_proxmox_network.sh

# Step 5: Create a network in Proxmox and VyOS for each sandbox
echo "Step 5: Creating sandbox networks"
ssh ${SSH_USER}@${LOKI_HOST} "bash -s" < create_sandbox_networks.sh

# Step 6: Make sure each sandbox network is routable to the master node network for internet access
echo "Step 6: Configuring sandbox network routing"
ssh ${SSH_USER}@${LOKI_HOST} "bash -s" < configure_network_routing.sh
