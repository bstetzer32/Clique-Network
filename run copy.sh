#!/bin/bash
BESU=../besu/bin/besu
TEMP=$(getopt -o --long node:,p2p-host:,p2p-port:,rpc-http-port:,rpc-enabled,enode-url: \
              -n 'clique network' -- "$@")
# echo "opts $TEMP"
eval set -- "$TEMP"
# echo $1
if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
NODE=
P2P_HOST=127.0.0.1
P2P_PORT=30303
RPC_HTTP_PORT=8545
RPC_ENABLED=false
ENODE_URL=
echo $@
while true; do
  case "$1" in
    --node ) NODE="Node-$2"; shift 2 ;;
    --p2p-host ) P2P_HOST="$2"; shift 2 ;;
    --p2p-port ) P2P_PORT="$2"; shift 2 ;;
    --rpc-http-port ) RPC_HTTP_PORT="$2"; shift 2 ;;
    --rpc-enabled ) RPC_ENABLED=true; shift ;;
    --enode-url ) ENODE_URL="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
echo "$NODE"
# P2P_HOST=${P2P_HOST:-127.0.0.1}
# P2P_PORT=${P2P_PORT:-30303}
# RPC_HTTP_PORT=${RPC_HTTP_PORT:-8545}
# RPC_ENABLED=${RPC_ENABLED:-true}
# ENODE_URL=${ENODE_URL:-enode://c09d2463d0a3b9ff5f27c5652b79f93335fabbd63c5e637719c97cad981add577bc06452a3c8990764ec34b284d0e66697675a52ef034ab82247522c69736c83@157.230.66.223:30303}
boot ()
{
  cd $NODE
  $BESU --data-path=data --genesis-file=../cliqueGenesis.json --network-id 422 --rpc-http-enabled=$RPC_ENABLED --rpc-http-api=ETH,NET,CLIQUE --host-allowlist="*" --rpc-http-cors-origins="all" --p2p-host=$P2P_HOST --rpc-http-port=$RPC_HTTP_PORT --p2p-port=$P2P_PORT
}

seal ()
{
  cd $NODE
  $BESU --data-path=data --genesis-file=../cliqueGenesis.json --bootnodes=$ENODE_URL --network-id 422 --p2p-port=$P2P_PORT --rpc-http-enabled=$RPC_ENABLED --rpc-http-api=ETH,NET,CLIQUE --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=$RPC_HTTP_PORT --p2p-host=$P2P_HOST
}
if [ $NODE != "Node-1" ];
then
  seal
else
  boot
fi
