#!/bin/bash
set -e

# VM parameters
VM_ID=5000
VM_NAME="sandmaster"
VM_IP="192.168.200.50"
DNS_SERVER="192.168.1.3"
HOSTNAME="sandmaster"
CPU_CORES=4
RAM_MB=2048
RAM_MAX_MB=49152
STORAGE_POOL="Loki-ZFS1"
ISO_STORE="/var/lib/vz/template/iso"
PROXMOX_ISO="proxmox-ve_7.1-1.iso"
PROXMOX_URL="https://download.proxmox.com/iso/$PROXMOX_ISO"

# Check if the Proxmox VE ISO is available in the Proxmox ISO store
if [ ! -f "$ISO_STORE/$PROXMOX_ISO" ]; then
  echo "Proxmox VE ISO not found. Downloading..."
  wget -P "$ISO_STORE" "$PROXMOX_URL"
fi

# Create the VM
qm create $VM_ID --name $VM_NAME --ostype l26 --bootdisk scsi0

# Set CPU and memory
qm set $VM_ID --sockets 1 --cores $CPU_CORES --memory $RAM_MB --balloon $RAM_MAX_MB

# Configure the VM's disk
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE_POOL:32

# Configure the VM's network
qm set $VM_ID --net0 virtio,bridge=vmbr0

# Attach the Proxmox VE ISO to the VM
qm set $VM_ID --cdrom $ISO_STORE/$PROXMOX_ISO

# Configure the VM to boot from the ISO
qm set $VM_ID --boot c --bootdisk scsi0

# Start the VM
qm start $VM_ID

# Run the proxmox_install.exp script to automate the Proxmox VE installation
./proxmox_install.exp $VM_ID
