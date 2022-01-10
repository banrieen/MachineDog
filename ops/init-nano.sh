
# 参考链接
[社区项目](https://developer.nvidia.com/embedded/community/jetson-projects#jetbot)
[镜像](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/dli/containers/dli-nano-ai)
[认证教程](https://courses.nvidia.com/courses/course-v1:DLI+S-RX-02+V2/courseware/b2e02e999d9247eb8e33e893ca052206/63a4dee75f2e4624afbc33bce7811a9b/?activate_block_id=block-v1%3ADLI%2BS-RX-02%2BV2%2Btype%40sequential%2Bblock%4063a4dee75f2e4624afbc33bce7811a9b)
[论坛](https://forums.developer.nvidia.com/c/agx-autonomous-machines/jetson-embedded-systems/70)
sudo apt update 
sudo apt install -y tmux  ufw v4l-utils htop
sudo apt install 
free -m
# Add swap space for AI project
sudo systemctl disable nvzramconfig
sudo fallocate -l 16G /mnt/16GB.swap
sudo mkswap /mnt/16GB.swap
echo "/mnt/16GB.swap    swap   swap  defautls 0   0   " >> /etc/fstab
# Install frp
mkdir -p ~/workspace 
cd ~/workspace


wget https://github.com/fatedier/frp/releases/download/v0.38.0/frp_0.38.0_linux_amd64.tar.gz
tar zxf frp_0.38.0_linux_amd64.tar.gz

# config frpc 
# 复制文件
  sudo cp frpc /usr/local/bin/frpc
  sudo mkdir /etc/frp
  sudo cp frpc.ini /etc/frp/frpc.ini

sudo echo """
[common]
server_addr =  122.51.195.199
server_port = 7000
token = Aiops@2025
[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 2025
remote_port = 7022
""" >  /etc/frp/frpc.ini
  # 编写 frpc service 文件，
  sudo vim /etc/systemd/system/frpc.service
  # 内容如下
  sudo echo """
  [Unit]
  Description=frpc
  Wants=network-online.target
  After=network.target

  [Service]
  type=simple
  #RemainAfterExit=yes
  TimeoutStartSec=120
  ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
  ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini
  ExecStop=/bin/kill -2 $MAINPID
  Restart=on-failure
  RestartSec=30s
  KillMode=none

  [Install]
  WantedBy=multi-user.target
""" >>  /etc/systemd/system/frpc.service

  # 启动 frpc.service 并设置开机启动
sudo systemctl stop frpc
sudo systemctl disable frpc
sudo systemctl start frpc
sudo systemctl enable frpc
# sudo systemctl status frpc

# Config ufw
sudo dpkg --configure -a
sudo apt-get install -y ufw

# 摄像头截图
nvgstcapture-1.0 --orientation 4

# docker jupyter
echo "sudo docker run --runtime nvidia -it --rm --network host \
    --volume ~/nvdli-data:/nvdli-nano/data \
    --volume /tmp/argus_socket:/tmp/argus_socket \
    --device /dev/video0 \
    --memory=500M --memory-swap=8G \
    nvcr.io/nvidia/dli/dli-nano-ai:v2.0.1-r32.6.1" > docker_dli_run.sh
sh ./docker_dli_run.sh
* Open the following link address : 192.168.55.1:8888
* The JupyterLab server running on the Jetson Nano will open up with a login prompt the first time.
Enter the password: dlinano

dli-nano-ai-codeserver:v1.0

## FAQ
Change the default target to graphical.target. To do this, execute the following command:
# systemctl set-default graphical.target
Graphical login is now enabled by default - you will be presented with a graphical login prompt after the next reboot. If you want to reverse this change and keep using the text-based login prompt, execute the following command as root:
# systemctl set-default multi-user.target

# 删除当前目录50个以外的文件
ls -tp | grep -v '/$' | tail -n +50 | xargs -I {} rm -- {}

# 重启GUI
sudo systemctl restart display-manager
# 安装摄像头 驱动
v4l2-ctl --list-formats-ext
wget https://developer.download.nvidia.cn/embedded/L4T/r32_Release_v4.4/RPi_IMX477_Support_Nano_2GB.tbz2?CnqRTI0QNKTZHZupa-KIZWdtLNvuRCfrWlMQC6M1EEeRdUs6uZcl812IBb-p9A88gKeBOgO1eW_2t7SQxJ3BQDT58AYnB0ftSydlKrUPDj0uFC9pY5Lb1QnXSMgpewO90zEgj0t9Mp_w4ZQPZhpqQbtYCW_ttSPB2Rcm_Xk&t=eyJscyI6ImdzZW8iLCJsc2QiOiJodHRwczpcL1wvd3d3Lmdvb2dsZS5jb21cLyIsIm5jaWQiOiJwYS1zcmNoLWdvb2ctMjQxNDAifQ
tar -xjf RPi_IMX477_Support_Nano_2GB.tbz2
cd imx477_support
sudo  cp bl_update_payload_imx219 /usr/sbin

'''
By default Jetson Nano 2GB Developer Kit supports Raspberry Pi V2 camera (IMX219). To work with Raspberry Pi High Definition Camera (IMX477) connected to Jetson Nano 2GB Developer Kit, please follow the steps below:

NOTE: Once the below steps are executed, only IMX477 would work with the developer kit. To go back to working with Raspberry Pi V2 camera (IMX219), please refer to the next section below.

1. Copy bl_update_payload_imx477 from the downloaded tar file to /usr/sbin on the developer kit
Run the following commands -
2. cd /usr/sbin
3. sudo dpkg-reconfigure nvidia-l4t-bootloader
4. sudo l4t_payload_updater_t210 bl_update_payload_imx477
5. Copy libnvodm_imager.so included in the tar on to the Jetson developer kit to the path shown below.
   -    sudo cp libnvodm_imager.so /usr/lib/aarch64-linux-gnu/tegra/libnvodm_imager.so
6. Reboot the device

NOTE: When working with IMX 477 camera, orientation of the preview can be rotated by 180 degrees. To rotate the camera preview, please refer to the section "Video Rotation with GStreamer-1.0"  in Jetson Developer Guide (https://docs.nvidia.com/jetson/l4t/index.html) under "Accelerated GStreamer" section.

To go back to working with Raspberry Pi V2 camera (IMX219) connected to Jetson Nano 2GB Developer Kit, please follow below steps:
NOTE: Once the below steps are executed, only IMX219 would work with the developer kit.

1. Copy bl_update_payload_imx219 from the downloaded tar file to /usr/sbin on the developer kit
Run the following commands -
2. cd /usr/sbin
3. sudo dpkg-reconfigure nvidia-l4t-bootloader
4. sudo l4t_payload_updater_t210 bl_update_payload_imx219
5. reboot the device

To use the customized dtb and generate the payload itself for IMX477, you will need access to a x86 host. On the host
1. cd Linux_for_tegra
2. sudo ./l4t_generate_soc_bup.sh t21x
3. cp bootloader/payload_t21x/bl_update_payload bootloader/payload_t21x/bl_update_payload_imx219
4. copy IMX477's dtb from the tar file (tegra210-p3448-0003-p3542-0000.dtb) to Linux_for_Tegra/kernel/dtb
5. cd Linux_for_tegra
6. sudo ./l4t_generate_soc_bup.sh t21x
7. cp bootloader/payload_t21x/bl_update_payload bootloader/payload_t21x/bl_update_payload_imx477
8. copy bl_update_payload_imx219 and bl_update_payload_imx477 to device /usr/sbin.
On the target
9. cd /usr/sbin
10. sudo l4t_payload_updater_t210 bl_update_payload_imx477
11. Copy libnvodm_imager.so included in the tar on to the Jetson developer kit at the path shown below.
   -    sudo cp libnvodm_imager.so /usr/lib/aarch64-linux-gnu/tegra/
12. reboot the device
''''

# 查看摄像头
nvgstcapture-1.0 --orientation=4

https://forums.developer.nvidia.com/t/rpi-v2-csi-camera-freezes-with-jetson-nano-2gb/159173/8



# code server
wget  https://code-server.dev/install.sh
sudo chmod +x ./install.sh
./install.sh --method=standalone --prefix=/usr/local

sudo systemctl enable --now code-server@$USER

# 设置开机自动登录
sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
sudo sed -i 's/#  AutomaticLoginEnable = true/AutomaticLoginEnable = true/g'  /etc/gdm3/custom.conf
sudo sed -i  's/#  AutomaticLogin = user1/AutomaticLogin = nano/g'  /etc/gdm3/custom.conf
# Server 自动登录
sudo systemctl edit getty@tty1
# 输入这些配置
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noissue --autologin myusername %I $TERM
Type=idle

# Vs code server docker 
mkdir -p ~/.config
docker run -it  --privileged --name code-server -p 127.0.0.1:8080:8080 \
  -v "$HOME/.config:/home/coder/.config" \
  -v "$PWD:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest

apt install -y net-tools openssl
sed -i 's/bind-addr: 127.0.0.1:8080/bind-addr: 192.168.31.19:8080/g'  ~/.config/code-server/config.yaml
sed -i 's/password: 2ac13bd1bf08d80d8dd47a61/password: dlinano/g'  ~/.config/code-server/config.yaml

capture_device = traitlets.Integer(default_value=0)
capture_fps = traitlets.Integer(default_value=30)
capture_width = traitlets.Integer(default_value=640)
capture_height = traitlets.Integer(default_value=480)
capture_fps=24
camera = CSICamera(width=224, height=224, capture_device=0, capture_width=640, capture_height=480, capture_fps=24) # confirm the capture_device number

from jetcam.csi_camera import CSICamera

camera = CSICamera(width=224, height=224, capture_width=1280, capture_height=720, capture_fps=24)

gst-launch-1.0 nvarguscamerasrc sensor_id=0 ! nvoverlaysink

-v /var/log/jupyter.log:/var/log/jupyter.log 
指定python版本
#!/usr/bin/python3 
sudo docker run --runtime nvidia -it --rm --network host --volume ~/nvdli-data:/nvdli-nano/data --volume /tmp/argus_socket:/tmp/argus_socket --memory=500M --memory-swap=8G --device /dev/video0 nvcr.io/nvidia/dli/dli-nano-ai:v2.0.1-r32.4.4

设置摄像头
sudo apt-get update
sudo apt-get install -y v4l-utils
v4l2-ctl -d /dev/video0 --set-fmt-video=width=640,height=480,pixelformat=RG10 --set-ctrl bypass_mode=0 --stream-mmap --stream-count=50
camera = CSICamera(width=224, height=224, capture_device=0, capture_width=640, capture_height=480,  display_width=640, display_height=480, capture_fps=24) 

# 教程
# Check device camera
!ls -ltrh /dev/video*
!apt-get update
!apt-get install -y v4l-utils
!v4l2-ctl -d /dev/video0 --set-fmt-video=width=640,height=480,pixelformat=RG10 --set-ctrl bypass_mode=0 --stream-mmap --stream-count=50

# Init camera
# from jetcam.usb_camera import USBCamera
from jetcam.csi_camera import CSICamera
camera = CSICamera(width=224, height=224, capture_device=0, capture_width=640, capture_height=480,  display_width=640, display_height=480, capture_fps=24) 
camera.running = True
print("camera created")

v4l2src device=/dev/video0  ! image/jpeg, width=640, height=480, framerate=30/1 ! ..

self.capture_device, self.capture_width, self.capture_height, self.capture_fps,

# Install padman 
# apt-get install software-properties-common -y
# add-apt-repository -y ppa:projectatomic/ppa
apt-get install podman -y
podman info
echo -e "[registries.search]\nregistries = ['docker.io']" | sudo tee /etc/containers/registries.conf
podman run hello-world