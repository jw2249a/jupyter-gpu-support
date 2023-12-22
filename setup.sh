#!/usr/bin/env bash
IMAGE_NAME="jupyter-gpu"
VERSION="0.0.1"

UBUNTU_VERSION="22.04"
UBUNTU_NAME="jammy"
CONTAINER_USER="jupu"

# Construct useful var names
CONTAINER_HOME="/home/${CONTAINER_USER}"
DESIRED_PLATFORM="linux/amd64"

# Build Docker images
#rocm
LATEST="${IMAGE_NAME}:latest"
VERSION="0.0.1"
FULL_TAG="${IMAGE_NAME}:${VERSION}"
docker build \
       --progress=plain \
       -t "${FULL_TAG}" rocm \
       --platform="${DESIRED_PLATFORM}" \
       --build-arg ROOT_CONTAINER="ubuntu:${UBUNTU_VERSION}" \
       --build-arg UBUNTU_NAME="${UBUNTU_NAME}"
docker tag  "${FULL_TAG}" "${LATEST}"
# Echo the built image tag
echo "Built image: ${FULL_TAG} for rocm"

#jupyter-init
VERSION="0.0.2"
LAST_TAG=${FULL_TAG}
FULL_TAG="${IMAGE_NAME}:${VERSION}"
docker build \
       --progress=plain \
       -t "${FULL_TAG}" docker-stacks-foundation \
       --platform="${DESIRED_PLATFORM}" \
       --build-arg ROOT_CONTAINER=${LAST_TAG} \
       --build-arg NB_USER="${CONTAINER_USER}" 
docker tag "${FULL_TAG}" "${LATEST}"

# Echo the built image tag
echo "Built image: ${FULL_TAG} for jupyter-init"

VERSION="0.0.3"
LAST_TAG=${FULL_TAG}
FULL_TAG="${IMAGE_NAME}:${VERSION}"
#jupyter-base
docker build \
       --progress=plain \
       -t "${FULL_TAG}" base-notebook \
       --build-arg ROOT_CONTAINER=${LAST_TAG} \
       --platform="${DESIRED_PLATFORM}" 
docker tag "${FULL_TAG}" "${LATEST}"
# Echo the built image tag
echo "Built image: ${FULL_TAG} for base-notebook"

VERSION="0.0.4"
LAST_TAG=${FULL_TAG}
FULL_TAG="${IMAGE_NAME}:${VERSION}"
#jupyter-minimal
docker build \
       --progress=plain \
       -t "${FULL_TAG}" minimal-notebook \
       --build-arg ROOT_CONTAINER=${LAST_TAG} \
       --platform="${DESIRED_PLATFORM}" 
docker tag "${FULL_TAG}" "${LATEST}"
# Echo the built image tag
echo "Built image: ${FULL_TAG} for minimal-notebook"

VERSION="0.0.5"
LAST_TAG=${FULL_TAG}
FULL_TAG="${IMAGE_NAME}:${VERSION}"
#jupyter-scipy
docker build \
       --progress=plain \
       -t "${FULL_TAG}" scipy-notebook \
       --build-arg ROOT_CONTAINER=${LAST_TAG} \
       --platform="${DESIRED_PLATFORM}"
docker tag "${FULL_TAG}" "${LATEST}"
# Echo the built image tag
echo "Built image: ${FULL_TAG} for scipy-notebook"


VERSION="0.0.6"
LAST_TAG=${FULL_TAG}
FULL_TAG="${IMAGE_NAME}:${VERSION}"
#jupyter-scipy
docker build \
       --progress=plain \
       -t "${FULL_TAG}" datascience-notebook \
       --build-arg ROOT_CONTAINER=${LAST_TAG} \
       --platform="${DESIRED_PLATFORM}" 
docker tag "${FULL_TAG}" "${LATEST}"
# Echo the built image tag
echo "Built image: ${FULL_TAG} for scipy-notebook"

#finish
echo "FINISHED! Built image: ${FULL_TAG}"

