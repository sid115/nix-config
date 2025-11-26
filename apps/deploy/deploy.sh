#!/usr/bin/env bash

# defaults
FLAKE_URI="."
CONFIG_FILE="./deploy.json"
ACTION="switch"
DO_BUILD=true
USE_SUDO=true

# colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # no color

error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

help() {
    echo "Usage: $0 [OPTIONS] [ACTION]"
    echo ""
    echo "Arguments:"
    echo "  ACTION                 The activation mode (switch | boot | test)."
    echo "                         Default: switch"
    echo ""
    echo "Options:"
    echo "  -f, --flake URI        URI of the flake to build (default: $FLAKE_URI)"
    echo "  -c, --config FILE      Path to the JSON deployment config (default: $CONFIG_FILE)"
    echo "  --skip-build           Skip the explicit build-only step before deployment."
    echo "  --no-sudo              Do not pass to sudo related flags nixos-rebuild."
    echo "  -h, --help             Show this help message."
    echo ""
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        switch|boot|test)
            ACTION="$1"
            shift
            ;;
        -f|--flake)
            if [[ -n "$2" && "$2" != -* ]]; then
                FLAKE_URI="$2"
                shift 2
            else
                error "Argument for $1 is missing"
            fi
            ;;
        -c|--config)
            if [[ -n "$2" && "$2" != -* ]]; then
                CONFIG_FILE="$2"
                shift 2
            else
                error "Argument for $1 is missing"
            fi
            ;;
        --skip-build)
            DO_BUILD=false
            shift
            ;;
        --no-sudo)
            USE_SUDO=false
            shift
            ;;
        -h|--help|help)
            help
            exit 0
            ;;
        *)
            error "Invalid argument '$1'"
            ;;
    esac
done

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

SUDO_FLAGS=""
if [ "$USE_SUDO" = true ]; then
    SUDO_FLAGS="--sudo --ask-sudo-password"
fi

echo -e "Action:      ${GREEN}${ACTION}${NC}"
echo -e "Flake:       ${GREEN}${FLAKE_URI}${NC}"
echo -e "Builder:     ${GREEN}${BUILD_HOST}${NC}"
echo -e "Config:      ${CONFIG_FILE}"
echo -e "Targets:     ${HOSTS[*]}"

if [ "$DO_BUILD" = true ]; then
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
else
    echo -e "\n${BLUE}>>> Skipping explicit build step...${NC}"
fi

echo -e "\n${BLUE}>>> Deploying to targets...${NC}"
for host in "${HOSTS[@]}"; do
    echo -e "------------------------------------------------"
    echo -e "Deploying to: ${GREEN}${host}${NC}"
    
    if ! nixos-rebuild "$ACTION" \
        --flake "${FLAKE_URI}#${host}" \
        --build-host "$BUILD_HOST" \
        --target-host "${host}" \
        "$SUDO_FLAGS"; then
        error "Failed to verify/activate on ${host}. Aborting..."
    fi
    echo -e "${GREEN}Success: ${host} updated.${NC}"
done

echo -e "\n${GREEN}>>> Deployment complete${NC}"
