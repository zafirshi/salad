FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# 替换阿里源为ubuntu的软件源
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
# 替换浙大源为ubuntu的软件源
# RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.zju.edu.cn/ubuntu/|g' /etc/apt/sources.list && \
#     sed -i 's|http://security.ubuntu.com/ubuntu/|https://mirrors.zju.edu.cn/ubuntu/|g' /etc/apt/sources.list


# 安装依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    vim \
    nano \
    tmux \
    htop \
    pkg-config \
    python3-dev \
    python3-numpy \
    libtbb2 \
    libtbb-dev \
    libdc1394-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# 安装Miniconda
ENV MINICONDA_VERSION=py39_4.12.0
ENV CONDA_DIR=/opt/conda
RUN apt-get update && \
    # wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -b -p ${CONDA_DIR} && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh


# 将conda命令添加到环境变量中（但不激活任何环境）
ENV PATH=${CONDA_DIR}/bin:${PATH}

# 初始化Conda
RUN conda init bash

# 清理apt缓存以减小镜像大小
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 创建一个新用户，并切换到该用户
RUN useradd -m -s /bin/bash shize
USER shize

# 设置默认工作目录（可选）
WORKDIR /home/shize

# 设置默认的容器命令
CMD [ "/bin/bash" ]