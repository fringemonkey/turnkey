#!/bin/bash

# Homelab Sandbox
qm create 5010 --name homelab-sandbox --memory 4096 --net0 virtio,bridge=vmbr0.10 --storage Loki-ZFS1
qm importdisk 5010 /path/to/homelab-template.qcow2 Loki-ZFS1
qm set 5010 --scsihw virtio-scsi-pci --scsi0 Loki-ZFS1:vm-5010-disk-0
qm set 5010 --boot c --bootdisk scsi0
qm set 5010 --serial0 socket --vga serial0
qm start 5010
