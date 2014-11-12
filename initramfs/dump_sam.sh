#!/bin/sh

for disk in $(ls /dev/sd[a-z])
do
	if [ -z "${disk}" ]
	then
		continue
	fi
	for i in $(seq 1 1 10)
	do
		string=$(fdisk -l "${disk}"| grep -E '^/dev/' | grep -iE 'ntfs' | awk "(NR==${i})")
		if [ -z "${string}" ] 
		then
			continue
		fi

		volume=$(echo -n "${string}" | awk '{print $1}' | awk -F"/" '{print $3}')
		dev="/dev/${volume}"
		mount_point="/mnt/${volume}"

		mkdir -p "${mount_point}"
		mount "${dev}" "${mount_point}"

		samdump2 "${mount_point}/Windows/System32/config/SYSTEM" "${mount_point}/Windows/System32/config/SAM"

		umount "${dev}"
	done
done
