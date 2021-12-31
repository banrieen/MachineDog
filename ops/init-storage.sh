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

# Mount disk
# manual setup
lsblk
mkdir -p /data/diska
DiskUUID=$(sudo blkid /dev/sda1 | cut -d' ' -f2)
sudo chmod +x /etc/fstab
sudo echo "${DiskUUID}  /data/diska             btrfs  defaults     0    0" >> /etc/fstab
sudo chmod -x /etc/fstab

# Deploy minIO services
## echo "12|23|11" | awk '{split($0,a,"|"); print a[3],a[2],a[1]}'

# Setup firewalld
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --add-port=9000/tcp --permanent
sudo firewall-cmd --reload




# Fileserver https://caddyserver.com/docs/

# LabelStudio
podman run -d -it -p 8080:8080 -v `pwd`/labelDatasets:/label-studio/data heartexlabs/label-studio:latest