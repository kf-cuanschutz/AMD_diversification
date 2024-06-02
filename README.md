# AMD_diversification
The scripts associated with this repository will allow you to adapt your pytorch GPU workflow on Alpine to AMD gpus.

Please follow the recommendation below in order to adapt your NVIDIA pytorch pipeline into AMD

ROCM adaptation steps on Alpine:
=========================================================

1) Access an AMD debug partition GPU partition on Alpine and clone the repository

```bash
sinteractive --partition=atesting_mi100 --qos=testing --time=01:00:00 --gres=gpu:1 --ntasks=6
cd /projects/$USER/software
git clone https://github.com/kf-cuanschutz/AMD_diversification.git
cd AMD_diversification
```

2) Make sure that you are included in  the video group. If that is not the case please email hpcsupport@cuanschutz.edu to get added

```bash
groups | grep video
```

3) Make the install script executable and run it

```bash
chmod +x install_file.sh
source install_file.sh
```

4) Verify that everything is working and that you have access to an AMD GPU with the following

```python
>>>import torch
>>>print(torch.cuda.is_available())
True
>>>import pandas as pd
>>>import scipy
>>>import plotly
>>>import numpy
>>>import transformers
>>>import sklearn
>>>import matplotlib
>>>import seaborn
```
5) Make sure to exact the GPU debug partition if you have nothing else to test
```python
exit
```

Horovod compatible installation on Alpine:
=========================================================

1) To install Horovod, simply run the following: 

```bash
sinteractive --partition=atesting_mi100 --qos=testing --time=01:00:00 --gres=gpu:1 --ntasks=6
chmod +x part2-install_horovod_amd_gpu.sh
source part2-install_horovod_amd_gpu.sh
exit
```

2) To test it you may use one of the example from [here](https://github.com/horovod/horovod/tree/master/examples/pytorch). For example to run Horovod on 2 GPUs on using the pytorch mnist example, one will run the following:
```bash
sinteractive --partition=atesting_mi100 --qos=testing --time=01:00:00 --gres=gpu:2 --ntasks=10
chmod +x part3-load_rocm+horovod_.sh
source part3-load_rocm+horovod_.sh
git clone https://github.com/horovod/horovod.git test-horovod
cd test-horovod/examples/pytorch
horovodrun -np 2 -H localhost:2 python pytorch_mnist.py
exit
```

For more information about Horovod in general please refer to our Horovod [workshop](https://github.com/kf-cuanschutz/CU-Anschutz-HPC-documentation/blob/main/Workshops/Introduction_to_Horovod_102423_part1_official_v2.pdf)
Finally, If you have any question, please email us at hpcsupport@cuanschutz.edu. 





