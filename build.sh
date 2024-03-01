#!/bin/bash

WORKERD_VERSION=$1

if [ -z "$WORKERD_VERSION" ]; then
    LATEST_VERSION=$(curl -s https://api.github.com/repos/cloudflare/workerd/releases/latest | jq -r .tag_name)
    echo "Using latest version: $LATEST_VERSION"
    WORKERD_VERSION=$LATEST_VERSION
fi

# build docker image for arm64 and amd64
docker buildx build --build-arg WORKERD_VERSION=$WORKERD_VERSION --platform linux/arm64,linux/amd64 -t jacoblincool/workerd:$WORKERD_VERSION -t jacoblincool/workerd:latest --push .
