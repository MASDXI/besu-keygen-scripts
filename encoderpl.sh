#!/bin/bash

# Check if consensus type is provided (QBFT or IBFT)
if [ $# -ne 1 ] || ! [[ "$1" == "QBFT" || "$1" == "IBFT" ]]; then
  echo "Usage: $0 <QBFT|IBFT>"
  exit 1
fi

# Set the consensus type for RLP encoding
consensus_type="${1}_EXTRA_DATA"

# Ensure validators.json exists
if [ ! -f "accounts/validators.json" ]; then
  echo "Error: validators.json not found in the accounts directory."
  exit 1
fi

# Run the docker command to perform RLP encoding on the validators.json
sudo docker run -it --rm \
  -v $(pwd)/accounts:/temporary \
  hyperledger/besu:latest \
  rlp encode --from=/temporary/validators.json --to=/temporary/encode-validators.txt --type="$consensus_type"

# Inform user of completion
if [ $? -eq 0 ]; then
  echo "RLP encoding of validators.json to $consensus_type completed successfully."
else
  echo "Error occurred during RLP encoding."
fi
