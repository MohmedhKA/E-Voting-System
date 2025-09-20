#!/bin/bash

# 🗳️ E-Voting Multi-Org Raft Network Startup Script
# Fixed PATH and container counting bug

set -e

# Add Fabric binaries to PATH
export PATH="$HOME/eVoting/blockchain/bin:$PATH"

echo "🎯 Starting E-Voting Blockchain Network..."
echo "===> Multi-Organization Raft Consensus Setup"

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Set paths
BLOCKCHAIN_DIR=$(pwd)
FABRIC_CFG_PATH="$BLOCKCHAIN_DIR/config"
COMPOSE_FILE="$BLOCKCHAIN_DIR/docker-compose/docker-compose-raft.yaml"

echo -e "${BLUE}Working Directory: $BLOCKCHAIN_DIR${NC}"
echo -e "${BLUE}Config Path: $FABRIC_CFG_PATH${NC}"
echo -e "${BLUE}PATH: $PATH${NC}"

# Function to check if required binaries exist
check_binaries() {
    echo -e "${BLUE}Checking required binaries...${NC}"
    
    if ! command -v cryptogen &> /dev/null; then
        echo -e "${RED}❌ cryptogen not found in PATH${NC}"
        echo -e "${YELLOW}Make sure Fabric binaries are in: $HOME/eVoting/blockchain/bin${NC}"
        exit 1
    fi
    
    if ! command -v configtxgen &> /dev/null; then
        echo -e "${RED}❌ configtxgen not found in PATH${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ All required binaries found${NC}"
}

# Function to show detailed failed container logs
show_failed_logs() {
    echo -e "${RED}=====> Checking Failed Containers...${NC}"
    
    FAILED_CONTAINERS=$(docker ps -a --filter "status=exited" --format "{{.Names}}")
    
    if [ -z "$FAILED_CONTAINERS" ]; then
        echo -e "${GREEN}✅ No failed containers found${NC}"
    else
        echo -e "${RED}Found failed containers:${NC}"
        echo "$FAILED_CONTAINERS"
        
        for container in $FAILED_CONTAINERS; do
            echo -e "${YELLOW}==== Last 30 lines from $container ====${NC}"
            docker logs --tail 30 "$container" 2>&1
            echo ""
        done
    fi
}

# Function to check if crypto material exists
check_crypto_exists() {
    if [ -d "crypto-config" ] && [ -f "genesis.block" ] && [ -f "evoting-channel.tx" ]; then
        return 0
    else
        return 1
    fi
}

