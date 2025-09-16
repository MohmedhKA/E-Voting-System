#!/bin/bash
# Clear any existing variables
unset CORE_PEER_MSPCONFIGPATH CORE_PEER_TLS_ROOTCERT_FILE CORE_PEER_ADDRESS CORE_PEER_LOCALMSPID

# Set Election Commission Admin environment
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID=ElectionCommissionMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
export CORE_PEER_ADDRESS=peer0.ec.example.com:7051

echo "✅ Environment set for Election Commission Admin"
echo "CORE_PEER_LOCALMSPID: $CORE_PEER_LOCALMSPID"
echo "CORE_PEER_MSPCONFIGPATH: $CORE_PEER_MSPCONFIGPATH"
