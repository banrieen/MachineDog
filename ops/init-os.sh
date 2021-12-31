!/bin/bash
#=========================================================================================================================
# Info: 系统环境初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
1. OS System update, hypervisor, account, 
2. Config network, sshd and firewalld
3. Install and config gpu driver and cuda toolkits 
4. Install podman and enable rootless, Nvidia-container-toolkit
5. Install another usefull tools
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

workspace=$HOME
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
# Get opensuse version id
# if [ -e /etc/os-release ]; then
# VERSION_ID=$(cat /etc/os-release | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# else
# VERSION_ID=$(cat /usr/lib/os-release  | grep VERSION_ID |  grep -Eo '[0-9]+\.[0-9]+')
# fi

# Add user to particular group
USERNAME=$(whoami)
sudo usermod -a -G sudo $USERNAME
sudo usermod -a -G root $USERNAME
sudo usermod -a -G docker $USERNAME
# Add to sudoers without passwd
sudo echo 'yijie  ALL=(ALL)  NOPASSWD: ALL' >> /etc/sudoers
sudo echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
## config network
sudo echo """
BOOTPROTO='static'
8.2.1 - -' > /etc/sysconfig/network/routes

## static DNS configuration using the following variables in the
## /etc/sysconfig/network/config file:
##     NETCONFIG_DNS_STATIC_SEARCHLIST
##     NETCONFIG_DNS_STATIC_SERVERS
##     NETCONFIG_DNS_FORWARDER
## or disable DNS configuration updates via netconfig by setting:
##     NETCONFIG_DNS_POLICY=''

# Install GPU Driver & # cuda 
zypper addrepo --refresh 'https://download.nvidia.com/opensuse/leap/$distribution' NVIDIA
sudo hwinfo --gfxcard | grep Model
sudo hwinfo --arch
sudo zypper se -s x11-video-nvidiaG0*
sudo zypper se nvidia-glG0*
sudo zypper in -y x11-video-nvidiaG05 nvidia-glG05

wget https://developer.download.nvidia.com/compute/cuda/11.4.1/local_installers/cuda_11.4.1_470.57.02_linux.run
sudo sh cuda_11.4.1_470.57.02_linux.run
"""
sudo echo """
export PATH=/home/thomas/bin:/usr/local/bin:/usr/bin:/bin:/home/thomas/minio-binaries/:/home/thomas/minio-binaries/:/usr/local/cuda-11.4/bin
export LD_LIBRARY_PATH=:/usr/local/cuda-11.4/lib64
""" >> ~/.bashrc
source ~/.bashrc

# Install and set podman 
sudo zypper in -y podman buildah skopeo && podman --version
## config rootless
sudo usermod --add-subuids 200000-201000 --add-subgids 200000-201000 $USER

## Add the package repositories and install nvidia-container-toolkit
sudo zypper ar https://download.opensuse.org/repositories/Virtualization:/containers/${distribution}/Virtualization:containers.repo   \
    && sudo zypper ref  \
    && sudo zypper install -y nvidia-container-toolkit \
    && podman run -it --rm nvidia/cuda:11.0-base nvidia-smi

## Config nvidia-container rootless support
sudo sed -i 's/^#no-cgroups = false/no-cgroups = true/;' /etc/nvidia-container-runtime/config.toml
## sudo sed -i 's/^no-cgroups = true/#no-cgroups = false/;' /etc/nvidia-container-runtime/config.toml
## Update registries
sudo vim /etc/containers/registries.conf
[registries.search]
registries = ["nvcr.io", "docker.io"]
## if a container starts a particular application, the container exits as soon as the application quits. 
## podman start -ai <container name>
## loginctl list-sessions | grep $USER

# Update sshd port
sudo systemctl enable sshd && sudo systemctl start sshd
sudo sed -i 's/^#Port 22/Port 2025/;' /etc/ssh/sshd_config 
sudo systemctl restart sshd.service
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=2025/tcp --permanent
sudo firewall-cmd --zone=public --remove-port=22/tcp --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent
sudo firewall-cmd --reload 
sudo firewall-cmd --list-ports
sudo firewall-cmd --list-services --permanent 
## reboot
## loginctl kill-session SESSION_ID

# ==================================================================
## Install tools

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper refresh
sudo zypper install -y code

# Install OBS
sudo zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper dup --from packman --allow-vendor-chang
sudo zypper in obs-studio

# Install frpc 

## deploy discourse
## https://github.com/discourse/discourse.git
## curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
## docker-compose up -d


## Offline Install 
## Refer: https://ostechnix.com/download-packages-dependencies-locally-ubuntu/
mkdir $HOME/offline && cd $H--download-onlyOME/offline
sudo apt-get install --download-only openssh-server
for i in $(apt-cache depends python | grep -E 'Depends|Recommends|Suggests' | cut -d ':' -f 2,3 | sed -e s/'<'/''/ -e s/'>'/''/); do sudo apt-get download $i 2>>errors.txt; done 
zip -o offline.zip ./*

sudo dpkg -i *
### Another Motheds
# aptitude clean
# aptitude --download-only install <your_package_here>
# cp /var/cache/apt/archives/*.deb <your_directory_here>

