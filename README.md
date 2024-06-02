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


