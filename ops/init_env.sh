!/bin/bash
#=========================================================================================================================
# Info: 导入到训练镜像并插入数据库
# Creator: thomas
# Update: 2021-07-31 
# Tool version: 0.1.0
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

# init system
# install GPU driver and toolkit
# Install git  

tmux, moning brew, timeshift,htop,MCDU,timetrap

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper refresh
sudo zypper install -y code

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

export PATH=/home/thomas/bin:/usr/local/bin:/usr/bin:/bin:/home/thomas/minio-binaries/:/home/thomas/minio-binaries/:/usr/local/cuda-11.4/bin
export LD_LIBRARY_PATH=:/usr/local/cuda-11.4/lib64
source ~/.bashrc

# Add the package repositories
# accept the overwrite of /etc/docker/daemon.json

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)   \
    && sudo zypper ar https://nvidia.github.io/nvidia-docker/${distribution}/nvidia-docker.repo   \
    && sudo zypper ar https://download.opensuse.org/repositories/Virtualization:/containers/${distribution}/Virtualization:containers.repo   \
    && sudo zypper ref  \
    && sudo zypper install -y --allow-vendor-change 'docker >= 19.03'   python3-docker-compose   \
    && docker version    \
    && sudo usermod -G docker -a $USER   \
    && sudo systemctl --now enable docker   \
    && sudo systemctl start docker   \
    && sudo zypper install  nvidia-docker2   \
    && sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# init k8s and argo and MAMO and kubeflow

# deploy discourse
# https://github.com/discourse/discourse.git
# curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
# docker-compose up -d

## config network
/etc/sysconfig/network/ifcfg-eth0
sudo echo """
BOOTPROTO='static'
IPADDR='192.168.2.63'
MTU='1500'
NAME=''
NETMASK='255.255.255.0'
STARTMODE='auto'
USERCONTROL='no'
""" > /etc/sysconfig/network/ifcfg-enp2s0
/etc/sysconfig/network/routes
default 192.168.2.1 - -


# static DNS configuration using the following variables in the
# /etc/sysconfig/network/config file:
#     NETCONFIG_DNS_STATIC_SEARCHLIST
#     NETCONFIG_DNS_STATIC_SERVERS
#     NETCONFIG_DNS_FORWARDER
# or disable DNS configuration updates via netconfig by setting:
#     NETCONFIG_DNS_POLICY=''

# Install cuda 
wget https://developer.download.nvidia.com/compute/cuda/11.4.1/local_installers/cuda_11.4.1_470.57.02_linux.run
sudo sh cuda_11.4.1_470.57.02_linux.run

# Install OBS
sudo zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper dup --from packman --allow-vendor-chang
sudo zypper in obs-studio

