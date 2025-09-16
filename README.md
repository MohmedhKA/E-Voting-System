# E-Voting-System

```
eVoting
├─ README.md
├─ blockchain
│  ├─ bin
│  │  ├─ configtxgen
│  │  ├─ configtxlator
│  │  ├─ cryptogen
│  │  ├─ discover
│  │  ├─ fabric-ca-client
│  │  ├─ fabric-ca-server
│  │  ├─ ledgerutil
│  │  ├─ orderer
│  │  ├─ osnadmin
│  │  └─ peer
│  ├─ chaincode
│  │  └─ go
│  │     └─ evoting
│  │        ├─ chaincode.go
│  │        ├─ evoting
│  │        ├─ go.mod
│  │        └─ go.sum
│  ├─ config
│  │  ├─ configtx-raft.yaml
│  │  ├─ configtx.yaml
│  │  ├─ core.yaml
│  │  ├─ crypto-config-multi.yaml
│  │  ├─ crypto-config.yaml
│  │  ├─ msp
│  │  │  └─ keystore
│  │  ├─ tls
│  │  └─ tlsca.example.com-cert.pem
│  ├─ crypto-config
│  │  ├─ ordererOrganizations
│  │  │  └─ example.com
│  │  │     ├─ ca
│  │  │     │  ├─ ca.example.com-cert.pem
│  │  │     │  └─ priv_sk
│  │  │     ├─ msp
│  │  │     │  ├─ admincerts
│  │  │     │  │  ├─ Admin@example.com-cert.pem
│  │  │     │  │  └─ ca.example.com-cert.pem
│  │  │     │  ├─ cacerts
│  │  │     │  │  └─ ca.example.com-cert.pem
│  │  │     │  └─ tlscacerts
│  │  │     │     └─ tlsca.example.com-cert.pem
│  │  │     ├─ orderers
│  │  │     │  ├─ orderer1.example.com
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ admincerts
│  │  │     │  │  │  │  └─ Admin@example.com-cert.pem
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  │  └─ ca.example.com-cert.pem
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  └─ priv_sk
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  │  └─ orderer1.example.com-cert.pem
│  │  │     │  │  │  └─ tlscacerts
│  │  │     │  │  │     └─ tlsca.example.com-cert.pem
│  │  │     │  │  └─ tls
│  │  │     │  │     ├─ ca.crt
│  │  │     │  │     ├─ server.crt
│  │  │     │  │     └─ server.key
│  │  │     │  ├─ orderer2.example.com
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ admincerts
│  │  │     │  │  │  │  └─ Admin@example.com-cert.pem
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  │  └─ ca.example.com-cert.pem
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  └─ priv_sk
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  │  └─ orderer2.example.com-cert.pem
│  │  │     │  │  │  └─ tlscacerts
│  │  │     │  │  │     └─ tlsca.example.com-cert.pem
│  │  │     │  │  └─ tls
│  │  │     │  │     ├─ ca.crt
│  │  │     │  │     ├─ server.crt
│  │  │     │  │     └─ server.key
│  │  │     │  └─ orderer3.example.com
│  │  │     │     ├─ msp
│  │  │     │     │  ├─ admincerts
│  │  │     │     │  │  └─ Admin@example.com-cert.pem
│  │  │     │     │  ├─ cacerts
│  │  │     │     │  │  └─ ca.example.com-cert.pem
│  │  │     │     │  ├─ keystore
│  │  │     │     │  │  └─ priv_sk
│  │  │     │     │  ├─ signcerts
│  │  │     │     │  │  └─ orderer3.example.com-cert.pem
│  │  │     │     │  └─ tlscacerts
│  │  │     │     │     └─ tlsca.example.com-cert.pem
│  │  │     │     └─ tls
│  │  │     │        ├─ ca.crt
│  │  │     │        ├─ server.crt
│  │  │     │        └─ server.key
│  │  │     ├─ tlsca
│  │  │     │  ├─ priv_sk
│  │  │     │  └─ tlsca.example.com-cert.pem
│  │  │     └─ users
│  │  │        └─ Admin@example.com
│  │  │           ├─ msp
│  │  │           │  ├─ admincerts
│  │  │           │  │  └─ Admin@example.com-cert.pem
│  │  │           │  ├─ cacerts
│  │  │           │  │  └─ ca.example.com-cert.pem
│  │  │           │  ├─ keystore
│  │  │           │  │  └─ priv_sk
│  │  │           │  ├─ signcerts
│  │  │           │  │  └─ Admin@example.com-cert.pem
│  │  │           │  └─ tlscacerts
│  │  │           │     └─ tlsca.example.com-cert.pem
│  │  │           └─ tls
│  │  │              ├─ ca.crt
│  │  │              ├─ client.crt
│  │  │              └─ client.key
│  │  └─ peerOrganizations
│  │     ├─ audit.example.com
│  │     │  ├─ ca
│  │     │  │  ├─ ca.audit.example.com-cert.pem
│  │     │  │  └─ priv_sk
│  │     │  ├─ msp
│  │     │  │  ├─ admincerts
│  │     │  │  ├─ cacerts
│  │     │  │  │  └─ ca.audit.example.com-cert.pem
│  │     │  │  ├─ config.yaml
│  │     │  │  └─ tlscacerts
│  │     │  │     └─ tlsca.audit.example.com-cert.pem
│  │     │  ├─ peers
│  │     │  │  └─ peer0.audit.example.com
│  │     │  │     ├─ msp
│  │     │  │     │  ├─ admincerts
│  │     │  │     │  ├─ cacerts
│  │     │  │     │  │  └─ ca.audit.example.com-cert.pem
│  │     │  │     │  ├─ config.yaml
│  │     │  │     │  ├─ keystore
│  │     │  │     │  │  └─ priv_sk
│  │     │  │     │  ├─ signcerts
│  │     │  │     │  │  └─ peer0.audit.example.com-cert.pem
│  │     │  │     │  └─ tlscacerts
│  │     │  │     │     └─ tlsca.audit.example.com-cert.pem
│  │     │  │     └─ tls
│  │     │  │        ├─ ca.crt
│  │     │  │        ├─ server.crt
│  │     │  │        └─ server.key
│  │     │  ├─ tlsca
│  │     │  │  ├─ priv_sk
│  │     │  │  └─ tlsca.audit.example.com-cert.pem
│  │     │  └─ users
│  │     │     ├─ Admin@audit.example.com
│  │     │     │  ├─ msp
│  │     │     │  │  ├─ admincerts
│  │     │     │  │  ├─ cacerts
│  │     │     │  │  │  └─ ca.audit.example.com-cert.pem
│  │     │     │  │  ├─ config.yaml
│  │     │     │  │  ├─ keystore
│  │     │     │  │  │  └─ priv_sk
│  │     │     │  │  ├─ signcerts
│  │     │     │  │  │  └─ Admin@audit.example.com-cert.pem
│  │     │     │  │  └─ tlscacerts
│  │     │     │  │     └─ tlsca.audit.example.com-cert.pem
│  │     │     │  └─ tls
│  │     │     │     ├─ ca.crt
│  │     │     │     ├─ client.crt
│  │     │     │     └─ client.key
│  │     │     └─ User1@audit.example.com
│  │     │        ├─ msp
│  │     │        │  ├─ admincerts
│  │     │        │  ├─ cacerts
│  │     │        │  │  └─ ca.audit.example.com-cert.pem
│  │     │        │  ├─ config.yaml
│  │     │        │  ├─ keystore
│  │     │        │  │  └─ priv_sk
│  │     │        │  ├─ signcerts
│  │     │        │  │  └─ User1@audit.example.com-cert.pem
│  │     │        │  └─ tlscacerts
│  │     │        │     └─ tlsca.audit.example.com-cert.pem
│  │     │        └─ tls
│  │     │           ├─ ca.crt
│  │     │           ├─ client.crt
│  │     │           └─ client.key
│  │     ├─ ec.example.com
│  │     │  ├─ ca
│  │     │  │  ├─ ca.ec.example.com-cert.pem
│  │     │  │  └─ priv_sk
│  │     │  ├─ msp
│  │     │  │  ├─ admincerts
│  │     │  │  ├─ cacerts
│  │     │  │  │  └─ ca.ec.example.com-cert.pem
│  │     │  │  ├─ config.yaml
│  │     │  │  └─ tlscacerts
│  │     │  │     └─ tlsca.ec.example.com-cert.pem
│  │     │  ├─ peers
│  │     │  │  ├─ peer0.ec.example.com
│  │     │  │  │  ├─ msp
│  │     │  │  │  │  ├─ admincerts
│  │     │  │  │  │  ├─ cacerts
│  │     │  │  │  │  │  └─ ca.ec.example.com-cert.pem
│  │     │  │  │  │  ├─ config.yaml
│  │     │  │  │  │  ├─ keystore
│  │     │  │  │  │  │  └─ priv_sk
│  │     │  │  │  │  ├─ signcerts
│  │     │  │  │  │  │  └─ peer0.ec.example.com-cert.pem
│  │     │  │  │  │  └─ tlscacerts
│  │     │  │  │  │     └─ tlsca.ec.example.com-cert.pem
│  │     │  │  │  └─ tls
│  │     │  │  │     ├─ ca.crt
│  │     │  │  │     ├─ server.crt
│  │     │  │  │     └─ server.key
│  │     │  │  └─ peer1.ec.example.com
│  │     │  │     ├─ msp
│  │     │  │     │  ├─ admincerts
│  │     │  │     │  ├─ cacerts
│  │     │  │     │  │  └─ ca.ec.example.com-cert.pem
│  │     │  │     │  ├─ config.yaml
│  │     │  │     │  ├─ keystore
│  │     │  │     │  │  └─ priv_sk
│  │     │  │     │  ├─ signcerts
│  │     │  │     │  │  └─ peer1.ec.example.com-cert.pem
│  │     │  │     │  └─ tlscacerts
│  │     │  │     │     └─ tlsca.ec.example.com-cert.pem
│  │     │  │     └─ tls
│  │     │  │        ├─ ca.crt
│  │     │  │        ├─ server.crt
│  │     │  │        └─ server.key
│  │     │  ├─ tlsca
│  │     │  │  ├─ priv_sk
│  │     │  │  └─ tlsca.ec.example.com-cert.pem
│  │     │  └─ users
│  │     │     ├─ Admin@ec.example.com
│  │     │     │  ├─ msp
│  │     │     │  │  ├─ admincerts
│  │     │     │  │  ├─ cacerts
│  │     │     │  │  │  └─ ca.ec.example.com-cert.pem
│  │     │     │  │  ├─ config.yaml
│  │     │     │  │  ├─ keystore
│  │     │     │  │  │  └─ priv_sk
│  │     │     │  │  ├─ signcerts
│  │     │     │  │  │  └─ Admin@ec.example.com-cert.pem
│  │     │     │  │  └─ tlscacerts
│  │     │     │  │     └─ tlsca.ec.example.com-cert.pem
│  │     │     │  └─ tls
│  │     │     │     ├─ ca.crt
│  │     │     │     ├─ client.crt
│  │     │     │     └─ client.key
│  │     │     └─ User1@ec.example.com
│  │     │        ├─ msp
│  │     │        │  ├─ admincerts
│  │     │        │  ├─ cacerts
│  │     │        │  │  └─ ca.ec.example.com-cert.pem
│  │     │        │  ├─ config.yaml
│  │     │        │  ├─ keystore
│  │     │        │  │  └─ priv_sk
│  │     │        │  ├─ signcerts
│  │     │        │  │  └─ User1@ec.example.com-cert.pem
│  │     │        │  └─ tlscacerts
│  │     │        │     └─ tlsca.ec.example.com-cert.pem
│  │     │        └─ tls
│  │     │           ├─ ca.crt
│  │     │           ├─ client.crt
│  │     │           └─ client.key
│  │     └─ party.example.com
│  │        ├─ ca
│  │        │  ├─ ca.party.example.com-cert.pem
│  │        │  └─ priv_sk
│  │        ├─ msp
│  │        │  ├─ admincerts
│  │        │  ├─ cacerts
│  │        │  │  └─ ca.party.example.com-cert.pem
│  │        │  ├─ config.yaml
│  │        │  └─ tlscacerts
│  │        │     └─ tlsca.party.example.com-cert.pem
│  │        ├─ peers
│  │        │  ├─ peer0.party.example.com
│  │        │  │  ├─ msp
│  │        │  │  │  ├─ admincerts
│  │        │  │  │  ├─ cacerts
│  │        │  │  │  │  └─ ca.party.example.com-cert.pem
│  │        │  │  │  ├─ config.yaml
│  │        │  │  │  ├─ keystore
│  │        │  │  │  │  └─ priv_sk
│  │        │  │  │  ├─ signcerts
│  │        │  │  │  │  └─ peer0.party.example.com-cert.pem
│  │        │  │  │  └─ tlscacerts
│  │        │  │  │     └─ tlsca.party.example.com-cert.pem
│  │        │  │  └─ tls
│  │        │  │     ├─ ca.crt
│  │        │  │     ├─ server.crt
│  │        │  │     └─ server.key
│  │        │  └─ peer1.party.example.com
│  │        │     ├─ msp
│  │        │     │  ├─ admincerts
│  │        │     │  ├─ cacerts
│  │        │     │  │  └─ ca.party.example.com-cert.pem
│  │        │     │  ├─ config.yaml
│  │        │     │  ├─ keystore
│  │        │     │  │  └─ priv_sk
│  │        │     │  ├─ signcerts
│  │        │     │  │  └─ peer1.party.example.com-cert.pem
│  │        │     │  └─ tlscacerts
│  │        │     │     └─ tlsca.party.example.com-cert.pem
│  │        │     └─ tls
│  │        │        ├─ ca.crt
│  │        │        ├─ server.crt
│  │        │        └─ server.key
│  │        ├─ tlsca
│  │        │  ├─ priv_sk
│  │        │  └─ tlsca.party.example.com-cert.pem
│  │        └─ users
│  │           ├─ Admin@party.example.com
│  │           │  ├─ msp
│  │           │  │  ├─ admincerts
│  │           │  │  ├─ cacerts
│  │           │  │  │  └─ ca.party.example.com-cert.pem
│  │           │  │  ├─ config.yaml
│  │           │  │  ├─ keystore
│  │           │  │  │  └─ priv_sk
│  │           │  │  ├─ signcerts
│  │           │  │  │  └─ Admin@party.example.com-cert.pem
│  │           │  │  └─ tlscacerts
│  │           │  │     └─ tlsca.party.example.com-cert.pem
│  │           │  └─ tls
│  │           │     ├─ ca.crt
│  │           │     ├─ client.crt
│  │           │     └─ client.key
│  │           └─ User1@party.example.com
│  │              ├─ msp
│  │              │  ├─ admincerts
│  │              │  ├─ cacerts
│  │              │  │  └─ ca.party.example.com-cert.pem
│  │              │  ├─ config.yaml
│  │              │  ├─ keystore
│  │              │  │  └─ priv_sk
│  │              │  ├─ signcerts
│  │              │  │  └─ User1@party.example.com-cert.pem
│  │              │  └─ tlscacerts
│  │              │     └─ tlsca.party.example.com-cert.pem
│  │              └─ tls
│  │                 ├─ ca.crt
│  │                 ├─ client.crt
│  │                 └─ client.key
│  ├─ docker-compose
│  │  ├─ config
│  │  │  └─ msp
│  │  │     └─ keystore
│  │  ├─ crypto-config
│  │  │  ├─ ca
│  │  │  │  ├─ IssuerPublicKey
│  │  │  │  ├─ IssuerRevocationPublicKey
│  │  │  │  ├─ ca-cert.pem
│  │  │  │  ├─ fabric-ca-server-config.yaml
│  │  │  │  ├─ fabric-ca-server.db
│  │  │  │  ├─ msp
│  │  │  │  │  ├─ cacerts
│  │  │  │  │  ├─ keystore
│  │  │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │  │  │  │  └─ IssuerSecretKey
│  │  │  │  │  ├─ signcerts
│  │  │  │  │  └─ user
│  │  │  │  └─ tls-cert.pem
│  │  │  ├─ ordererOrganizations
│  │  │  │  └─ example.com
│  │  │  │     └─ orderers
│  │  │  │        ├─ orderer1.example.com
│  │  │  │        │  ├─ msp
│  │  │  │        │  │  └─ keystore
│  │  │  │        │  └─ tls
│  │  │  │        ├─ orderer2.example.com
│  │  │  │        │  ├─ msp
│  │  │  │        │  │  └─ keystore
│  │  │  │        │  └─ tls
│  │  │  │        └─ orderer3.example.com
│  │  │  │           ├─ msp
│  │  │  │           │  └─ keystore
│  │  │  │           └─ tls
│  │  │  └─ peerOrganizations
│  │  │     ├─ audit.example.com
│  │  │     │  ├─ ca
│  │  │     │  │  ├─ IssuerPublicKey
│  │  │     │  │  ├─ IssuerRevocationPublicKey
│  │  │     │  │  ├─ ca-cert.pem
│  │  │     │  │  ├─ fabric-ca-server-config.yaml
│  │  │     │  │  ├─ fabric-ca-server.db
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  ├─ 5867f4596645da0de2b547113d3d47b07f2c1f25df32864c636322d8eda92184_sk
│  │  │     │  │  │  │  ├─ 5ca644cb1ae7d6c8490dc1e99189b7af778a8879f324ad15a8f08b9e82392df2_sk
│  │  │     │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │     │  │  │  │  └─ IssuerSecretKey
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  └─ user
│  │  │     │  │  └─ tls-cert.pem
│  │  │     │  └─ peers
│  │  │     │     └─ peer0.audit.example.com
│  │  │     │        ├─ msp
│  │  │     │        │  └─ keystore
│  │  │     │        └─ tls
│  │  │     ├─ ec.example.com
│  │  │     │  ├─ ca
│  │  │     │  │  ├─ IssuerPublicKey
│  │  │     │  │  ├─ IssuerRevocationPublicKey
│  │  │     │  │  ├─ ca-cert.pem
│  │  │     │  │  ├─ fabric-ca-server-config.yaml
│  │  │     │  │  ├─ fabric-ca-server.db
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  ├─ 6ec55194da3dfa0d2c6be75d599d033148cbae9a68cead6e1b33d56575e5790b_sk
│  │  │     │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │     │  │  │  │  ├─ IssuerSecretKey
│  │  │     │  │  │  │  └─ c91d12da51a602ccf65a50474fdafd4fd88eb9f6f9b83d916838a3dae067af2c_sk
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  └─ user
│  │  │     │  │  └─ tls-cert.pem
│  │  │     │  └─ peers
│  │  │     │     ├─ peer0.ec.example.com
│  │  │     │     │  ├─ msp
│  │  │     │     │  │  └─ keystore
│  │  │     │     │  └─ tls
│  │  │     │     └─ peer1.ec.example.com
│  │  │     │        ├─ msp
│  │  │     │        │  └─ keystore
│  │  │     │        └─ tls
│  │  │     └─ party.example.com
│  │  │        ├─ ca
│  │  │        │  ├─ IssuerPublicKey
│  │  │        │  ├─ IssuerRevocationPublicKey
│  │  │        │  ├─ ca-cert.pem
│  │  │        │  ├─ fabric-ca-server-config.yaml
│  │  │        │  ├─ fabric-ca-server.db
│  │  │        │  ├─ msp
│  │  │        │  │  ├─ cacerts
│  │  │        │  │  ├─ keystore
│  │  │        │  │  │  ├─ 2fb518ab0c66cba610d8e18b09905c09e67e4b9bb2aaa9277b31d20f53fff47f_sk
│  │  │        │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │        │  │  │  ├─ IssuerSecretKey
│  │  │        │  │  │  └─ bf1acc9ae5b4dfae3e72880908907914c8ad7eff0f02cb89d1d55d60370dd4ba_sk
│  │  │        │  │  ├─ signcerts
│  │  │        │  │  └─ user
│  │  │        │  └─ tls-cert.pem
│  │  │        └─ peers
│  │  │           ├─ peer0.party.example.com
│  │  │           │  ├─ msp
│  │  │           │  │  └─ keystore
│  │  │           │  └─ tls
│  │  │           └─ peer1.party.example.com
│  │  │              ├─ msp
│  │  │              │  └─ keystore
│  │  │              └─ tls
│  │  ├─ docker-compose.yaml
│  │  └─ genesis.block
│  ├─ docker-compose-raft.yaml
│  ├─ evoting-channel.tx
│  ├─ evoting.tar.gz
│  ├─ genesis.block
│  └─ network-scripts
│     ├─ gen.sh
│     ├─ start-network.sh
│     ├─ stop-network.sh
│     └─ upgrade-to-raft.sh
└─ evoting.tar.gz

```
```
eVoting
├─ README.md
├─ blockchain
│  ├─ bin
│  │  ├─ configtxgen
│  │  ├─ configtxlator
│  │  ├─ cryptogen
│  │  ├─ discover
│  │  ├─ fabric-ca-client
│  │  ├─ fabric-ca-server
│  │  ├─ ledgerutil
│  │  ├─ orderer
│  │  ├─ osnadmin
│  │  └─ peer
│  ├─ chaincode
│  │  └─ go
│  │     └─ evoting
│  │        ├─ chaincode.go
│  │        ├─ evoting
│  │        ├─ go.mod
│  │        └─ go.sum
│  ├─ config
│  │  ├─ configtx-raft.yaml
│  │  ├─ configtx.yaml
│  │  ├─ core.yaml
│  │  ├─ crypto-config-multi.yaml
│  │  ├─ crypto-config.yaml
│  │  ├─ msp
│  │  │  └─ keystore
│  │  ├─ tls
│  │  └─ tlsca.example.com-cert.pem
│  ├─ crypto-config
│  │  ├─ ordererOrganizations
│  │  │  └─ example.com
│  │  │     ├─ ca
│  │  │     │  ├─ ca.example.com-cert.pem
│  │  │     │  └─ priv_sk
│  │  │     ├─ msp
│  │  │     │  ├─ admincerts
│  │  │     │  │  └─ Admin@example.com-cert.pem
│  │  │     │  ├─ cacerts
│  │  │     │  │  └─ ca.example.com-cert.pem
│  │  │     │  └─ tlscacerts
│  │  │     │     └─ tlsca.example.com-cert.pem
│  │  │     ├─ orderers
│  │  │     │  ├─ orderer1.example.com
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ admincerts
│  │  │     │  │  │  │  └─ Admin@example.com-cert.pem
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  │  └─ ca.example.com-cert.pem
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  └─ priv_sk
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  │  └─ orderer1.example.com-cert.pem
│  │  │     │  │  │  └─ tlscacerts
│  │  │     │  │  │     └─ tlsca.example.com-cert.pem
│  │  │     │  │  └─ tls
│  │  │     │  │     ├─ ca.crt
│  │  │     │  │     ├─ server.crt
│  │  │     │  │     └─ server.key
│  │  │     │  ├─ orderer2.example.com
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ admincerts
│  │  │     │  │  │  │  └─ Admin@example.com-cert.pem
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  │  └─ ca.example.com-cert.pem
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  └─ priv_sk
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  │  └─ orderer2.example.com-cert.pem
│  │  │     │  │  │  └─ tlscacerts
│  │  │     │  │  │     └─ tlsca.example.com-cert.pem
│  │  │     │  │  └─ tls
│  │  │     │  │     ├─ ca.crt
│  │  │     │  │     ├─ server.crt
│  │  │     │  │     └─ server.key
│  │  │     │  └─ orderer3.example.com
│  │  │     │     ├─ msp
│  │  │     │     │  ├─ admincerts
│  │  │     │     │  │  └─ Admin@example.com-cert.pem
│  │  │     │     │  ├─ cacerts
│  │  │     │     │  │  └─ ca.example.com-cert.pem
│  │  │     │     │  ├─ keystore
│  │  │     │     │  │  └─ priv_sk
│  │  │     │     │  ├─ signcerts
│  │  │     │     │  │  └─ orderer3.example.com-cert.pem
│  │  │     │     │  └─ tlscacerts
│  │  │     │     │     └─ tlsca.example.com-cert.pem
│  │  │     │     └─ tls
│  │  │     │        ├─ ca.crt
│  │  │     │        ├─ server.crt
│  │  │     │        └─ server.key
│  │  │     ├─ tlsca
│  │  │     │  ├─ priv_sk
│  │  │     │  └─ tlsca.example.com-cert.pem
│  │  │     └─ users
│  │  │        └─ Admin@example.com
│  │  │           ├─ msp
│  │  │           │  ├─ admincerts
│  │  │           │  │  └─ Admin@example.com-cert.pem
│  │  │           │  ├─ cacerts
│  │  │           │  │  └─ ca.example.com-cert.pem
│  │  │           │  ├─ keystore
│  │  │           │  │  └─ priv_sk
│  │  │           │  ├─ signcerts
│  │  │           │  │  └─ Admin@example.com-cert.pem
│  │  │           │  └─ tlscacerts
│  │  │           │     └─ tlsca.example.com-cert.pem
│  │  │           └─ tls
│  │  │              ├─ ca.crt
│  │  │              ├─ client.crt
│  │  │              └─ client.key
│  │  └─ peerOrganizations
│  │     ├─ audit.example.com
│  │     │  ├─ ca
│  │     │  │  ├─ IssuerPublicKey
│  │     │  │  ├─ IssuerRevocationPublicKey
│  │     │  │  ├─ ca-cert.pem
│  │     │  │  ├─ ca.audit.example.com-cert.pem
│  │     │  │  ├─ fabric-ca-server-config.yaml
│  │     │  │  ├─ fabric-ca-server.db
│  │     │  │  ├─ msp
│  │     │  │  │  ├─ cacerts
│  │     │  │  │  ├─ keystore
│  │     │  │  │  │  ├─ 093b05c6493475e27592f21fc18571666af7cb3078357af30101ccf717b82904_sk
│  │     │  │  │  │  ├─ 972148e44fb25abc189b653e94f28573a153927f5bd659b830ca475f71c900d5_sk
│  │     │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │     │  │  │  │  └─ IssuerSecretKey
│  │     │  │  │  ├─ signcerts
│  │     │  │  │  └─ user
│  │     │  │  ├─ priv_sk
│  │     │  │  └─ tls-cert.pem
│  │     │  ├─ msp
│  │     │  │  ├─ admincerts
│  │     │  │  ├─ cacerts
│  │     │  │  │  └─ ca.audit.example.com-cert.pem
│  │     │  │  ├─ config.yaml
│  │     │  │  └─ tlscacerts
│  │     │  │     └─ tlsca.audit.example.com-cert.pem
│  │     │  ├─ peers
│  │     │  │  └─ peer0.audit.example.com
│  │     │  │     ├─ msp
│  │     │  │     │  ├─ admincerts
│  │     │  │     │  ├─ cacerts
│  │     │  │     │  │  └─ ca.audit.example.com-cert.pem
│  │     │  │     │  ├─ config.yaml
│  │     │  │     │  ├─ keystore
│  │     │  │     │  │  └─ priv_sk
│  │     │  │     │  ├─ signcerts
│  │     │  │     │  │  └─ peer0.audit.example.com-cert.pem
│  │     │  │     │  └─ tlscacerts
│  │     │  │     │     └─ tlsca.audit.example.com-cert.pem
│  │     │  │     └─ tls
│  │     │  │        ├─ ca.crt
│  │     │  │        ├─ server.crt
│  │     │  │        └─ server.key
│  │     │  ├─ tlsca
│  │     │  │  ├─ priv_sk
│  │     │  │  └─ tlsca.audit.example.com-cert.pem
│  │     │  └─ users
│  │     │     ├─ Admin@audit.example.com
│  │     │     │  ├─ msp
│  │     │     │  │  ├─ admincerts
│  │     │     │  │  ├─ cacerts
│  │     │     │  │  │  └─ ca.audit.example.com-cert.pem
│  │     │     │  │  ├─ config.yaml
│  │     │     │  │  ├─ keystore
│  │     │     │  │  │  └─ priv_sk
│  │     │     │  │  ├─ signcerts
│  │     │     │  │  │  └─ Admin@audit.example.com-cert.pem
│  │     │     │  │  └─ tlscacerts
│  │     │     │  │     └─ tlsca.audit.example.com-cert.pem
│  │     │     │  └─ tls
│  │     │     │     ├─ ca.crt
│  │     │     │     ├─ client.crt
│  │     │     │     └─ client.key
│  │     │     └─ User1@audit.example.com
│  │     │        ├─ msp
│  │     │        │  ├─ admincerts
│  │     │        │  ├─ cacerts
│  │     │        │  │  └─ ca.audit.example.com-cert.pem
│  │     │        │  ├─ config.yaml
│  │     │        │  ├─ keystore
│  │     │        │  │  └─ priv_sk
│  │     │        │  ├─ signcerts
│  │     │        │  │  └─ User1@audit.example.com-cert.pem
│  │     │        │  └─ tlscacerts
│  │     │        │     └─ tlsca.audit.example.com-cert.pem
│  │     │        └─ tls
│  │     │           ├─ ca.crt
│  │     │           ├─ client.crt
│  │     │           └─ client.key
│  │     ├─ ec.example.com
│  │     │  ├─ ca
│  │     │  │  ├─ IssuerPublicKey
│  │     │  │  ├─ IssuerRevocationPublicKey
│  │     │  │  ├─ ca-cert.pem
│  │     │  │  ├─ ca.ec.example.com-cert.pem
│  │     │  │  ├─ fabric-ca-server-config.yaml
│  │     │  │  ├─ fabric-ca-server.db
│  │     │  │  ├─ msp
│  │     │  │  │  ├─ cacerts
│  │     │  │  │  ├─ keystore
│  │     │  │  │  │  ├─ 7903755885932236d44428946470c02631f6aab4042ede5f20d486e36211f7c1_sk
│  │     │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │     │  │  │  │  ├─ IssuerSecretKey
│  │     │  │  │  │  └─ a79cf8f18231f0a255617561f9c2c933f091f9503a348bbfb2d4065294ac4da4_sk
│  │     │  │  │  ├─ signcerts
│  │     │  │  │  └─ user
│  │     │  │  ├─ priv_sk
│  │     │  │  └─ tls-cert.pem
│  │     │  ├─ msp
│  │     │  │  ├─ admincerts
│  │     │  │  ├─ cacerts
│  │     │  │  │  └─ ca.ec.example.com-cert.pem
│  │     │  │  ├─ config.yaml
│  │     │  │  └─ tlscacerts
│  │     │  │     └─ tlsca.ec.example.com-cert.pem
│  │     │  ├─ peers
│  │     │  │  ├─ peer0.ec.example.com
│  │     │  │  │  ├─ msp
│  │     │  │  │  │  ├─ admincerts
│  │     │  │  │  │  ├─ cacerts
│  │     │  │  │  │  │  └─ ca.ec.example.com-cert.pem
│  │     │  │  │  │  ├─ config.yaml
│  │     │  │  │  │  ├─ keystore
│  │     │  │  │  │  │  └─ priv_sk
│  │     │  │  │  │  ├─ signcerts
│  │     │  │  │  │  │  └─ peer0.ec.example.com-cert.pem
│  │     │  │  │  │  └─ tlscacerts
│  │     │  │  │  │     └─ tlsca.ec.example.com-cert.pem
│  │     │  │  │  └─ tls
│  │     │  │  │     ├─ ca.crt
│  │     │  │  │     ├─ server.crt
│  │     │  │  │     └─ server.key
│  │     │  │  └─ peer1.ec.example.com
│  │     │  │     ├─ msp
│  │     │  │     │  ├─ admincerts
│  │     │  │     │  ├─ cacerts
│  │     │  │     │  │  └─ ca.ec.example.com-cert.pem
│  │     │  │     │  ├─ config.yaml
│  │     │  │     │  ├─ keystore
│  │     │  │     │  │  └─ priv_sk
│  │     │  │     │  ├─ signcerts
│  │     │  │     │  │  └─ peer1.ec.example.com-cert.pem
│  │     │  │     │  └─ tlscacerts
│  │     │  │     │     └─ tlsca.ec.example.com-cert.pem
│  │     │  │     └─ tls
│  │     │  │        ├─ ca.crt
│  │     │  │        ├─ server.crt
│  │     │  │        └─ server.key
│  │     │  ├─ tlsca
│  │     │  │  ├─ priv_sk
│  │     │  │  └─ tlsca.ec.example.com-cert.pem
│  │     │  └─ users
│  │     │     ├─ Admin@ec.example.com
│  │     │     │  ├─ msp
│  │     │     │  │  ├─ admincerts
│  │     │     │  │  ├─ cacerts
│  │     │     │  │  │  └─ ca.ec.example.com-cert.pem
│  │     │     │  │  ├─ config.yaml
│  │     │     │  │  ├─ keystore
│  │     │     │  │  │  └─ priv_sk
│  │     │     │  │  ├─ signcerts
│  │     │     │  │  │  └─ Admin@ec.example.com-cert.pem
│  │     │     │  │  └─ tlscacerts
│  │     │     │  │     └─ tlsca.ec.example.com-cert.pem
│  │     │     │  └─ tls
│  │     │     │     ├─ ca.crt
│  │     │     │     ├─ client.crt
│  │     │     │     └─ client.key
│  │     │     └─ User1@ec.example.com
│  │     │        ├─ msp
│  │     │        │  ├─ admincerts
│  │     │        │  ├─ cacerts
│  │     │        │  │  └─ ca.ec.example.com-cert.pem
│  │     │        │  ├─ config.yaml
│  │     │        │  ├─ keystore
│  │     │        │  │  └─ priv_sk
│  │     │        │  ├─ signcerts
│  │     │        │  │  └─ User1@ec.example.com-cert.pem
│  │     │        │  └─ tlscacerts
│  │     │        │     └─ tlsca.ec.example.com-cert.pem
│  │     │        └─ tls
│  │     │           ├─ ca.crt
│  │     │           ├─ client.crt
│  │     │           └─ client.key
│  │     └─ party.example.com
│  │        ├─ ca
│  │        │  ├─ IssuerPublicKey
│  │        │  ├─ IssuerRevocationPublicKey
│  │        │  ├─ ca-cert.pem
│  │        │  ├─ ca.party.example.com-cert.pem
│  │        │  ├─ fabric-ca-server-config.yaml
│  │        │  ├─ fabric-ca-server.db
│  │        │  ├─ msp
│  │        │  │  ├─ cacerts
│  │        │  │  ├─ keystore
│  │        │  │  │  ├─ 3a480396e4b4a7cded616397ac0b28196120047346cb5e13d4ea39f2dc460a89_sk
│  │        │  │  │  ├─ IssuerRevocationPrivateKey
│  │        │  │  │  ├─ IssuerSecretKey
│  │        │  │  │  └─ cf4bbe8e7ead4bc829fd7ed87f534f40a96baaaf7fd37a8c1f423ffa4b9bb4e2_sk
│  │        │  │  ├─ signcerts
│  │        │  │  └─ user
│  │        │  ├─ priv_sk
│  │        │  └─ tls-cert.pem
│  │        ├─ msp
│  │        │  ├─ admincerts
│  │        │  ├─ cacerts
│  │        │  │  └─ ca.party.example.com-cert.pem
│  │        │  ├─ config.yaml
│  │        │  └─ tlscacerts
│  │        │     └─ tlsca.party.example.com-cert.pem
│  │        ├─ peers
│  │        │  ├─ peer0.party.example.com
│  │        │  │  ├─ msp
│  │        │  │  │  ├─ admincerts
│  │        │  │  │  ├─ cacerts
│  │        │  │  │  │  └─ ca.party.example.com-cert.pem
│  │        │  │  │  ├─ config.yaml
│  │        │  │  │  ├─ keystore
│  │        │  │  │  │  └─ priv_sk
│  │        │  │  │  ├─ signcerts
│  │        │  │  │  │  └─ peer0.party.example.com-cert.pem
│  │        │  │  │  └─ tlscacerts
│  │        │  │  │     └─ tlsca.party.example.com-cert.pem
│  │        │  │  └─ tls
│  │        │  │     ├─ ca.crt
│  │        │  │     ├─ server.crt
│  │        │  │     └─ server.key
│  │        │  └─ peer1.party.example.com
│  │        │     ├─ msp
│  │        │     │  ├─ admincerts
│  │        │     │  ├─ cacerts
│  │        │     │  │  └─ ca.party.example.com-cert.pem
│  │        │     │  ├─ config.yaml
│  │        │     │  ├─ keystore
│  │        │     │  │  └─ priv_sk
│  │        │     │  ├─ signcerts
│  │        │     │  │  └─ peer1.party.example.com-cert.pem
│  │        │     │  └─ tlscacerts
│  │        │     │     └─ tlsca.party.example.com-cert.pem
│  │        │     └─ tls
│  │        │        ├─ ca.crt
│  │        │        ├─ server.crt
│  │        │        └─ server.key
│  │        ├─ tlsca
│  │        │  ├─ priv_sk
│  │        │  └─ tlsca.party.example.com-cert.pem
│  │        └─ users
│  │           ├─ Admin@party.example.com
│  │           │  ├─ msp
│  │           │  │  ├─ admincerts
│  │           │  │  ├─ cacerts
│  │           │  │  │  └─ ca.party.example.com-cert.pem
│  │           │  │  ├─ config.yaml
│  │           │  │  ├─ keystore
│  │           │  │  │  └─ priv_sk
│  │           │  │  ├─ signcerts
│  │           │  │  │  └─ Admin@party.example.com-cert.pem
│  │           │  │  └─ tlscacerts
│  │           │  │     └─ tlsca.party.example.com-cert.pem
│  │           │  └─ tls
│  │           │     ├─ ca.crt
│  │           │     ├─ client.crt
│  │           │     └─ client.key
│  │           └─ User1@party.example.com
│  │              ├─ msp
│  │              │  ├─ admincerts
│  │              │  ├─ cacerts
│  │              │  │  └─ ca.party.example.com-cert.pem
│  │              │  ├─ config.yaml
│  │              │  ├─ keystore
│  │              │  │  └─ priv_sk
│  │              │  ├─ signcerts
│  │              │  │  └─ User1@party.example.com-cert.pem
│  │              │  └─ tlscacerts
│  │              │     └─ tlsca.party.example.com-cert.pem
│  │              └─ tls
│  │                 ├─ ca.crt
│  │                 ├─ client.crt
│  │                 └─ client.key
│  ├─ docker-compose
│  │  ├─ config
│  │  │  └─ msp
│  │  │     └─ keystore
│  │  ├─ crypto-config
│  │  │  ├─ ca
│  │  │  │  ├─ IssuerPublicKey
│  │  │  │  ├─ IssuerRevocationPublicKey
│  │  │  │  ├─ ca-cert.pem
│  │  │  │  ├─ fabric-ca-server-config.yaml
│  │  │  │  ├─ fabric-ca-server.db
│  │  │  │  ├─ msp
│  │  │  │  │  ├─ cacerts
│  │  │  │  │  ├─ keystore
│  │  │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │  │  │  │  └─ IssuerSecretKey
│  │  │  │  │  ├─ signcerts
│  │  │  │  │  └─ user
│  │  │  │  └─ tls-cert.pem
│  │  │  ├─ ordererOrganizations
│  │  │  │  └─ example.com
│  │  │  │     └─ orderers
│  │  │  │        ├─ orderer1.example.com
│  │  │  │        │  ├─ msp
│  │  │  │        │  │  └─ keystore
│  │  │  │        │  └─ tls
│  │  │  │        ├─ orderer2.example.com
│  │  │  │        │  ├─ msp
│  │  │  │        │  │  └─ keystore
│  │  │  │        │  └─ tls
│  │  │  │        └─ orderer3.example.com
│  │  │  │           ├─ msp
│  │  │  │           │  └─ keystore
│  │  │  │           └─ tls
│  │  │  └─ peerOrganizations
│  │  │     ├─ audit.example.com
│  │  │     │  ├─ ca
│  │  │     │  │  ├─ IssuerPublicKey
│  │  │     │  │  ├─ IssuerRevocationPublicKey
│  │  │     │  │  ├─ ca-cert.pem
│  │  │     │  │  ├─ fabric-ca-server-config.yaml
│  │  │     │  │  ├─ fabric-ca-server.db
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  ├─ 5867f4596645da0de2b547113d3d47b07f2c1f25df32864c636322d8eda92184_sk
│  │  │     │  │  │  │  ├─ 5ca644cb1ae7d6c8490dc1e99189b7af778a8879f324ad15a8f08b9e82392df2_sk
│  │  │     │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │     │  │  │  │  └─ IssuerSecretKey
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  └─ user
│  │  │     │  │  └─ tls-cert.pem
│  │  │     │  └─ peers
│  │  │     │     └─ peer0.audit.example.com
│  │  │     │        ├─ msp
│  │  │     │        │  └─ keystore
│  │  │     │        └─ tls
│  │  │     ├─ ec.example.com
│  │  │     │  ├─ ca
│  │  │     │  │  ├─ IssuerPublicKey
│  │  │     │  │  ├─ IssuerRevocationPublicKey
│  │  │     │  │  ├─ ca-cert.pem
│  │  │     │  │  ├─ fabric-ca-server-config.yaml
│  │  │     │  │  ├─ fabric-ca-server.db
│  │  │     │  │  ├─ msp
│  │  │     │  │  │  ├─ cacerts
│  │  │     │  │  │  ├─ keystore
│  │  │     │  │  │  │  ├─ 6ec55194da3dfa0d2c6be75d599d033148cbae9a68cead6e1b33d56575e5790b_sk
│  │  │     │  │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │     │  │  │  │  ├─ IssuerSecretKey
│  │  │     │  │  │  │  └─ c91d12da51a602ccf65a50474fdafd4fd88eb9f6f9b83d916838a3dae067af2c_sk
│  │  │     │  │  │  ├─ signcerts
│  │  │     │  │  │  └─ user
│  │  │     │  │  └─ tls-cert.pem
│  │  │     │  └─ peers
│  │  │     │     ├─ peer0.ec.example.com
│  │  │     │     │  ├─ msp
│  │  │     │     │  │  └─ keystore
│  │  │     │     │  └─ tls
│  │  │     │     └─ peer1.ec.example.com
│  │  │     │        ├─ msp
│  │  │     │        │  └─ keystore
│  │  │     │        └─ tls
│  │  │     └─ party.example.com
│  │  │        ├─ ca
│  │  │        │  ├─ IssuerPublicKey
│  │  │        │  ├─ IssuerRevocationPublicKey
│  │  │        │  ├─ ca-cert.pem
│  │  │        │  ├─ fabric-ca-server-config.yaml
│  │  │        │  ├─ fabric-ca-server.db
│  │  │        │  ├─ msp
│  │  │        │  │  ├─ cacerts
│  │  │        │  │  ├─ keystore
│  │  │        │  │  │  ├─ 2fb518ab0c66cba610d8e18b09905c09e67e4b9bb2aaa9277b31d20f53fff47f_sk
│  │  │        │  │  │  ├─ IssuerRevocationPrivateKey
│  │  │        │  │  │  ├─ IssuerSecretKey
│  │  │        │  │  │  └─ bf1acc9ae5b4dfae3e72880908907914c8ad7eff0f02cb89d1d55d60370dd4ba_sk
│  │  │        │  │  ├─ signcerts
│  │  │        │  │  └─ user
│  │  │        │  └─ tls-cert.pem
│  │  │        └─ peers
│  │  │           ├─ peer0.party.example.com
│  │  │           │  ├─ msp
│  │  │           │  │  └─ keystore
│  │  │           │  └─ tls
│  │  │           └─ peer1.party.example.com
│  │  │              ├─ msp
│  │  │              │  └─ keystore
│  │  │              └─ tls
│  │  ├─ docker-compose-raft.yaml
│  │  ├─ docker-compose.yaml
│  │  └─ genesis.block
│  ├─ evoting-channel.tx
│  ├─ evoting.tar.gz
│  ├─ genesis.block
│  ├─ network-scripts
│  │  ├─ gen.sh
│  │  ├─ start-network.sh
│  │  ├─ stop-network.sh
│  │  └─ upgrade-to-raft.sh
│  ├─ set-peer-env.sh
│  ├─ show_failed_logs.sh
│  ├─ start-evoting-network.sh
│  └─ stop-evoting-network.sh
└─ evoting.tar.gz

```