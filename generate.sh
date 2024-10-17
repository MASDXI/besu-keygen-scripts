#!/bin/bash

# Function to check if input is a number
is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}

# Check if the count argument and algorithm are provided
if [ $# -ne 2 ] || ! is_number "$1" || ! [[ "$2" == "QBFT" || "$2" == "IBFT" ]]; then
    echo "Usage: $0 <count> <QBFT|IBFT>"
    exit 1
fi

# Parse the count argument and algorithm
count=$1
algorithm=$2

# Generate the JSON content
json_content=$(cat <<EOF
{
    "blockchain": {
        "nodes": {
            "generate": true,
            "count": $count
        }
    }
}
EOF
)

# Write the JSON content to a file
echo "$json_content" > config.json

echo "JSON file generated with $count nodes."

# Generate Key from Hyperledger Besu Container
sudo docker run -it --rm \
  -v $(pwd):/temporary \
  hyperledger/besu:latest \
  operator generate-blockchain-config \
    --config-file=/temporary/config.json \
    --to=/temporary/accounts/ \
    --private-key-file-name=key

# Encode Recursive-length prefix (RLP) serialization for extra data in genesis
base_dir="accounts/keys"

# Check if the base directory exists
if [ ! -d "$base_dir" ]; then
  echo "Error: Directory $base_dir does not exist."
  exit 1
fi

# Get the list of folder names (assumed to be Ethereum addresses) in accounts/keys
folders=$(ls -d $base_dir/*/ | xargs -n 1 basename)

# Check if any folders were found
if [ -z "$folders" ]; then
  echo "No address folders found in $base_dir."
  exit 1
fi

# Create JSON content with the folder names (Ethereum addresses)
json_content=$(cat <<EOF
[ 
$(for folder in $folders; do echo "        \"${folder#0x}\","; done | sed '$ s/,$//')
]
EOF
)

# Write the JSON content to a file
echo "$json_content" > accounts/validators.json
echo "Ethereum addresses have been written to validators.json."

# Clean up configuration file
rm -rf config.json

# Pass algorithm to encoderpl.sh
./encoderpl.sh "$algorithm"
