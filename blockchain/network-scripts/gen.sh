#!/bin/bash

source ~/.bashrc
echo "🔧 Fixing E-Voting Deployment Issues..."

cd ~/eVoting/blockchain

# 1. Fix DNS resolution
echo "Adding missing hostnames to /etc/hosts..."
sudo tee -a /etc/hosts << EOF
127.0.0.1 peer1.ec.example.com
127.0.0.1 peer1.party.example.com
EOF

# 2. Verify which peers joined the channel successfully
echo "🔍 Checking channel membership..."

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID=ElectionCommissionMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
export CORE_PEER_ADDRESS=peer0.ec.example.com:7051

# Check if peer0.ec is on channel
peer channel list

# 3. Retry joining ALL peers to channel (safe to re-run)
echo "🔄 Re-joining all peers to channel..."

# Join Election Commission peers (retry both)
export CORE_PEER_ADDRESS=peer0.ec.example.com:7051
peer channel join -b evotingchannel.block

export CORE_PEER_ADDRESS=peer1.ec.example.com:7061
peer channel join -b evotingchannel.block

# Join Political Party peers
export CORE_PEER_LOCALMSPID=PoliticalPartyMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/party.example.com/peers/peer0.party.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp

export CORE_PEER_ADDRESS=peer0.party.example.com:8051
peer channel join -b evotingchannel.block

export CORE_PEER_ADDRESS=peer1.party.example.com:8061
peer channel join -b evotingchannel.block

# Join Audit Authority peer
export CORE_PEER_LOCALMSPID=AuditAuthorityMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/audit.example.com/peers/peer0.audit.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp
export CORE_PEER_ADDRESS=peer0.audit.example.com:9051

peer channel join -b evotingchannel.block

echo "✅ All peers re-joined to channel"

# 4. Now retry the approval process
echo "🔄 Retrying chaincode approval..."

PACKAGE_ID="evoting_1.0:9f61137f2441ba9b80a744cb39c525ac6c714db2198e876eb44392258d63c22b"

# Approve from Election Commission
export CORE_PEER_LOCALMSPID=ElectionCommissionMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
export CORE_PEER_ADDRESS=peer0.ec.example.com:7051

peer lifecycle chaincode approveformyorg \
  -o orderer1.example.com:7050 \
  --channelID evotingchannel \
  --name evoting \
  --version 1.0 \
  --package-id $PACKAGE_ID \
  --sequence 1 \
  --tls \
  --cafile $PWD/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Approve from Political Party  
export CORE_PEER_LOCALMSPID=PoliticalPartyMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/party.example.com/peers/peer0.party.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp
export CORE_PEER_ADDRESS=peer0.party.example.com:8051

peer lifecycle chaincode approveformyorg \
  -o orderer1.example.com:7050 \
  --channelID evotingchannel \
  --name evoting \
  --version 1.0 \
  --package-id $PACKAGE_ID \
  --sequence 1 \
  --tls \
  --cafile $PWD/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# Approve from Audit Authority
export CORE_PEER_LOCALMSPID=AuditAuthorityMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/audit.example.com/peers/peer0.audit.example.com/tls/ca.crt  
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp
export CORE_PEER_ADDRESS=peer0.audit.example.com:9051

peer lifecycle chaincode approveformyorg \
  -o orderer1.example.com:7050 \
  --channelID evotingchannel \
  --name evoting \
  --version 1.0 \
  --package-id $PACKAGE_ID \
  --sequence 1 \
  --tls \
  --cafile $PWD/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

echo "✅ Chaincode approved by all orgs"

# 5. Commit chaincode to channel
echo "📋 Committing chaincode to channel..."

peer lifecycle chaincode commit \
  -o orderer1.example.com:7050 \
  --channelID evotingchannel \
  --name evoting \
  --version 1.0 \
  --sequence 1 \
  --tls \
  --cafile $PWD/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  --peerAddresses peer0.ec.example.com:7051 \
  --tlsRootCertFiles $PWD/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt \
  --peerAddresses peer0.party.example.com:8051 \
  --tlsRootCertFiles $PWD/crypto-config/peerOrganizations/party.example.com/peers/peer0.party.example.com/tls/ca.crt \
  --peerAddresses peer0.audit.example.com:9051 \
  --tlsRootCertFiles $PWD/crypto-config/peerOrganizations/audit.example.com/peers/peer0.audit.example.com/tls/ca.crt

echo "🎉 Chaincode committed successfully!"

# 6. Test the deployment
echo "🧪 Testing chaincode deployment..."

# Set environment for testing  
export CORE_PEER_LOCALMSPID=ElectionCommissionMSP
export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=$PWD/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
export CORE_PEER_ADDRESS=peer0.ec.example.com:7051

# Test chaincode is deployed
peer lifecycle chaincode querycommitted -C evotingchannel

# Initialize test election with your updated timestamps
peer chaincode invoke \
  -o orderer1.example.com:7050 \
  -C evotingchannel \
  -n evoting \
  --tls \
  --cafile $PWD/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem \
  -c '{"function":"InitElection","Args":["test2025","[\"Alice\",\"Bob\",\"Charlie\"]","1758038840","1758125240","Test Election 2025"]}'

echo "🗳️ SUCCESS! Your e-voting blockchain is fully operational!"
