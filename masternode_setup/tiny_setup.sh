#!/bin/bash

# Tiny Sandbox
qm create 5020 --name tiny-sandbox --memory 2048 --net0 virtio,bridge=vmbr0.20 --storage Loki-ZFS1
qm importdisk 5020 /path/to/tiny-template.qcow2 Loki-ZFS1
qm set 5020 --scsihw virtio-scsi-pci --scsi0 Loki-ZFS1:vm-5020-disk-0
qm set 5020 --boot c --bootdisk scsi0
qm set 5020 --serial0 socket --vga serial0
qm start 5020
