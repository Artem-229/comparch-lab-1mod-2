#!/bin/bash

echo ">>> Decompressing..."
gzip -dk image.qcow2.gz
echo ">>> Starting up!"

qemu-system-aarch64 \
    -m 512 \
    -M virt \
    -drive file="image.qcow2",format=qcow2 \
    -net nic \
    -net user \
    -nographic \
    -serial mon:stdio \
    -smp 8 -cpu cortex-a76 \
    -bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd

echo ">>> Cleaning up..."
rm image.qcow2
