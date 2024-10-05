from nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04          

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    bzip2 \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    build-essential \
    cmake \
    python3-dev \
    python3-pip \
    python3-setuptools \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip    
RUN pip3 install --upgrade setuptools            
RUN pip3 install --upgrade wheel

