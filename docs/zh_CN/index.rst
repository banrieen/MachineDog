.. MachineWolf documentation master file, created by
   sphinx-quickstart on Sun Mar 28 23:34:35 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to MachineWolf's documentation!
=======================================

**MachineWolf** 是一个自动化测试性能套件，促进 AiOps 实施。

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
