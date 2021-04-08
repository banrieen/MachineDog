.. MachineWolf documentation master file, created by
   sphinx-quickstart on Sun Mar 28 23:34:35 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to MachineWolf's documentation!
=======================================

**MachineWolf** 是一个自动化测试性能套件，促进 AiOps 实施。

测试套件
----------------

-  aisetshub: 模型验证相关
-  datasetshub: 数据集验证相关
-  testhub: 平台、组件测试案例和脚本
-  issuesboard: 同步issues和report

测试集结构
-----------------

测试套件本着兼容并蓄，容纳萃取的宗旨，独立灵活的组织测试套件。支持各种前沿的、优秀的工具和理念；目前将测试方案（testscheme）、数据(datas.yaml)、脚本(.py,.jmx)、执行计划（host.yml,taurus.yml）灵活的组织在一起。
目前还是一些样例，还需要完善和补充。

.. code:: bash

   |-- testhub/
       `-- testscheme
           |-- 5g_manufacturing
           |-- annotations_cvat
       `-- testsuites
           |-- annotations_cvat
               |-- host.conf
               |-- test_cvat_suites.py
               |-- datas.yaml
           |-- dlws
           |-- e2e_aiarts
           |-- ha_aiarts
           |-- jobmanager
           |-- songshanhu
       `-- testlib
           |-- fake_users
           |-- postgres_client
           |-- csv_client

版本发布
---------------

-  **Latest**

   1. 完整的套件架构
   2. 安装和环境准备
   3. 执行示例
   4. 基础测试用例集

-  **规划**

   1. 补充和完善测试脚本
   2. 调通禅道与测试套件的同步过程调通禅道与测试套件的同步过程
   3. 调通argo与测试套件的同步过程
   4. 补充框架、模型性能工具和脚本
   5. 融合k8s中监控


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
