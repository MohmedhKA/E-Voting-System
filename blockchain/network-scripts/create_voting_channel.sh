#!/bin/bash

source ~/.bashrc

 # Set environment
source set-peer-env.sh

# Create channel (should work now!)
peer channel create \
  -o orderer1.example.com:7050 \
  -c evotingchannel \
  -f evoting-channel.tx \
  --tls \
  --cafile $PWD/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem