!/bin/bash
#=========================================================================================================================
# Info: 存储初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
1. Setup hardare, disk, cluster net
2. Deploy minIO as services
3. maintainer 
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================
# Kernel control groups
# Enable Cgroup-v2
## Edit grub
## refer: [Modifying kernel boot parameters](https://documentation.suse.com/smart/linux/single-html/task-modify-kernel-boot-parameter/index.html)
## refer: [Kernel control groups](https://documentation.suse.com/sles/15-SP3/html/SLES-all/cha-tuning-cgroups.html)  
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="mitigations=auto quiet"/GRUB_CMDLINE_LINUX_DEFAULT="cgroup_no_v1=blkio systemd.unified_cgroup_hierarchy=1 splash=silent mitigations=auto quiet"/g' /etc/default/grub
sudo update-bootloader --refresh
cat /proc/cmdline
## reboot
stat -c %T -f /sys/fs/cgroup
sudo su
cat /sys/fs/cgroup/unified/cgroup.controllers
cd /sys/fs/cgroup/unified/
echo '+io' > cgroup.subtree_control

# Mount disk
lsblk
mkdir -p /data/diska
DiskUUID=$(sudo blkid /dev/sda1 | cut -d' ' -f2)
sudo chmod +x /etc/fstab
sudo echo "${DiskUUID}  /data/diska             btrfs  defaults     0    0" >> /etc/fstab
sudo chmod -x /etc/fstab

# Deploy minIO services
## echo "12|23|11" | awk '{split($0,a,"|"); print a[3],a[2],a[1]}'
# S3
podman run \
 -p 9000:9000 \
 -p 9001:9001 \
 --name minio-s3 \
 -e "MINIO_ROOT_USER=aws_s3_access_key" \
 -e "MINIO_ROOT_PASSWORD=aws_s3_secret_key" \
 quay.io/minio/minio gateway s3 --console-address ":9001"


# Setup firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=9000/tcp --permanent
sudo firewall-cmd --permanent --add-port 80/tcp
sudo firewall-cmd --permanent --add-port 9001/tcp
sudo firewall-cmd --reload
# Fileserver https://caddyserver.com/docs/

## Setup minIO account
MINIO_ROOT_USER=changeme 
MINIO_ROOT_PASSWORD=changeme 

# Configure an nginx reverse proxy


# LabelStudio
podman run -d -it -p 8080:8080 -v `pwd`/labelDatasets:/label-studio/data heartexlabs/label-studio:latest