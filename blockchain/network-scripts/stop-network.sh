#!/bin/bash

# Paths
DOCKER_COMPOSE_PATH=$(dirname "$0")/../docker-compose
CONFIG_PATH=$(dirname "$0")/../config

echo "====> 1. Stopping Docker containers..."
docker-compose -f $DOCKER_COMPOSE_PATH/docker-compose.yaml down --volumes --remove-orphans

echo "====> 2. Removing Docker networks..."
docker network ls --filter name=fabric --format "{{.ID}}" | xargs -r docker network rm 2>/dev/null || true

echo "====> 3. Cleaning up files..."
sudo rm -rf $CONFIG_PATH/crypto-config
sudo rm -f $CONFIG_PATH/genesis.block $CONFIG_PATH/mychannel.tx $CONFIG_PATH/mychannel.block

echo "====> 4. Pruning Docker system..."
docker system prune -f

echo "====> 5. Cleaning up wallets..."
# Since you have a fabricService.js, also clean up the wallet directory
if [ -d "../backend/wallet" ]; then
    rm -rf ../backend/wallet/*
fi

echo "Network shutdown complete!"