# Clique Network Starter Repository
This repository is intended to act as a boilerplate code to run a private Ethereum network using the Besu Hyperledger framework with the clique consensus protocol.

## System Requirements
 - JDK 17+

## How to start the network
### Genesis File
In order to start an Ethereum network, you must first define a genesis file. This file will define the starting parameters for your network, and will contain information about ethereum addresses that are allowed to seal nodes, and any ether that is allocated at the beginning of the network.
The first step is to generate ethereum addresses for the various nodes. This can be done by navigating to the desired node, deleting the `data` directory, and generating a new `data` directory with the following command
`besu --data-path=data public-key export-address --to=data/node{node number}Address`
This will generate a node address in the `data` directory with the filename you specified in the `--to` paramenter.
If this node is to be an authorized sealer, it must be included in the `extradata` key of the genesis file, preceeded by 64 `0`s and followed by 130 `0`s. Multiple adresses can be included to have mupliple sealer blocks, and the `0x` prefix must be removed.
If this node address is to have ether allocated to it, it should have its node address listed as a key within the `alloc` key, and the balance in wei listed as a `balance` key within the node address key, as show below:
```
        "4b6b1e182fbcdb34baaf69c921f714dbd557e77c": {
          "balance": "15000000000000000000000000000000"
        },
```
### Starting Nodes
In order to start your nodes, you must first generate node addresses for them as demonstrated in the Genesis File walkthrough.
Once you have generated your node addresses, you can use the `run.sh` script to start them.
This script accepts 7 parameters, and each must be supplied to ensure that your node runs properly. (enode URL does not need to be provided for the boot node, as the boot node enode url will be used for the rest of the nodes to connect to)
 - 1. Node number
    - This is a number between 1 and 8 that will determine which node to start.
 - 2. p2p host IP address
    - This is the externally facing IP address that you are starting your node with
 - 3. network ID
    - This is a unique network ID used to differentiate your network from other ethereum protocol networks
 - 4. p2p port number
    - This is the port number that you are exposing your node with
 - 5. rpc http port number
    - This is the port number that you are exposing for use with the Ethereum RPC HTTP API
 - 6. rpc enabled boolean
    - This indicates whether or not the Ethereum RPC API is enabled
 - 7. enode URL
    - This is the enode URL of the boot node that you are connecting to. Does not need to be supplied for   non boot nodes.
First, you must start the boot node. This is the node that will be used as a connection point for the rest of your nodes.
In order to start the boot node, run `run.sh` supplying `1` for the first parameter, your publicly facing IP address as the second parameter, and your network ID as the third parameter.
When the node starts, your terminal will show information regarding the starting parameters. Scan through the information to find the enode url, and copy it to a note pad. The enode url will have the following format:
`enode://c09d2463d0a3b9ff5f27c5652b79f93335fabbd63c5e637719c97cad981add577bc06452a3c8990764ec34b284d0e66697675a52ef034ab82247522c69736c83@157.230.66.223:30303`
Now that you have your boot node started, you can connect the rest of your nodes. This can be done by supplying the node number as the first parameter, your publicly facing IP address as the second parameter, your network ID as the third parameter, your p2p port number as the fourth parameter (boot node defaults to 30303, if you are running the nodes on the same device or server you must run it on another port than is being used by other nodes), your rpc http port number as the fifth parameter (boot node defaults to 8545, if you are running the nodes on the same device or server you must run it on another port than is being used by other nodes), the rpc enabled boolean as the sixth parameter, and your enode URL as the seventh parameter.