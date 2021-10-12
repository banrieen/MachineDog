!/bin/bash
#=========================================================================================================================
# Info: 多租户任务容器编排
# Creator: thomas
# Update: 2021-07-31 
# Tool version: 0.1.0
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================
1. 存储多租户
2. service 管理员
数据库应该是独立集群
3. 多租户pod
存储 + 数据库 + 控制台 + 【编排控制器 + etcd + virtual network】=>(security)job-pod[resource + network + service] 

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

mkfs -t btrfs /dev/sda1

mount /dev/sda1 /mnt/storage

sudo mkdir -p /mnt/storage/discourse
sudo mkdir -p /mnt/storage/discourse/postgres
sudo mkdir -p /mnt/storage/discourse/redis
sudo mkdir -p /mnt/storage/discourse/discourse

# init k8s and argo and MAMO and kubeflow

# deploy discourse
# https://github.com/discourse/discourse.git
curl -sSL https://raw.githubusercontent.com/bitnami/bitnami-docker-discourse/master/docker-compose.yml > docker-compose.yml
docker-compose up -d

# Install Deno

# Install minio server 
curl http://dl.minio.org.cn/server/minio/release/linux-amd64/minio \
  --create-dirs \
  -o $HOME/minio-binaries/minio

chmod +x $HOME/minio-binaries/minio
export PATH=$PATH:$HOME/minio-binaries/

# Create new local crt
## 生成私钥
openssl genrsa -out local_ssl.key 4096
## 生成签名请求
openssl req -new -key local_ssl.key -out local_ssl.csr
## 生成CA证书
openssl x509 -req -in local_ssl.csr -signkey local_ssl.key -out local_ssl.crt
## 导出PKCS12格式文件
openssl pkcs12 -export -in local_sign.crt -inkey local_sign.key -out local_sign.p12

# Mount new disk 
# cat uuid: blkid /dev/sda1
sudo chmod +w /etc/fstab
sudo echo "UUID=67bfe2bb-6dd5-4123-b838-e2e8bb93b6cb  /data/disk2                       btrfs  defaults                      0  0" >> /etc/fstab
sudo echo "UUID=f8f29b38-6c4b-4df6-9c8d-7f33f26747e3  /data/disk1                       btrfs  defaults                      0  0" >> /etc/fstab
sudo chmod -w /etc/fstab