# Function to generate crypto material
generate_crypto() {
    echo -e "${YELLOW}=====> 1. Generating Crypto Material...${NC}"
    
    # Clean old material
    sudo rm -rf crypto-config/
    sudo rm -f genesis.block evoting-channel.tx
    
    # Set Fabric config path
    export FABRIC_CFG_PATH=$FABRIC_CFG_PATH
    
    # Generate certificates for all organizations
    echo -e "${BLUE}Generating certificates for Election Commission, Political Party, and Audit Authority...${NC}"
    cryptogen generate --config=config/crypto-config-multi.yaml --output=crypto-config
    
    echo -e "${BLUE}Copying admin certificates to admincerts folders...${NC}"

    # Election Commission admin certs
    mkdir -p crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp/admincerts
    cp crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp/signcerts/* crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp/admincerts/

    # Political Party admin certs
    mkdir -p crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp/admincerts
    cp crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp/signcerts/* crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp/admincerts/

    # Audit Authority admin certs
    mkdir -p crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp/admincerts
    cp crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp/signcerts/* crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp/admincerts/

    echo -e "${GREEN}✅ Admin certificates copied successfully!${NC}"
    
    # Generate genesis block
    echo -e "${BLUE}Generating Genesis Block with Raft consensus...${NC}"
    configtxgen -profile MultiOrgRaftGenesis -outputBlock genesis.block -channelID system-channel
    
    # Generate channel transaction
    echo -e "${BLUE}Generating Channel Transaction...${NC}"
    configtxgen -profile MultiOrgChannel -outputCreateChannelTx evoting-channel.tx -channelID evotingchannel

    # Replace the anchor peer generation section with this:
    echo -e "${BLUE}Generating Channel Transaction with Embedded Anchor Peers...${NC}"

    # Add this to generate_crypto() after channel tx generation:

    # Generate anchor peer updates
    echo -e "${BLUE}Generating anchor peer updates...${NC}"
    mkdir -p channel-artifacts
    
    configtxgen -profile MultiOrgChannel \
        -outputAnchorPeersUpdate ./channel-artifacts/ElectionCommissionMSPanchors.tx \
        -channelID evotingchannel \
        -asOrg ElectionCommissionMSP
        
    configtxgen -profile MultiOrgChannel \
        -outputAnchorPeersUpdate ./channel-artifacts/PoliticalPartyMSPanchors.tx \
        -channelID evotingchannel \
        -asOrg PoliticalPartyMSP
        
    configtxgen -profile MultiOrgChannel \
        -outputAnchorPeersUpdate ./channel-artifacts/AuditAuthorityMSPanchors.tx \
        -channelID evotingchannel \
        -asOrg AuditAuthorityMSP

    # Don't generate separate anchor peer files - they're already embedded!
    echo -e "${GREEN}✅ Channel transaction with anchor peers generated!${NC}"
  
    echo -e "${GREEN}✅ Crypto material generated successfully!${NC}"
}

# Add this function after check_raft_consensus()
create_and_join_channel() {
    echo -e "${YELLOW}=====> Creating and Joining Channel...${NC}"
    
    # Set environment for EC peer
    export CORE_PEER_LOCALMSPID="ElectionCommissionMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051

    echo -e "${BLUE}Creating channel 'evotingchannel'...${NC}"
    # Use localhost instead of orderer1.example.com
    peer channel create -o localhost:7050 --ordererTLSHostnameOverride orderer1.example.com \
        -c evotingchannel -f evoting-channel.tx \
        --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

    echo -e "${BLUE}Joining EC peer to channel...${NC}"
    peer channel join -b evotingchannel.block

    # Join Party peer
    export CORE_PEER_LOCALMSPID="PoliticalPartyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/party.example.com/peers/peer0.party.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051

    echo -e "${BLUE}Joining Party peer to channel...${NC}"
    peer channel join -b evotingchannel.block

    # Join Audit peer
    export CORE_PEER_LOCALMSPID="AuditAuthorityMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/audit.example.com/peers/peer0.audit.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

    echo -e "${BLUE}Joining Audit peer to channel...${NC}"
    peer channel join -b evotingchannel.block

    echo -e "${GREEN}✅ Channel created and all peers joined successfully!${NC}"
}


# Function to start network
start_network() {
    echo -e "${YELLOW}=====> 2. Starting Docker Containers...${NC}"
    
    # Stop any existing containers
    docker-compose -f "$COMPOSE_FILE" down 2>/dev/null || true
    
    # Clean up orphaned containers
    docker container prune -f >/dev/null 2>&1
    
    # Start the network
    echo -e "${BLUE}Starting Multi-Org Raft Network...${NC}"
    docker-compose -f "$COMPOSE_FILE" up -d
    
    # Wait for startup
    echo -e "${BLUE}Waiting for containers to initialize...${NC}"
    sleep 30
}

# Function to check network status
check_network_status() {
    echo -e "${YELLOW}=====> 3. Network Status Check...${NC}"
    
    # Get container statuses
    echo -e "${BLUE}All Container Statuses:${NC}"
    docker ps -a --filter "name=orderer\|peer\|ca\." --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    # FIXED: Count running containers correctly
    RUNNING_COUNT=$(docker ps --filter "name=orderer" --format "{{.Names}}" | wc -l)
    RUNNING_COUNT=$((RUNNING_COUNT + $(docker ps --filter "name=peer" --format "{{.Names}}" | wc -l)))
    RUNNING_COUNT=$((RUNNING_COUNT + $(docker ps --filter "name=ca\." --format "{{.Names}}" | wc -l)))
    
    TOTAL_EXPECTED=11
    
    echo ""
    echo -e "${BLUE}Summary: $RUNNING_COUNT/$TOTAL_EXPECTED containers running${NC}"
    
    if [ "$RUNNING_COUNT" -eq "$TOTAL_EXPECTED" ]; then
        echo -e "${GREEN}🎉 SUCCESS: All containers are running!${NC}"
        check_raft_consensus
        create_and_join_channel  # ADD THIS LINE
        #setup_anchor_peers
    else
        echo -e "${RED}⚠️ Some containers failed to start.${NC}"
        show_failed_logs
    fi

}

# Function to check Raft consensus
check_raft_consensus() {
    echo -e "${YELLOW}=====> 4. Checking Raft Consensus...${NC}"
    
    for i in 1 2 3; do
        echo -e "${BLUE}Orderer$i Raft Status:${NC}"
        docker logs orderer$i.example.com 2>/dev/null | grep -i "leader\|elected" | tail -2 || echo "  Still initializing..."
    done
}

# Add this function after check_raft_consensus()
setup_anchor_peers() {
    echo -e "${YELLOW}=====> 5. Setting up Anchor Peers...${NC}"
    
    # Wait a bit more for channel to be fully ready
    sleep 10
    
    # Set environment for Election Commission
    export CORE_PEER_LOCALMSPID="ElectionCommissionMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/ec.example.com/peers/peer0.ec.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/ec.example.com/users/Admin@ec.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
    
    echo -e "${BLUE}Updating anchor peer for Election Commission...${NC}"
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer1.example.com \
        -c evotingchannel -f ./channel-artifacts/ElectionCommissionMSPanchors.tx \
        --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    
    # Set environment for Political Party
    export CORE_PEER_LOCALMSPID="PoliticalPartyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/party.example.com/peers/peer0.party.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/party.example.com/users/Admin@party.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
    echo -e "${BLUE}Updating anchor peer for Political Party...${NC}"
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer1.example.com \
        -c evotingchannel -f ./channel-artifacts/PoliticalPartyMSPanchors.tx \
        --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    
    # Set environment for Audit Authority  
    export CORE_PEER_LOCALMSPID="AuditAuthorityMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/crypto-config/peerOrganizations/audit.example.com/peers/peer0.audit.example.com/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/audit.example.com/users/Admin@audit.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
    echo -e "${BLUE}Updating anchor peer for Audit Authority...${NC}"
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer1.example.com \
        -c evotingchannel -f ./channel-artifacts/AuditAuthorityMSPanchors.tx \
        --tls --cafile ${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    
    echo -e "${GREEN}✅ Anchor peers configured successfully!${NC}"
}

# Then call this function in your main() function after check_raft_consensus

# Main execution
main() {
    echo "🗳️ ================================================"
    echo "   MULTI-ORG BLOCKCHAIN E-VOTING SYSTEM"
    echo "   Raft Consensus | Production Ready"  
    echo "================================================"
    
    # Check required binaries
    check_binaries
    
    # Check if we need to generate crypto material
    if check_crypto_exists && [[ "$1" != "--regenerate" ]] && [[ "$1" != "-r" ]]; then
        echo -e "${GREEN}✅ Crypto material already exists. Skipping generation...${NC}"
    else
        echo -e "${YELLOW}🔄 Generating crypto material...${NC}"
        generate_crypto
    fi
    
    # Start the network
    start_network
    
    # Check status
    check_network_status
    
    echo -e "${GREEN}🎉 E-Voting Network Startup Complete!${NC}"
}

# Help function
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "🗳️ E-Voting Network Startup Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --regenerate, -r    Force regenerate crypto material"
    echo "  --help, -h          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                  Start network (reuse existing crypto)"
    echo "  $0 --regenerate     Start with fresh crypto material"
    exit 0
fi

# Run main function
main "$@"
