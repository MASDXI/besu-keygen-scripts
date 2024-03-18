#!/bin/bash

# Function to check if input is a number
is_number() {
    [[ $1 =~ ^[0-9]+$ ]]
}

# Check if the count argument is provided and if it's a number
if [ $# -ne 1 ] || ! is_number "$1"; then
    echo "Usage: $0 <count>"
    exit 1
fi

# Parse the count argument
count=$1

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

# Clean up configuration file
rm -rf config.json