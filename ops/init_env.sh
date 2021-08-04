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

zypper install -y git 
git clone https://github.com/discourse/discourse.git

# Install docker
sudo zypper install -y docker python3-docker-compose
sudo systemctl enable docker
sudo usermod -G docker -a $USER
sudo systemctl restart docker
docker version

# init k8s and argo and MAMO and kubeflow

# deploy discourse
# https://github.com/discourse/discourse.git
curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
docker-compose up -d


