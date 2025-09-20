#!/bin/bash

source ~/.bashrc

# Create directory
mkdir -p channel-artifacts

./start-evoting-network.sh --regenerate

# Set environment  
export FABRIC_CFG_PATH=$(pwd)/config

# Generate anchor peer transaction files
configtxgen -profile MultiOrgChannel -outputAnchorPeersUpdate ./channel-artifacts/ElectionCommissionMSPanchors.tx -channelID evotingchannel -asOrg ElectionCommissionMSP

configtxgen -profile MultiOrgChannel -outputAnchorPeersUpdate ./channel-artifacts/PoliticalPartyMSPanchors.tx -channelID evotingchannel -asOrg PoliticalPartyMSP  

configtxgen -profile MultiOrgChannel -outputAnchorPeersUpdate ./channel-artifacts/AuditAuthorityMSPanchors.tx -channelID evotingchannel -asOrg AuditAuthorityMSP

ls -la channel-artifacts/

# Check if gossip errors are gone
docker logs --tail 10 peer0.audit.example.com | grep -i "context deadline\|error"

# Set environment for EC peer
export CORE_PEER_LOCALMSPID="ElectionCommissionMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

# Create channel
peer channel create -o localhost:7050 -c evotingchannel -f evoting-channel.tx \
  --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Join EC peer to channel  
peer channel join -b evotingchannel.block

# Package chaincode
peer lifecycle chaincode package evoting.tar.gz --path ./chaincode --lang golang --label evoting_1.0

# Install on EC peer
peer lifecycle chaincode install evoting.tar.gz

# Get package ID
peer lifecycle chaincode queryinstalled

# Approve chaincode (replace PACKAGE_ID with actual ID)
peer lifecycle chaincode approveformyorg -o localhost:7050 --channelID evotingchannel --name evoting --version 1.0 --package-id PACKAGE_ID --sequence 1 --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Create an election
peer chaincode invoke -o localhost:7050 --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C evotingchannel -n evoting --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt -c '{"function":"CreateElection","Args":["election2025","Presidential Election 2025","Candidate1,Candidate2,Candidate3","1234567890","1234567999"]}'

# Cast a vote
peer chaincode invoke -o localhost:7050 --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C evotingchannel -n evoting --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt -c '{"function":"CastVote","Args":["election2025","voter123","Candidate1"]}'

# Query election results  
peer chaincode query -C evotingchannel -n evoting -c '{"function":"GetElection","Args":["election2025"]}'

# Test network health
docker logs peer0.audit.example.com | grep -i "membership.*online\|connected" | tail -3

# If you see "Membership view changed" and "Connected" messages, your network is healthy!
