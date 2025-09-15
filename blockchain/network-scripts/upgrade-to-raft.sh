#!/bin/bash

echo "==> Upgrading to Raft Consensus..."

cd ~/eVoting/blockchain

# Stop current network
./network-scripts/stop-network.sh

# Start all containers (3 orderers + 6 peers + 3 CAs)
docker-compose -f docker-compose/docker-compose-raft.yaml up -d

# Wait for startup
sleep 30

# Verify all 12 containers are running
echo "==> Verifying all containers are running with 'docker ps'..."
docker ps

echo "==> verifiying all containers are running with 'docker ps -a'..."
docker ps -a

# Check Raft consensus is working
docker logs orderer1.example.com | grep -i "raft\|leader"

echo "==> Raft consensus network started!"