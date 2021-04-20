#!/bin/sh
#----------------------------------------------------------
# CUDA INSTALL
# Written by Inga Paster on 18 April 2021
# be on bhn25!

#----------------------------------------------------------
# Version of CUDA:
#----------------------------------------------------------
echo
echo ".................................................................."
echo "   Extract version of CUDA  "
echo ".................................................................."
cuda_ver_tmp=$(/usr/local/cuda/bin/nvcc --version| awk -F 'cuda_' '{print $2}'|sed '/^[[:space:]]*$/d')
cuda_ver_tmp2=${cuda_ver_tmp:0:4}
cuda_ver_name=cuda-
cuda_ver="${cuda_ver_name}${cuda_ver_tmp2}"
echo "   Cuda version is "   $cuda_ver 

#----------------------------------------------------------
# Compress 
#----------------------------------------------------------
echo
echo ".................................................................."
echo "   Compress  "
echo ".................................................................."
cd /usr/local/
tar -czf $cuda_ver.tar.gz  $cuda_ver

#----------------------------------------------------------
# Copy to /gpfs0/system/cuda/
#----------------------------------------------------------
echo
echo ".................................................................."
echo "   Copy to /gpfs0/system/cuda/RHEL_8  "
echo ".................................................................."
mv /usr/local/$cuda_ver.tar.gz /gpfs0/system/cuda/RHEL_8

#----------------------------------------------------------
# Extract 
#----------------------------------------------------------
echo
echo ".................................................................."
echo "   Extract   "
echo ".................................................................."
tar -xf /gpfs0/system/cuda/RHEL_8/$cuda_ver.tar.gz -C /gpfs0/system/cuda/RHEL_8/

#----------------------------------------------------------
# Move tar.gz to trash 
#----------------------------------------------------------
echo
echo ".................................................................."
echo "   Move tar.gz to trash   "
echo ".................................................................."
mv /gpfs0/system/cuda/RHEL_8/$cuda_ver.tar.gz /gpfs0/system/cuda/RHEL_8/trash

echo ".................................................................."
echo "   Done  "
echo ".................................................................."
