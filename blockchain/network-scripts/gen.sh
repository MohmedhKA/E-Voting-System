#!/bin/bash

source ~/.bashrc
# Should now see successful leader election
docker logs orderer1.example.com | grep -i "leader\|elected"
docker logs orderer2.example.com | grep -i "leader\|elected"  
docker logs orderer3.example.com | grep -i "leader\|elected"
