#!/usr/bin/env bash

FLAKE_URI="."
CONFIG_FILE="./deploy.json"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # no color

error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

help() {
    echo "Usage: $0 [ACTION]"
    echo ""
    echo "Arguments:"
    echo "  ACTION        The activation mode for the new configuration."
    echo "                Options: switch | boot | test"
    echo "                Default: switch"
}

INPUT_ARG="${1:-switch}"

case "$INPUT_ARG" in
    switch|boot|test)
        ACTION="$INPUT_ARG"
        ;;
    -h|--help|help)
        help
        exit 0
        ;;
    *)
        help
        error "Invalid action '${INPUT_ARG}'"
        ;;
esac

if [ "$EUID" -eq 0 ]; then
    error "Do not run this script with sudo."
fi

if ! command -v jq &> /dev/null; then
    error "jq is not installed."
fi

if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file '$CONFIG_FILE' not found."
fi

BUILD_HOST=$(jq -r '.buildHost' "$CONFIG_FILE")
mapfile -t HOSTS < <(jq -r '.hosts[]' "$CONFIG_FILE")

if [ ${#HOSTS[@]} -eq 0 ]; then
    error "No hosts defined in $CONFIG_FILE"
fi

echo -e "Action:      ${GREEN}${ACTION}${NC}"
echo -e "Builder:     ${GREEN}${BUILD_HOST}${NC}"
echo -e "Targets:     ${HOSTS[*]}"

echo -e "\n${BLUE}>>> Building configurations on remote builder...${NC}"

for host in "${HOSTS[@]}"; do
    echo -e "------------------------------------------------"
    echo -e "Building config for: ${GREEN}${host}${NC}"
    
    if ! nixos-rebuild build \
        --flake "${FLAKE_URI}#${host}" \
        --build-host "$BUILD_HOST"; then
        
        error "Build failed for host '${host}'. Aborting..."
    fi
done

echo -e "\n${BLUE}>>> Deploying to targets...${NC}"

for host in "${HOSTS[@]}"; do
    echo -e "------------------------------------------------"
    echo -e "Deploying to: ${GREEN}${host}${NC}"
    
    if ! nixos-rebuild "$ACTION" \
        --flake "${FLAKE_URI}#${host}" \
        --build-host "$BUILD_HOST" \
        --target-host "${host}" \
        --sudo \
        --ask-sudo-password; then
        
        error "Failed to verify/activate on ${host}"
    fi
    
    echo -e "${GREEN}Success: ${host} updated.${NC}"
done

echo -e "\n${GREEN}>>> Deployment complete${NC}"
