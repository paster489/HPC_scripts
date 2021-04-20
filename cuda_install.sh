#!/bin/sh
#----------------------------------------------------------
# CUDA INSTALL
# Written by Inga Paster on 18 April 2021
# https://developer.nvidia.com/cuda-toolkit-archive
# https://developer.download.nvidia.com/compute/cuda/repos/
# Ran on bhn25
# Comment: the script doesn't evaluate rpm comand after wget, I did it manually

# Select version of CUDA: 11.2, 11.1, 11.0, 10.2 (doesn't work), 10.1 (doesn't work)
version=11.2

echo
echo ".................................................................."
echo "   WGET & RPM  "
echo ".................................................................."

case $version in
	11.2)
		#wget https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda-repo-rhel8-11-2-local-11.2.1_460.32.03-1.x86_64.rpm
		rpm -i cuda-repo-rhel8-11-2-local-11.2.1_460.32.03-1.x86_64.rpm
		;;
	11.1)
		#wget https://developer.download.nvidia.com/compute/cuda/11.1.1/local_installers/cuda-repo-rhel8-11-1-local-11.1.1_455.32.00-1.x86_64.rpm
		rpm -i cuda-repo-rhel8-11-1-local-11.1.1_455.32.00-1.x86_64.rpm
		;;
	11.0)
		#wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda-repo-rhel8-11-0-local-11.0.3_450.51.06-1.x86_64.rpm
		rpm -i cuda-repo-rhel8-11-0-local-11.0.3_450.51.06-1.x86_64.rpm
		;;
	10.2)
		#wget https://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-rhel8-10-2-local-10.2.89-440.33.01-1.0-1.x86_64.rpm
		rpm -i cuda-repo-rhel8-10-2-local-10.2.89-440.33.01-1.0-1.x86_64.rpm
		;;
	10.1)
		#wget https://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda-repo-rhel8-10-1-local-10.1.243-418.87.00-1.0-1.x86_64.rpm
		rpm -i cuda-repo-rhel8-10-1-local-10.1.243-418.87.00-1.0-1.x86_64.rpm
		;;
	*)
		echo -n "unknown"
		;;
esac

echo
echo ".................................................................."
echo "   Clean all  "
echo ".................................................................."
dnf clean all

#----------------------------------------------------------
# For CUDA-11.2-->10.2
#----------------------------------------------------------
echo
echo ".................................................................."
echo "   Drivers install  "
echo ".................................................................."
if [ "$version" == "10.1" ]
then
	echo "no driver install"
else
	dnf -y module install nvidia-driver:latest-dkms
fi

echo
echo ".................................................................."
echo "   Cuda install  "
echo ".................................................................."
dnf -y install cuda

echo
echo ".................................................................."
echo "   nvidia-smi  "
echo ".................................................................."
nvidia-smi

#echo
#echo ".................................................................."
#echo "   Reboot  "
#echo ".................................................................."
#reboot

echo
echo ".................................................................."
echo "   Done, do reboot manually "
echo ".................................................................."



