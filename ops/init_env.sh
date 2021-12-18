!/bin/bash
#=========================================================================================================================
# Info: 多租户任务容器编排
# Creator: thomas
# Update: 2021-07-31 
# Tool version: 0.1.0
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================
查看系统版本信息
cat /proc/version
查看系统指令多少位
getconf LONG_BIT



1. 存储多租户
2. service 管理员
数据库应该是独立集群
3. 多租户pod
存储 + 数据库 + 控制台 + 【编排控制器 + etcd + virtual network】=>(security)job-pod[resource + network + service] 

# 远程文件管理
# mkdir -p ~/storage/filebrowser
# filepath="/mnt/c/Users/lizhen"
touch $filepath/storage/filebrowser/.filebrowser.json
touch $filepath/storage/filebrowser/filebrowser.db
podman run \
    -v $filepath/storage/filebrowser/:/srv \
    -v $filepath/storage/filebrowser/filebrowser.db:/database.db \
    -v $filepath/storage/filebrowser/.filebrowser.json:/.filebrowser.json \
    --user $(id -u):$(id -g) \
    -p 8888:80 \
    filebrowser/filebrowser

filebrowser config set --branding.name "thomas" \
    --branding.files "/mnt/c/Users/lizhenstorage/filebrowser" \
    --branding.disableExternal

# init system
# install GPU driver and toolkit
# Install git  

tmux, moning brew, timeshift,htop,MCDU,timetrap

ventoy 多系统   启动盘
# Uninstall old versions
 sudo zypper remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  runc
# Get opensuse version id
# if [ -e /etc/os-release ]; then
# VERSION_ID=$(cat /etc/os-release | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# else
# VERSION_ID=$(cat /usr/lib/os-release  | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# fi

# Install GPU Driver
zypper addrepo --refresh 'https://download.nvidia.com/opensuse/leap/$releasever' NVIDIA
# Get hardware information
sudo hwinfo --gfxcard | grep Model
sudo hwinfo --arch
# Install 
sudo zypper se -s x11-video-nvidiaG0*
sudo zypper se nvidia-glG0*
sudo zypper in x11-video-nvidiaG05
sudo zypper in nvidia-glG05


# Add the package repositories
# accept the overwrite of /etc/docker/daemon.json

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)   \
    && sudo zypper ar https://nvidia.github.io/nvidia-docker/${distribution}/nvidia-docker.repo   \
    && sudo zypper ar https://download.opensuse.org/repositories/Virtualization:/containers/${distribution}/Virtualization:containers.repo   \
    && zypper addrepo https://download.opensuse.org/repositories/openSUSE:Factory/standard/openSUSE:Factory.repo   \
    && sudo zypper ref  \
    && sudo zypper install -y --allow-vendor-change helm  ansible \
    && docker version    \
    && sudo zypper install  nvidia-docker2   \
    && sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

mkfs -t btrfs /dev/sda1

mount /dev/sda1 /mnt/storage

sudo mkdir -p /mnt/storage/discourse
sudo mkdir -p /mnt/storage/discourse/postgres
sudo mkdir -p /mnt/storage/discourse/redis
sudo mkdir -p /mnt/storage/discourse/discourse

# init k8s and argo and MAMO and kubeflow

# deploy discourse
# https://github.com/discourse/discourse.git
# curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
# docker-compose up -d

## config network
/etc/sysconfig/network/ifcfg-eth0
BOOTPROTO='static'
IPADDR='192.168.2.77'
MTU='1500'
NAME=''
NETMASK='255.255.255.0'
STARTMODE='auto'
USERCONTROL='no'

/etc/sysconfig/network/routes
default 192.168.2.1 - -

# Install cuda 
wget https://developer.download.nvidia.com/compute/cuda/11.4.1/local_installers/cuda_11.4.1_470.57.02_linux.run
sudo sh cuda_11.4.1_470.57.02_linux.run

# Install OBS
sudo zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper dup --from packman --allow-vendor-chang
 sudo zypper in obs-studio

# Install minIO

mkdir ${HOME}/.minio/certs
# create random key string
cat /dev/urandom | head -c 32 | base64 -

ls ~/.ssh/

minioadmin:minioadmin

podman run -p 9000:8090 -p 9001:9091 \
  -v /data/disk1:/data  \
  quay.io/minio/minio server /data --console-address ":9001"

podman run  -p 9000:9000 -p 9001:9001 \
  -v /data/disk1:/disk1  \   
  quay.io/minio/minio server /disk1 --console-address ":9001"


podman run -d -p 9000:8090 \
-e "MINIO_ROOT_USER_FILE=Root@Access$202110Key*" \
-e "MINIO_ROOT_PASSWORD_FILE=/NDMJoAU20tq8Rux3gdHrNOaF225SEnf7fv2l3jVQpU=" \
-e "MINIO_KMS_SECRET_KEY_FILE=perf-minio-encryption-key:bwgLImyGoNDjokf2EMO16GiRxwub0t+a0PGt2PoZle9s=" \
-v /data/disk1:/disk1 \
minio/minio server /disk1

podman run -p 9000:9000 \
-e "MINIO_ROOT_USER_FILE=ROOT_ACCESS_KEY" \
-e "MINIO_ROOT_PASSWORD_FILE=SECRET_ACCESS_KEY_CHANGE_ME" \
-e "MINIO_KMS_SECRET_KEY_FILE=my-minio-encryption-key:bXltaW5pb2VuY3J5cHRpb25rZXljaGFuZ2VtZTEyMwo=" \
-v /mnt/disk1:/disk1 \
-v /mnt/disk2:/disk2 \
-v /mnt/disk3:/disk3 \
-v /mnt/disk4:/disk4 \
minio/minio server /disk{1...4}

sudo zypper addrepo https://download.opensuse.org/repositories/openSUSE:Factory/standard/openSUSE:Factory.repo
sudo zypper refresh
sudo zypper install libnvidia-container
zypper install libnvidia-container1
zypper install libnvidia-container-devel
zypper install libnvidia-container-tools


sudo usermod -G root thomas
sudo usermod -G video thomas
su - thomas -c nvidia-container-cli info
podman run --gpus all -it --rm -v /data/disk1:/data nvcr.io/nvidia/pytorch:21.10-py3 bash

# 本地Python虚拟环境
pip install virtualenvwrapper