#!/bin/bash

# Small Sandbox
qm create 5030 --name small-sandbox --memory 2048 --net0 virtio,bridge=vmbr0.30 --storage Loki-ZFS1
qm importdisk 5030 /path/to/small-template.qcow2 Loki-ZFS1
qm set 5030 --scsihw virtio-scsi-pci --scsi0 Loki-ZFS1:vm-5030-disk-0
qm set 5030 --boot c --bootdisk scsi0
qm set 5030 --serial0 socket --vga serial0
