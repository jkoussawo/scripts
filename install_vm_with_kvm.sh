#!/bin/bash

function help {
	echo " Usage : install_vm_with_kvm.sh -s nom_serveur -a ip_serveur "
}

if [ $# -ne 4 ];then
	help
	exit 1
fi

while getopts "s:a:" option
do
	case  $option in
		h)help;;
		s)NOM_SERVEUR=$OPTARG;;
		a)ADDRESSE_IP=$OPTARG;;
		*)help;;
	esac
done

echo "Nous la machine virtuelle  $NOM_SERVEUR,son IP sera $ADDRESSE_IP !"


virsh destroy ${NOM_SERVEUR} ; virsh undefine ${NOM_SERVEUR};

virt-install --name ${NOM_SERVEUR} --memory 2048 --network network=default --vcpus 1\
	-f /dev/pve/lv_${NOM_SERVEUR} --os-type linux --location "/gae/repository/isos/CentOS-7-x86_64-Minimal-2003.iso" \
       	--os-variant rhel7 --initrd-inject "${NOM_SERVEUR}-ks.cfg"\
	--extra-args "inst.ks=file:/${NOM_SERVEUR}-ks.cfg ip=${ADDRESSE_IP} netmask=255.255.255.0 dns=192.168.122.1 gateway=192.168.122.1 console=ttyS0,115200n8 serial" \
       	--nographics --accelerate

