#### 1. seach all python versions
conda search python
conda search --full-name python

#### 2. list installed python env
conda env list
conda info --envs

#### 3. create a env with specified python version
conda create --name python3.7.9 python=3.7.9

#### 4. activate target python env
conda activate python3.7.9

python --version
