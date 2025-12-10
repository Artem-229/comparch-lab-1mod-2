#!/bin/bash

echo ">>> Fetching Alpine 3.23 (VIRT)..."
if [ ! -f "image.iso" ]; then
    wget -O image.iso https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/aarch64/alpine-virt-3.23.0-aarch64.iso
else
    echo "(skipping, image already found)"
fi
echo ">>> Formatting new disk..."
if [ -f "image.qcow2" ]; then
    echo "qcow2 image already exists! Remove it manually if it is actually no longer used."
    exit 1
fi
qemu-img create -f qcow2 image.qcow2 2G
echo ">>> Installing from ISO..."
qemu-system-aarch64 \
    -m 512 \
    -M virt \
    -boot d \
    -cdrom "image.iso" \
    -drive file="image.qcow2",format=qcow2 \
    -net nic \
    -net user \
    -nographic \
    -serial mon:stdio \
    -smp 8 -cpu cortex-a76 \
    -bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd

rm image.iso
gzip image.qcow2
echo ">>> Image packed!"
