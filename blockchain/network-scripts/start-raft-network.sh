#!/bin/bash

echo "==> Upgrading to Raft Consensus..."

# Stop current network
./network-scripts/stop-network.sh

# Generate new crypto material for multi-org
cryptogen generate --config=config/crypto-config-multi.yaml --output=config/crypto-config

# Generate genesis block with Raft
configtxgen -profile MultiOrgRaftGenesis -outputBlock config/genesis-raft.block -channelID system-channel

# Start multi-orderer network
docker-compose -f docker-compose/docker-compose-raft.yaml up -d

echo "==> Raft consensus network started!"
docker ps