FROM pytorch/pytorch:2.7.0-cuda12.6-cudnn9-devel

ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_CACHE_DIR=1
ENV MAX_JOBS=4

WORKDIR /workspace

# Basic build tools required by FlashAttention and other CUDA extensions
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

COPY requirements_docker.txt /tmp/requirements_docker.txt

RUN python -m pip install --upgrade pip setuptools wheel

RUN python -m pip install -r /tmp/requirements_docker.txt

RUN python -m pip install flash-attn==2.6.3 --no-build-isolation

# Required by the current GuideX model instructions
RUN python -m pip install \
    "git+https://github.com/HazyResearch/flash-attention.git#subdirectory=csrc/rotary"

RUN python -m pip install \
    jupyterlab \
    ipykernel

RUN python -m ipykernel install \
    --sys-prefix \
    --name guidex \
    --display-name "Python (GuideX)"

CMD ["bash"]