# NNI示例


## 介绍
- NNI (Neural Network Intelligence) 是一个工具包，可有效的帮助用户设计并调优机器学习模型的神经网络架构，复杂系统的参数（如超参）等。

- 本项目提供NNI针对不同框架的使用示例，如tensorflow，pytorch，mindspore等， 你可以参考这些示例来创建自己的训练。


## 目录

- mnist-pytorch：pytorch示例

- mnist-tfv1：tensorflow 1.x版本示例

- mnist-tfv2：tensorflow 2.x版本示例


## 基本使用

你可以使用以下的指令简单地运行一个训练：

``` bash
nnictl create -c config.yml -p 40000
```

或者使用`nnictl -h`来获取更多使用指引。


## 搜索空间

在 NNI 中，Tuner 会根据搜索空间来取样生成参数和网络架构。搜索空间通过JSON文件来定义。

搜索空间示例如下：

``` json
{
    "dropout_rate": {"_type": "uniform", "_value": [0.1, 0.5]},
    "conv_size": {"_type": "choice", "_value": [2, 3, 5, 7]},
    "hidden_size": {"_type": "choice", "_value": [124, 512, 1024]},
    "batch_size": {"_type": "choice", "_value": [50, 250, 500]},
    "learning_rate": {"_type": "uniform", "_value": [0.0001, 0.1]}
}
```

关于搜索空间的更多信息，请参考[NNI搜索空间](https://nni.readthedocs.io/zh/stable/Tutorial/SearchSpaceSpec.html "NNI搜索空间")。


## 配置

本项目使用不同的文件后缀来区分不同的设备，比如`CPU`使用`config-cpu.yml`，`GPU`使用`config-gpu.yml`，`NPU`使用`config-npu.yml`：

``` bash
nnictl create -c config-cpu.yml -p 40000 # using CPU
nnictl create -c config-gpu.yml -p 40000 # using GPU
nnictl create -c config-npu.yml -p 40000 # using NPU
```

关于配置的更多信息，请参考[NNI配置](https://nni.readthedocs.io/zh/stable/Tutorial/ExperimentConfig.html "NNI配置")。

**注意：** 由于需要支持NPU, 我们移除了原有的`gpuNum`字段，并添加了以下几个配置字段：

```
# 设备类型是一个可选字段，系统默认会使用集群中拥有的设备作为设备类型
# 如果集群中拥有多种设备（如GPU + NPU），则必须指定一种设备类型，否则，系统会默认使用集群第一个安装的设备
# 设备类型的值可能是nvidia_gpu_amd64，huawei_npu_arm64，可以在平台创建训练的页面中获得设备类型的值
deviceType: huawei_npu_arm64

# 使用设备的数量
deviceNum: 1

# 如果你需要使用NPU进行训练，必须提供框架类型，当前支持的框架有tensorflow，pytorch和mindspore
# 如果你不需要使用NPU，请指定框架类型为none
frameworkType: mindspore
```


## Web界面

NNI提供了`实验管理`的[Web界面](https://nni.readthedocs.io/zh/stable/Tutorial/WebUI.html "Web界面")， 你可以通过如http://localhost:40000 http://127.0.0.1:40000 等链接来访问[Web界面](https://nni.readthedocs.io/zh/stable/Tutorial/WebUI.html "Web界面")。

在`依瞳平台`中, 你可能需要使用`可交互端口`来访问[Web界面](https://nni.readthedocs.io/zh/stable/Tutorial/WebUI.html "Web界面")。

## FAQ

`ERROR: Failed! Error is: {"error":"Unexpected token u in JSON at position 0"}`

这个错误一般是由于无法正常获取平台信息导致的，可进行以下检查：

- 检查是否能正常访问配置文件(如config.yml)中dashboard指定的URI，可使用curl uri进行检查

- 检查配置文件(如config.yml)中cluster字段的值与安装的集群名称是否匹配