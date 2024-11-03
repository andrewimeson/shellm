#!/bin/bash

# Define variables for Docker image and container names
IMAGE_NAME="shellm"
DOCKERFILE_PATH="./docker/Dockerfile"

# Calculate checksum for Dockerfile content and use it as a tag for the image
DOCKERFILE_CHECKSUM=$(md5sum "$DOCKERFILE_PATH" | awk '{ print $1 }')
IMAGE_NAME="${IMAGE_NAME}:${DOCKERFILE_CHECKSUM}"

# Check if --watch flag is passed
WATCH_MODE=""
if [[ "$1" == "--watch" ]]; then
    WATCH_MODE="--watch"
fi

# Check if the image with the current checksum already exists
if [[ "$(docker images -q "$IMAGE_NAME" 2> /dev/null)" == "" ]]; then
    echo "Docker image with checksum $DOCKERFILE_CHECKSUM not found. Building image..."
    docker build -t "$IMAGE_NAME" -f "$DOCKERFILE_PATH" .

    # Check if build succeeded
    if [ $? -ne 0 ]; then
        echo "Docker build failed. Exiting."
        exit 1
    fi
else
    echo "Docker image $IMAGE_NAME already exists. Skipping build."
fi

# Run the container and execute the tests, with optional watch mode
echo "Running container and executing tests..."
docker run --rm -v "$(pwd)":/app --network=host "$IMAGE_NAME" $WATCH_MODE
