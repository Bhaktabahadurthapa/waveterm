#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🏗️  Wave Terminal Builder Environment${NC}"
echo -e "${YELLOW}Initializing build environment...${NC}"

# Initialize project dependencies
if [ -f "package.json" ]; then
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    yarn install
fi

# Initialize Go modules
if [ -f "go.mod" ]; then
    echo -e "${YELLOW}Downloading Go dependencies...${NC}"
    go mod download
fi

# Initialize docs dependencies
if [ -f "docs/package.json" ]; then
    echo -e "${YELLOW}Installing documentation dependencies...${NC}"
    cd docs
    yarn install
    cd ..
fi

# Run Task init
if [ -f "Taskfile.yml" ]; then
    echo -e "${YELLOW}Running task initialization...${NC}"
    task init || echo -e "${RED}Task init failed, continuing...${NC}"
fi

# Clean previous builds
echo -e "${YELLOW}Cleaning previous builds...${NC}"
rm -rf make/ dist/ || true

echo -e "${GREEN}✅ Build environment ready!${NC}"
echo -e "${YELLOW}Starting build process...${NC}"

# Execute the build command
exec "$@"