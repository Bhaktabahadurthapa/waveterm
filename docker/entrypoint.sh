#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🌊 Wave Terminal Development Environment${NC}"
echo -e "${YELLOW}Initializing development environment...${NC}"

# Initialize project dependencies if package.json exists
if [ -f "package.json" ]; then
    echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
    if [ ! -d "node_modules" ]; then
        yarn install
    fi
fi

# Initialize Go modules if go.mod exists
if [ -f "go.mod" ]; then
    echo -e "${YELLOW}Downloading Go dependencies...${NC}"
    go mod download
fi

# Initialize docs dependencies if docs/package.json exists
if [ -f "docs/package.json" ]; then
    echo -e "${YELLOW}Installing documentation dependencies...${NC}"
    cd docs
    if [ ! -d "node_modules" ]; then
        yarn install
    fi
    cd ..
fi

# Run Task init if Taskfile.yml exists
if [ -f "Taskfile.yml" ]; then
    echo -e "${YELLOW}Running task initialization...${NC}"
    task init || echo -e "${RED}Task init failed, continuing...${NC}"
fi

echo -e "${GREEN}✅ Development environment ready!${NC}"
echo -e "${YELLOW}Available commands:${NC}"
echo "  task dev         - Start development server with hot reload"
echo "  task build       - Build the application"
echo "  task storybook   - Start Storybook"
echo "  task docsite     - Start documentation site"
echo "  task package     - Package the application"
echo ""
echo -e "${YELLOW}Available services:${NC}"
echo "  http://localhost:3000  - Vite dev server"
echo "  http://localhost:6006  - Storybook"
echo "  http://localhost:3001  - Documentation"
echo "  http://localhost:8080  - wavesrv API"
echo ""

# Execute the command
exec "$@"