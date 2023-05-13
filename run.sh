#!/bin/bash
BESU=../besu/bin/besu
NODE=Node-$1
P2P_HOST=$2
NETWORK_ID=$3
P2P_PORT=$4
RPC_HTTP_PORT=$5
RPC_ENABLED=$6
ENODE_URL=$7
P2P_HOST=${P2P_HOST:-127.0.0.1}
P2P_PORT=${P2P_PORT:-30303}
RPC_HTTP_PORT=${RPC_HTTP_PORT:-8545}
RPC_ENABLED=${RPC_ENABLED:-true}
NETWORK_ID=${NETWORK_ID:-422}
ENODE_URL=${ENODE_URL:-enode://c09d2463d0a3b9ff5f27c5652b79f93335fabbd63c5e637719c97cad981add577bc06452a3c8990764ec34b284d0e66697675a52ef034ab82247522c69736c83@157.230.66.223:30303}
boot ()
{
  cd Node-1
  $BESU --data-path=data --genesis-file=../cliqueGenesis.json --network-id $NETWORK_ID --rpc-http-enabled=$RPC_ENABLED --rpc-http-api=ETH,NET,CLIQUE --host-allowlist="*" --rpc-http-cors-origins="all" --p2p-host=$P2P_HOST --rpc-http-port=$RPC_HTTP_PORT --p2p-port=$P2P_PORT
}

seal ()
{
  cd $NODE
  $BESU --data-path=data --genesis-file=../cliqueGenesis.json --bootnodes=$ENODE_URL --network-id $NETWORK_ID --p2p-port=$P2P_PORT --rpc-http-enabled=$RPC_ENABLED --rpc-http-api=ETH,NET,CLIQUE --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=$RPC_HTTP_PORT --p2p-host=$P2P_HOST
}
if [ $1 -gt 1 ]
then
  seal
else
  boot
fi

