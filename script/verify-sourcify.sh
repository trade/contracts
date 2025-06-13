#!/bin/bash

# Automated Sourcify verification script for CI/CD pipelines
# This script verifies all deployed contracts on Sourcify

# Load environment variables
if [ -f .env ]; then
  source .env
fi

# Check if deployment file exists
DEPLOYMENT_FILE="./deployments/deployed-contracts.json"
if [ ! -f "$DEPLOYMENT_FILE" ]; then
    echo "Error: Deployment file not found at $DEPLOYMENT_FILE"
    exit 1
fi

# Read deployment data
DEPLOYMENTS=$(cat "$DEPLOYMENT_FILE")

# Function to verify a contract
verify_contract() {
    local address=$1
    local network=$2
    local contract_name=$3
    
    echo "Verifying $contract_name at $address on $network..."
    ./sourcify.sh "$address" "$network" "$contract_name"
    
    # Check verification status
    local status=$?
    if [ $status -eq 0 ]; then
        echo "✅ $contract_name successfully verified on Sourcify"
    else
        echo "❌ Failed to verify $contract_name on Sourcify"
        FAILED_VERIFICATIONS+=("$contract_name at $address on $network")
    fi
}

# Track failed verifications
FAILED_VERIFICATIONS=()

# Extract and verify each contract
for row in $(echo "${DEPLOYMENTS}" | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    
    ADDRESS=$(_jq '.address')
    NETWORK=$(_jq '.network')
    CONTRACT=$(_jq '.contract')
    
    verify_contract "$ADDRESS" "$NETWORK" "$CONTRACT"
done

# Report results
echo ""
echo "Sourcify Verification Summary:"
echo "============================"
if [ ${#FAILED_VERIFICATIONS[@]} -eq 0 ]; then
    echo "✅ All contracts successfully verified on Sourcify!"
else
    echo "❌ Some verifications failed:"
    for failure in "${FAILED_VERIFICATIONS[@]}"; do
        echo "  - $failure"
    done
    exit 1
fi