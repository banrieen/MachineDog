# DockerName: Locust runner
# Usecase: With locust runtime dependentance tools and testsuites
# Update: 2021-03-30
# Dependents:  python3
# Arch: x86-64
# Version: v0.5.0
# Editor：thomas
# Build In China

FROM  mltooling/ml-workspace:0.12.1
ENV PYTHON_HOME  /usr/bin/python3

WORKDIR /home/

# 同步测试库和工具
COPY docker-build/go1.16.2.linux-amd64.tar.gz  .

RUN sudo cp -a /etc/apt/sources.list /etc/apt/sources.list.bak  \
    && sudo sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list  \
    && sudo sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list  \
    && apt update    \  
    && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz  \
    && export PATH=$PATH:/usr/local/go/bin   \
    && go env -w GOPROXY=https://goproxy.cn,direct  \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py  \
    && pip config set global.index-url https://repo.huaweicloud.com/repository/pypi/simple   \
    && pip config set install.trusted-host https://repo.huaweicloud.com  \
    && pip install python-dev-tools  \
    && git clone -b master https://haiyuan.bian:apulis18c@apulis-gitlab.apulis.cn/apulis/MachineWolf.git   \
    && cd /home/MachineWolf/  \
    && git pull origin master  \
    && pip install -U --ignore-installed -r /home/MachineWolf/requirements.ini \ 
    && bzt /home/MachineWolf/example/jmeter/trace_user_footprint.jmx  \
    && rm -rf /tmp/* 

# port
# EXPOSE 1099 8080 8088 8089

# Build  example
# docker build -f MachineWolf/Dockerfile .  -t  harbor.apulis.cn:8443/testops/machinewolf:latest
# docker push harbor.apulis.cn:8443/testops/machinewolf:latest
# Run example
# docker run -d --name MachineWolf-jupyter -p 8088:8080  harbor.apulis.cn:8443/testops/machinewolf:latest
