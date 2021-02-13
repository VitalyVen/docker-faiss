FROM nvidia/cuda:11.1.1-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
    libopenblas-dev \
    python3 \
    python3-dev \
    python3-pip \
    swig \
    git \
    wget \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install --isolated --no-input --compile --exists-action=a --disable-pip-version-check --no-cache-dir matplotlib numpy
WORKDIR /opt

RUN python3 -c "import distutils.sysconfig; print(distutils.sysconfig.get_python_inc())"
RUN python3 -c "import numpy ; print(numpy.get_include())"
RUN git clone --depth=1 https://github.com/facebookresearch/faiss .

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main'
RUN apt update
RUN apt install cmake -y
RUN apt install build-essential -y

RUN cmake -DCUDAToolkit_ROOT=/usr/local/cuda-11.1/ -B build .
RUN make -C build