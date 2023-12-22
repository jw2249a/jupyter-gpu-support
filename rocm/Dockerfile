# This dockerfile is meant to serve as a rocm base image.  It registers the debian rocm package repository, and
# installs the rocm-dev package.
# args
ARG ROOT_CONTAINER
FROM nvidia/cuda:12.1.1-base-ubuntu22.04
ARG UBUNTU_NAME

LABEL maintainer="Jack R. Williams <contact@jackryanwilliams.com"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root
RUN echo "Package: *\nPin: release o=repo.radeon.com\nPin-Priority: 600" > /etc/apt/preferences.d/rocm-pin-600

# initialize
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    wget

# install rocm 
RUN apt update && \
    wget "https://repo.radeon.com/amdgpu-install/5.7.1/ubuntu/${UBUNTU_NAME}/amdgpu-install_5.7.50701-1_all.deb" && \
    apt install -y ./amdgpu-install_5.7.50701-1_all.deb

RUN echo "Y" | amdgpu-install --usecase=rocm --no-dkms --no-32 --accept-eula

# install initial packages and set locale
RUN apt-get install -y --no-install-recommends \
    bzip2 \
    build-essential \
    file \
    kmod \
    libelf1 \
    libnuma-dev \
    locales\
    python3 \
    python3-pip \
    sudo \
    tini && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# create render group and ensure new users are added to it
RUN groupadd -g 109 render && \
    echo 'ADD_EXTRA_GROUPS=1' >> /etc/adduser.conf && \
    echo 'EXTRA_GROUPS=video' >> sudo tee -a /etc/adduser.conf && \
    echo 'EXTRA_GROUPS=render' >> sudo tee -a /etc/adduser.conf


