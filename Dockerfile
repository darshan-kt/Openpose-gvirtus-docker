# Base image with CUDA and cuDNN 8.9.7 support
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu20.04

# Set noninteractive mode for apt
ENV DEBIAN_FRONTEND=noninteractive
ENV GVIRTUS_HOME=/home/GVirtuS

# Install essential packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    unzip \
    libopencv-dev \
    libopenblas-dev \
    libatlas-base-dev \
    libboost-all-dev \
    libhdf5-dev \
    libprotobuf-dev \
    protobuf-compiler \
    python3-dev \
    python3-pip \
    libgflags-dev \
    libgoogle-glog-dev \
    libgphoto2-dev \
    liblmdb-dev \
    libgtk2.0-dev \
    libjsoncpp-dev \
    libssl-dev \
    libtbb-dev \
    libtiff-dev \
    rdma-core \ 
    librdmacm-dev \ 
    libibverbs-dev \
    && apt-get clean

# Install Python packages
RUN pip3 install numpy opencv-python

# Set working directory
WORKDIR /home

#install cmake3.17
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libssl-dev \
    && apt-get purge -y cmake \
    && apt-get clean \
    && wget https://cmake.org/files/v3.17/cmake-3.17.1-Linux-x86_64.tar.gz \
    && tar zxvf cmake-3.17.1-Linux-x86_64.tar.gz \
    && rm -f cmake-3.17.1-Linux-x86_64.tar.gz \
    && mv cmake-3.17.1-Linux-x86_64 /opt/cmake-3.17.1 \
    && ln -sf /opt/cmake-3.17.1/bin/* /usr/bin/ 

# Set working directory
WORKDIR /home

# Clone OpenPose repository
RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose.git

# Build OpenPose
WORKDIR /home/openpose
RUN git submodule update --init --recursive && \
    mkdir build && cd build && \
    cmake -DBUILD_PYTHON=ON -DPYTHON_EXECUTABLE=$(which python3.8) -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so.1.0 .. && \
    make -j"$(nproc)"

# Set working directory
WORKDIR /home

# Clone OpenPose repository
RUN git clone -b gvirtus-cuda-12 https://github.com/ecn-aau/GVirtuS.git

# Build and install GVirtuS
RUN cd GVirtuS && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# Add GVirtuS binaries and libraries to PATH and LD_LIBRARY_PATH
ENV PATH="$GVIRTUS_HOME/bin:$PATH"
ENV LD_LIBRARY_PATH="$GVIRTUS_HOME/lib:$LD_LIBRARY_PATH"

# Expose port 8888 for TCP/IP communication
EXPOSE 8888

# Set entrypoint
WORKDIR /home
# CMD ["./build/examples/openpose/openpose.bin", "--help"]
