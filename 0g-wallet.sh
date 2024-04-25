export WALLET_NAME="wallet"
evmosd keys add $WALLET_NAME
echo "0x$(evmosd debug addr $(evmosd keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"
