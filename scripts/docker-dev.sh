#!/bin/bash

# Wave Terminal Docker Development Script
# This script provides convenient commands for Docker-based development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Change to project directory
cd "$PROJECT_DIR"

# Functions
print_usage() {
    echo -e "${BLUE}Wave Terminal Docker Development Script${NC}"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  setup         - Set up Docker environment"
    echo "  up            - Start all development services"
    echo "  dev           - Start development environment"
    echo "  down          - Stop all services"
    echo "  build         - Build all Docker images"
    echo "  rebuild       - Rebuild Docker images from scratch"
    echo "  shell         - Open shell in development container"
    echo "  logs          - Show logs for all services"
    echo "  status        - Show status of all services"
    echo "  clean         - Clean up Docker resources"
    echo "  package       - Build packages using Docker"
    echo "  docs          - Start documentation server"
    echo "  storybook     - Start Storybook server"
    echo "  test          - Run tests in Docker"
    echo "  prod          - Start production environment"
    echo ""
    echo "Examples:"
    echo "  $0 setup      # Initial setup"
    echo "  $0 dev        # Start development"
    echo "  $0 shell      # Open development shell"
    echo "  $0 package    # Build packages"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}Docker Compose is not installed. Please install Docker Compose first.${NC}"
        exit 1
    fi
}

setup() {
    echo -e "${YELLOW}Setting up Docker environment for Wave Terminal...${NC}"
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        echo -e "${RED}Docker is not running. Please start Docker first.${NC}"
        exit 1
    fi
    
    # Build images
    echo -e "${YELLOW}Building Docker images...${NC}"
    docker-compose build
    
    # Create volumes
    echo -e "${YELLOW}Creating volumes...${NC}"
    docker volume create waveterm_node_modules 2>/dev/null || true
    docker volume create waveterm_go_cache 2>/dev/null || true
    docker volume create waveterm_yarn_cache 2>/dev/null || true
    
    echo -e "${GREEN}✅ Docker environment setup complete!${NC}"
    echo -e "${YELLOW}You can now run: $0 dev${NC}"
}

dev() {
    echo -e "${YELLOW}Starting Wave Terminal development environment...${NC}"
    docker-compose up -d
    
    echo -e "${GREEN}✅ Development environment started!${NC}"
    echo -e "${YELLOW}Available services:${NC}"
    echo "  - Development container: docker-compose exec waveterm-dev bash"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Backend: http://localhost:8080"
    echo "  - Documentation: http://localhost:3001"
    echo "  - Storybook: http://localhost:6006"
    echo ""
    echo -e "${YELLOW}To access the development shell, run: $0 shell${NC}"
}

shell() {
    echo -e "${YELLOW}Opening development shell...${NC}"
    docker-compose exec waveterm-dev bash
}

package() {
    echo -e "${YELLOW}Building packages using Docker builder...${NC}"
    docker-compose run --rm builder
    
    echo -e "${GREEN}✅ Package build complete!${NC}"
    echo -e "${YELLOW}Check the 'make' directory for build artifacts.${NC}"
}

prod() {
    echo -e "${YELLOW}Starting production environment...${NC}"
    docker-compose -f docker-compose.prod.yml up -d
    
    echo -e "${GREEN}✅ Production environment started!${NC}"
    echo -e "${YELLOW}Available services:${NC}"
    echo "  - Backend: http://localhost:8080"
    echo "  - Documentation: http://localhost:3001"
    echo "  - Storybook: http://localhost:6006"
}

clean() {
    echo -e "${YELLOW}Cleaning up Docker resources...${NC}"
    
    # Stop and remove containers
    docker-compose down -v
    
    # Remove images
    docker-compose down --rmi all 2>/dev/null || true
    
    # Clean up build cache
    docker system prune -f
    
    echo -e "${GREEN}✅ Docker cleanup complete!${NC}"
}

# Main script logic
check_docker

case "${1:-}" in
    setup)
        setup
        ;;
    up)
        docker-compose up -d
        ;;
    dev)
        dev
        ;;
    down)
        docker-compose down
        ;;
    build)
        docker-compose build
        ;;
    rebuild)
        docker-compose build --no-cache
        ;;
    shell)
        shell
        ;;
    logs)
        docker-compose logs -f
        ;;
    status)
        docker-compose ps
        ;;
    clean)
        clean
        ;;
    package)
        package
        ;;
    docs)
        echo -e "${YELLOW}Starting documentation server...${NC}"
        docker-compose up -d docs
        echo -e "${GREEN}Documentation available at: http://localhost:3001${NC}"
        ;;
    storybook)
        echo -e "${YELLOW}Starting Storybook server...${NC}"
        docker-compose up -d storybook
        echo -e "${GREEN}Storybook available at: http://localhost:6006${NC}"
        ;;
    test)
        echo -e "${YELLOW}Running tests in Docker...${NC}"
        docker-compose exec waveterm-dev yarn test
        ;;
    prod)
        prod
        ;;
    help|--help|-h)
        print_usage
        ;;
    "")
        print_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        echo ""
        print_usage
        exit 1
        ;;
esac