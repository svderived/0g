#!/bin/bash

# Update server and install dependencies
sudo apt update && \
sudo apt install curl git jq build-essential gcc unzip wget lz4 -y

# Install Golang
cd $HOME
ver="1.21.3"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

# Install evmosd binary
wget https://rpc-zero-gravity-testnet.trusted-point.com/evmosd
chmod +x ./evmosd
mv ./evmosd /usr/local/bin/
evmosd version


# Set variables
echo 'export MONIKER="My_Node"' >> ~/.bash_profile
echo 'export CHAIN_ID="zgtendermint_9000-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
source $HOME/.bash_profile

# Initialize the node
cd $HOME
evmosd init $MONIKER --chain-id $CHAIN_ID
evmosd config chain-id $CHAIN_ID
evmosd config node tcp://localhost:$RPC_PORT
evmosd config keyring-backend os

# Install current release
wget https://rpc-zero-gravity-testnet.trusted-point.com/genesis.json -O $HOME/.evmosd/config/genesis.json

# Configure config.tomPEERS="1248487ea585730cdf5d3c32e0c2a43ad0cda973@peer-zero-gravity-testnet.trusted-point.com:26326"
SEEDS="8c01665f88896bca44e8902a30e4278bed08033f@54.241.167.190:26656,b288e8b37f4b0dbd9a03e8ce926cd9c801aacf27@54.176.175.48:26656,8e20e8e88d504e67c7a3a58c2ea31d965aa2a890@54.193.250.204:26656,e50ac888b35175bfd4f999697bdeb5b7b52bfc06@54.215.187.94:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.evmosd/config/config.toml

# Set minimum price
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00252aevmos\"/" $HOME/.evmosd/config/app.toml

# Create a service file
sudo tee /etc/systemd/system/ogd.service > /dev/null <<EOF
[Unit]
Description=OG Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which evmosd) start --home $HOME/.evmosd
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Start node
#sudo systemctl daemon-reload
#sudo systemctl enable ogd
#sudo systemctl restart ogd
#sudo journalctl -u ogd -f -o cat

# Wait for logs with Ctrl+C to exit
# Make a pause until our node is synchronized
# To check the status:
# evmosd status | jq .SyncInfo

# Create the validator:
# Create a wallet for our validator:
# evmosd keys add $WALLET_NAME
# You may also import an existing wallet:
# evmosd keys add $WALLET_NAME --recover
