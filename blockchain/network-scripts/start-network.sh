#!/bin/bash
set -e

# Paths
BIN_PATH=$(dirname "$0")/../bin
CONFIG_PATH=$(dirname "$0")/../config
CHAINCODE_PATH=$(dirname "$0")/../chaincode/go/evoting
DOCKER_COMPOSE_PATH=$(dirname "$0")/../docker-compose

export PATH=$PATH:$BIN_PATH
export FABRIC_CFG_PATH=$CONFIG_PATH

CHANNEL_NAME="mychannel"
CC_NAME="evoting"
CC_VERSION="1.0"
CC_SEQUENCE=1

echo "====> 0. Cleaning up existing network"
# Stop and remove containers
docker-compose -f $DOCKER_COMPOSE_PATH/docker-compose.yaml down --volumes --remove-orphans

echo "====> Setting proper file permissions"
# Create crypto-config directory if it doesn't exist
mkdir -p $CONFIG_PATH/crypto-config || true
sudo chown -R $USER:$USER $CONFIG_PATH/crypto-config
sudo chmod -R 755 $CONFIG_PATH/crypto-config

# Remove all fabric networks
docker network ls --filter name=fabric --format "{{.ID}}" | xargs -r docker network rm 2>/dev/null || true
docker network ls --filter name=docker-compose --format "{{.ID}}" | xargs -r docker network rm 2>/dev/null || true

# Clean up docker system
docker system prune -f

# Clean up config files
sudo rm -rf $CONFIG_PATH/crypto-config
sudo rm -f $CONFIG_PATH/genesis.block $CONFIG_PATH/${CHANNEL_NAME}.tx $CONFIG_PATH/${CHANNEL_NAME}.block
sudo chown -R $USER:$USER $CONFIG_PATH/

echo "====> 1. Generate crypto material"
cryptogen generate --config=$CONFIG_PATH/crypto-config.yaml --output=$CONFIG_PATH/crypto-config

echo "====> 2. Generate genesis block & channel tx"
configtxgen -profile OneOrgOrdererGenesis -outputBlock $CONFIG_PATH/genesis.block -channelID system-channel
configtxgen -profile OneOrgChannel -outputCreateChannelTx $CONFIG_PATH/${CHANNEL_NAME}.tx -channelID $CHANNEL_NAME
# Verify file was created
if [ ! -f "$CONFIG_PATH/${CHANNEL_NAME}.tx" ]; then
    echo "Error: Channel transaction file was not created"
    exit 1
fi

echo "====> 3. Start Docker containers"
docker-compose -f $DOCKER_COMPOSE_PATH/docker-compose.yaml up -d

echo "====> Waiting for containers to start..."
sleep 15

echo "====> Checking container status..."
# Check if all required containers are running
REQUIRED_CONTAINERS=("peer0.org1.example.com" "orderer.example.com" "ca.org1.example.com" "cli")
for container in "${REQUIRED_CONTAINERS[@]}"; do
    if [ $(docker ps -a --filter "name=$container" --filter "status=running" --format "{{.Names}}" | wc -l) -eq 0 ]; then
        echo "❌ ERROR: Container $container is not running!"
        echo "Container logs for $container:"
        docker logs $container 2>/dev/null || echo "No logs available"
        echo "All running containers:"
        docker ps
        exit 1
    else
        echo "✅ Container $container is running"
    fi
done

echo "====> Waiting additional time for peer to be ready..."
sleep 10

echo "====> 4. Create channel"
# Add debugging
echo "Checking if crypto config exists in container..."
docker exec peer0.org1.example.com ls -la /etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/
# Create channel with correct path
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    peer0.org1.example.com peer channel create \
    -o orderer.example.com:7050 \
    -c $CHANNEL_NAME \
    -f /etc/hyperledger/fabric/${CHANNEL_NAME}.tx \
    --outputBlock /etc/hyperledger/fabric/${CHANNEL_NAME}.block \
    --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

echo "====> 5. Join peer to channel"
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    peer0.org1.example.com peer channel join -b /etc/hyperledger/fabric/${CHANNEL_NAME}.block

echo "====> 6. Package chaincode"
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path $CHAINCODE_PATH --lang golang --label ${CC_NAME}_${CC_VERSION}

echo "====> 7. Install chaincode"
docker cp ${CC_NAME}.tar.gz peer0.org1.example.com:/tmp/
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    peer0.org1.example.com peer lifecycle chaincode install /tmp/${CC_NAME}.tar.gz

echo "====> 8. Query installed chaincode to get package ID"
PKG_ID=$(docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    peer0.org1.example.com peer lifecycle chaincode queryinstalled 2>/dev/null | grep ${CC_NAME}_${CC_VERSION} | awk -F "[, ]+" '{print $3}')

if [ -z "$PKG_ID" ]; then
    echo "Error: Could not find package ID for chaincode ${CC_NAME}_${CC_VERSION}"
    echo "Listing all installed chaincodes:"
    docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
        peer0.org1.example.com peer lifecycle chaincode queryinstalled
    exit 1
fi

echo "Package ID: $PKG_ID"


echo "====> 9. Approve chaincode definition"
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
  peer0.org1.example.com peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 \
  --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQUENCE \
  --package-id $PKG_ID --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

echo "====> 10. Check commit readiness"
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    peer0.org1.example.com peer lifecycle chaincode checkcommitreadiness \
    --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQUENCE \
    --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem --output json

echo "====> 11. Commit chaincode definition"
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
  peer0.org1.example.com peer lifecycle chaincode commit -o orderer.example.com:7050 \
  --channelID $CHANNEL_NAME --name $CC_NAME --version $CC_VERSION --sequence $CC_SEQUENCE \
  --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

echo "====> 12. Query committed chaincode"
docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp \
    peer0.org1.example.com peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME

echo "====> ✅ Network is up and chaincode is deployed!"
echo "====> You can now invoke chaincode functions"
echo "====> Example: docker exec -e CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp peer0.org1.example.com peer chaincode invoke -o orderer.example.com:7050 --tls --cafile /etc/hyperledger/fabric/crypto-config/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n $CC_NAME -c '{\"function\":\"InitLedger\",\"Args\":[]}'"