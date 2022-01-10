!/bin/bash
#=========================================================================================================================
# Info: 系统环境初始化
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
# 1. Online install tools
# 2. Offline installation
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

# Online installation
#-------------------------------------------------------------------------------------------------------------------------
workspace=$HOME
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
sudo zypper refresh
sudo zypper install -y code

# Install OBS
sudo zypper ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper dup --from packman --allow-vendor-chang
sudo zypper in obs-studio

# Install frps 
wget https://github.com/fatedier/frp/releases/download/v0.38.0/frp_0.38.0_linux_amd64.tar.gz
tar zxf frp_0.38.0_linux_amd64.tar.gz
cp frps /usr/local/bin/frps
mkdir /etc/frp
cp frps.ini /etc/frp/frps.ini

## client configuration
cat > /etc/frp/frpc.ini << EOF
[common]
server_addr =  122.51.195.199
server_port = 7000
token = Aiops@2025
[ssh]
type = tcp
local_ip = 127.0.0.1 
local_port = 2025
remote_port = 6022
[smb]
type = tcp
local_ip = 127.0.0.1
local_port = 445
remote_port = 7002
EOF

## systemctl service
sudo cat > /etc/systemd/system/frps.service << EOF
# 内容如下
[Unit]
Description=frps
After=network.target

[Service]
TimeoutStartSec=30
ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
ExecStop=/bin/kill $MAINPID
Restart=on-failure
RestartSec=30s
KillMode=none

[Install]
WantedBy=multi-user.target
EOF
## 启动 frp 并设置开机启动
sudo systemctl stop frps
sudo systemctl disable frps
sudo systemctl start frps
sudo systemctl enable frps
### sudo systemctl status frps

# Discourse
### https://github.com/discourse/discourse.git
curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
docker-compose up -d


# Offline installation (Debin/Ubuntu)
#-------------------------------------------------------------------------------------------------------------------------
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

