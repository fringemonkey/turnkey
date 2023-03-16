#!/bin/bash

# Replace these variables with appropriate values for your environment
VYOS_TEMPLATE_ID=100
VYOS_VM_ID=101
VYOS_HOSTNAME="vyos-router"
VM_STORAGE="Loki-ZFS1"
NETWORK_BRIDGE="vmbr0"

# Create VyOS VM
qm clone $VYOS_TEMPLATE_ID $VYOS_VM_ID --name $VYOS_HOSTNAME --storage $VM_STORAGE
qm set $VYOS_VM_ID --net0 virtio,bridge=$NETWORK_BRIDGE
qm start $VYOS_VM_ID

# Add VyOS configuration commands here
# You can use the VyOS CLI or the API to configure VyOS
