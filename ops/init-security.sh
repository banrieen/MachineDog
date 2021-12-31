!/bin/bash
#=========================================================================================================================
# Info: 安全配置
# Creator: yijie
# Update: 2021-07-31 
# Tool version: 0.1.0
1. Setup hardare, disk, cluster net
2. Deploy minIO as services
3. maintainer 
# Support Platform Version: MachineDevil v0.6.0
#=========================================================================================================================

https://www.vaultproject.io/docs/install#precompiled-binaries

# Source installtion hashicorp vault

mkdir -p $GOPATH/src/github.com/hashicorp && cd $_
sudo chmod 777 $GOPATH/src/github.com/hashicorp
git clone https://github.com/hashicorp/vault.git
cd vault

make bootstrap
