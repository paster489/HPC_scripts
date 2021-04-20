#!/bin/sh
#----------------------------------------------------------
# CUDA UNINSTALL
# Written by Inga Paster on 18 April 2021
# Ran on bhn25
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#removing-cuda-tk-and-driver
#----------------------------------------------------------

echo
echo ".................................................................."
echo "  To remove CUDA Toolkit: "
echo ".................................................................."
dnf remove "cuda*" "*cublas*" "*cufft*" "*curand*" \
 "*cusolver*" "*cusparse*" "*npp*" "*nvjpeg*" "nsight*" -y

echo
echo ".................................................................."
echo "  To remove NVIDIA Drivers: "
echo ".................................................................."
dnf remove "nvidia*" -y

echo
echo ".................................................................."
echo "  To reset the module stream: "
echo ".................................................................."
dnf module reset nvidia-driver -y

echo
echo ".................................................................."
echo "   nvidia-smi -> recheck "
echo ".................................................................."
nvidia-smi

echo
echo ".................................................................."
echo "   Done! Please do reboot manually. "
echo ".................................................................."

# https://stackoverflow.com/questions/43022843/nvidia-nvml-driver-library-version-mismatch
# lsmod | grep nvidia
# rmmod nvidia_drm
# rmmod nvidia_modeset
# rmmod nvidia

# https://clay-atlas.com/us/blog/2020/03/04/linux-english-note-how-to-disable-nvidia-drm/
# close all the processes use GPU
# systemctl isolate multi-user.target

# disable nvidia driver
# modprobe -r nvidia-drm

# https://clay-atlas.com/us/blog/2020/03/04/linux-english-note-how-to-disable-nvidia-drm/
# yum autoremove -y
