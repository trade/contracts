#!/bin/bash

# Sourcify verification script
# This script verifies contracts on Sourcify as an alternative to Etherscan verification

# Load environment variables
if [ -f .env ]; then
  source .env
fi

# Check if required arguments are provided
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <contract-address> <network> <contract-name>"
    echo "Example: $0 0x123... mainnet MultiChainToken"
    exit 1
fi

CONTRACT_ADDRESS=$1
NETWORK=$2
CONTRACT_NAME=$3

# Set up paths
OUT_DIR="./out"
METADATA_PATH=$(find "$OUT_DIR" -name "${CONTRACT_NAME}.json" -not -path "*/test/*" | head -n 1)

if [ -z "$METADATA_PATH" ]; then
    echo "Error: Could not find metadata for $CONTRACT_NAME. Make sure you've compiled the contracts."
    exit 1
fi

# Get chain ID from environment variables or use default mapping
CHAIN_ID_VAR="${NETWORK^^}_CHAIN_ID"
CHAIN_ID=${!CHAIN_ID_VAR}

# If not found in env, use default mapping
if [ -z "$CHAIN_ID" ]; then
    case "$NETWORK" in
        "mainnet") CHAIN_ID=1 ;;
        "sepolia") CHAIN_ID=11155111 ;;
        *) CHAIN_ID=$NETWORK ;;  # Assume network is already a chain ID
    esac
fi

echo "Using metadata from: $METADATA_PATH"
echo "Verifying contract $CONTRACT_NAME at address $CONTRACT_ADDRESS on $NETWORK (chain ID: $CHAIN_ID)..."

# Create verification request
curl -X POST \
    -F "address=$CONTRACT_ADDRESS" \
    -F "chain=$CHAIN_ID" \
    -F "files=@$METADATA_PATH" \
    "https://sourcify.dev/server/verify"

echo -e "\nVerification request sent to Sourcify. Check https://sourcify.dev/lookup/$CHAIN_ID/$CONTRACT_ADDRESS to confirm verification."