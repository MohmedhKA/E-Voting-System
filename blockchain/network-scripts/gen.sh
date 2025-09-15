#!/bin/bash

# Generate crypto material
cryptogen generate --config=config/crypto-config-multi.yaml --output=crypto-config

# IMMEDIATELY generate genesis block (ensures certificate sync)
configtxgen -profile MultiOrgRaftGenesis -outputBlock genesis.block -channelID system-channel

# Generate channel transaction
configtxgen -profile MultiOrgChannel -outputCreateChannelTx evoting-channel.tx -channelID evotingchannel

# Verify both exist
ls -la genesis.block crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/signcerts/

