# Copyright 2020 Huawei Technologies Co., Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
"""
######################## train lenet example ########################
train lenet and get network model files(.ckpt) :
python train.py --data_path /YourDataPath
"""

import os
import argparse
from src.config import mnist_cfg as cfg
from src.dataset import create_dataset
from src.lenet import LeNet5
import mindspore.nn as nn
from mindspore import context
from mindspore.train.callback import Callback, ModelCheckpoint, CheckpointConfig, LossMonitor, TimeMonitor
from mindspore.train import Model
from mindspore.nn.metrics import Accuracy
from mindspore.common import set_seed
import nni


parser = argparse.ArgumentParser(description='MindSpore Lenet Example')
parser.add_argument('--device_target', type=str, default="Ascend", choices=['Ascend', 'GPU', 'CPU'],
                    help='device where the code will be implemented (default: Ascend)')
parser.add_argument('--data_path', type=str, default="./Data",
                    help='path where the dataset is saved')
parser.add_argument('--ckpt_path', type=str, default="./ckpt", help='if is test, must provide\
                    path where the trained ckpt file')
parser.add_argument("--epoch_size", type=int, default=10)
parser.add_argument("--dropout_rate", type=float, default=0.5, help="dropout rate")
parser.add_argument("--channel_1_num", type=int, default=6)
parser.add_argument("--channel_2_num", type=int, default=16)
parser.add_argument("--conv_size", type=int, default=5)
parser.add_argument("--pool_size", type=int, default=2)
parser.add_argument("--hidden_size", type=int, default=120)
parser.add_argument("--learning_rate", type=float, default=0.01)
parser.add_argument("--batch_size", type=int, default=32)
parser.add_argument("--momentum", type=float, default=0.9)

args = parser.parse_args()
set_seed(1)


class EvalEpoch(Callback):
    def __init__(self, model, eval_dataset, iters_per_epoch):
        super(EvalEpoch, self).__init__()
        self.model = model
        self.eval_dataset = eval_dataset
        self.iters_per_epoch = iters_per_epoch

    def begin(self, run_context):
        cb_params = run_context.original_args()

    def step_end(self, run_context):
        cb_params = run_context.original_args()
        epoch_num = cb_params.cur_epoch_num
        step_num = cb_params.cur_step_num
        if step_num % self.iters_per_epoch == 0:
            acc = self.model.eval(self.eval_dataset)
            print("epoch_num: {}, result: {}".format(epoch_num, acc))
            if epoch_num < cfg.epoch_size:
                nni.report_intermediate_result(acc['Accuracy'])
            else:
                nni.report_final_result(acc['Accuracy'])


if __name__ == "__main__":
    # for nni
    tuner_params = nni.get_next_parameter()
    params = vars(args)
    params.update(tuner_params)

    cfg.epoch_size = args.epoch_size
    cfg.dropout_rate = args.dropout_rate
    cfg.channel_1_num = args.channel_1_num
    cfg.channel_2_num = args.channel_2_num
    cfg.conv_size = args.conv_size
    cfg.pool_size = args.pool_size
    cfg.hidden_size = args.hidden_size
    cfg.lr = args.learning_rate
    cfg.batch_size = args.batch_size
    cfg.momentum = args.momentum

    print(cfg)

    context.set_context(mode=context.GRAPH_MODE, device_target=args.device_target)
    ds_train = create_dataset(args.data_path, cfg.batch_size)
    if ds_train.get_dataset_size() == 0:
        raise ValueError("Please check dataset size > 0 and batch_size <= dataset size")

    network = LeNet5(dropout_rate = cfg.dropout_rate,
                     channel_1_num = cfg.channel_1_num,
                     channel_2_num = cfg.channel_2_num,
                     conv_size = cfg.conv_size,
                     hidden_size = cfg.hidden_size,
                     pool_size = cfg.pool_size,
                     num_class = cfg.num_classes)
    net_loss = nn.SoftmaxCrossEntropyWithLogits(sparse=True, reduction="mean")
    net_opt = nn.Momentum(network.trainable_params(), cfg.lr, cfg.momentum)
    time_cb = TimeMonitor(data_size=ds_train.get_dataset_size())
    config_ck = CheckpointConfig(save_checkpoint_steps=cfg.save_checkpoint_steps,
                                 keep_checkpoint_max=cfg.keep_checkpoint_max)
    ckpoint_cb = ModelCheckpoint(prefix="checkpoint_lenet", directory=args.ckpt_path, config=config_ck)

    if args.device_target != "Ascend":
        model = Model(network, net_loss, net_opt, metrics={"Accuracy": Accuracy()})
    else:
        model = Model(network, net_loss, net_opt, metrics={"Accuracy": Accuracy()}, amp_level="O2")

    step_size = ds_train.get_dataset_size()
    ds_eval = create_dataset(args.data_path, cfg.batch_size, 1)
    eval_epoch = EvalEpoch(model, ds_eval, step_size)

    print("============== Starting Training ==============")
    model.train(cfg['epoch_size'],
                ds_train,
                callbacks=[time_cb, ckpoint_cb, LossMonitor(), eval_epoch])
