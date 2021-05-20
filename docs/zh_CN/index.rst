.. MachineWolf documentation master file, created by
   sphinx-quickstart on Sun Mar 28 23:34:35 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to MachineWolf's documentation!
=======================================

**MachineWolf** 是一个自动化测试性能套件，促进 AiOps 实施。

快速使用指导
----------------

* 在本地执行测试脚本

    ```bash
    sudo chmod +x init_dev.sh
    bash ./init_dev.sh
    locust -f ./example/locust/test_http.py --conf ./example/locust/host.conf
    ```

* 在docker环境中执行testsuites

    1. 拉取已经编译好的镜像
    
    `docker pull banrieen/machinewolf`

    2. 执行docker
    
    ```bash
    docker run -d     -p 8088:8080  -p 8090:8090  --name "ml-workspace"  -v "${PWD}:/workspace"  --env NOTEBOOK_ARGS="--NotebookApp.notebook_dir=/home"  --shm-size 2048m  --restart always     banrieen/machinewolf:latest
    # 打开jupyterlab
    # http://<xxx.xxx.xxx.xxx>:8088 
    ```

* 使用taurus执行locust脚本

    `bzt example/taurus/quick_test.yml`

* 使用taurus执行jmeter脚本

    `bzt example/jmeter/trace_user_footprint.jmx`

* 使用taurus执行纯yaml脚本

    `bzt example/taurus/quick_test.yml`

* 使用pytest执行非接口类的脚本，比如ha,吞吐量测试集等

    `pytest example/pytest/test_ha.py`

测试套件
----------------

-  ops： 自动构建
-  aisetshub: 模型验证相关
-  datasetshub: 数据集验证相关
-  testhub: 平台、组件测试案例和脚本
-  issuesboard: 同步issues和report

测试集结构
-----------------

* 首先设计测试方案
* 新建分支或tag，增加产品/项目测试脚本集
* 补充或更新lib

.. code:: bash

   |-- testhub/
       `-- testscheme
       `-- testsuites
           |-- e2e
           |-- ha
       `-- testlib
           |-- fake_users
           |-- postgres_client
           |-- csv_client



.. toctree::
   :glob:
   :maxdepth: 2
   :caption: 目录:
   
   quickly_start

   design/*
   install/*
   tools/*



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
