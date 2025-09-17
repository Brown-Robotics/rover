#!/usr/bin/env bash

set -e

DOCKER_REPOSITORY="osr-rover"
DOCKER_TAG="latest"
DOCKER_IMAGE="${DOCKER_REPOSITORY}:${DOCKER_TAG}"
CURRENT_DIR="$(pwd)"
ROS_WS_PATH="/osr_ws/src/osr-rover-code"

if docker ps -a --format '{{.Names}}' | grep -q "^${DOCKER_REPOSITORY}$"; then
  if [ "$1" != "--force" ]; then
    echo "Container is already running."
    echo "Run with --force to restart it."
    exit 1
  else
    echo "Removing existing container..."
    docker stop "${DOCKER_REPOSITORY}" || true
    docker rm "${DOCKER_REPOSITORY}" || true
  fi
fi

docker run -it --privileged -d \
  --env RCUTILS_COLORIZED_OUTPUT=1 \
  --volume "${CURRENT_DIR}:${ROS_WS_PATH}:rw" \
  --volume /dev/bus/usb:/dev/bus/usb \
  --name "${DOCKER_REPOSITORY}" \
  --network host \
  --device /dev/dri \
  "${DOCKER_IMAGE}" bash