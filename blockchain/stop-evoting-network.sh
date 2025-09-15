#!/bin/bash

# 🛑 E-Voting Network Stop Script

echo "🛑 Stopping E-Voting Blockchain Network..."

# Set paths
BLOCKCHAIN_DIR=$(pwd)
COMPOSE_FILE="$BLOCKCHAIN_DIR/docker-compose/docker-compose-raft.yaml"

# Stop all containers
echo "=====> Stopping Docker containers..."
docker-compose -f "$COMPOSE_FILE" down

# Clean up orphaned containers
echo "=====> Cleaning up containers..."
docker container prune -f

# Show final status
echo "=====> Final Status:"
docker ps --filter "name=orderer\|peer\|ca\."

echo "✅ E-Voting Network stopped successfully!"
