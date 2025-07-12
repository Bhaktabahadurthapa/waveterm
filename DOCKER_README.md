# Docker Setup for Wave Terminal

This directory contains Docker and Docker Compose configurations for developing and deploying Wave Terminal in containerized environments.

## Quick Start

### Prerequisites

- Docker 20.10+ 
- Docker Compose 2.0+
- Git

### Development Environment

1. **Clone the repository**:
```bash
git clone https://github.com/wavetermdev/waveterm.git
cd waveterm
```

2. **Start the development environment**:
```bash
# Start all services
docker-compose up

# Or start specific services
docker-compose up waveterm-dev postgres
```

3. **Access the development container**:
```bash
# Interactive shell
docker-compose exec waveterm-dev bash

# Run specific commands
docker-compose exec waveterm-dev task dev
docker-compose exec waveterm-dev task storybook
```

## Available Services

### Development Services

| Service | Description | Port | URL |
|---------|-------------|------|-----|
| `waveterm-dev` | Main development environment | Multiple | N/A |
| `wavesrv` | Backend Go server | 8080, 8081 | http://localhost:8080 |
| `postgres` | Database | 5432 | N/A |
| `docs` | Documentation (Docusaurus) | 3001 | http://localhost:3001 |
| `storybook` | UI Component Library | 6006 | http://localhost:6006 |
| `builder` | Build environment | N/A | N/A |

### Production Services

Use `docker-compose.prod.yml` for production deployments:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## Docker Compose Files

### `docker-compose.yml`
Main development configuration with:
- All development services
- Volume mounts for hot reloading
- Debug configurations
- Database setup

### `docker-compose.override.yml`
Development-specific overrides:
- Development environment variables
- Debug logging
- Hot reload configurations

### `docker-compose.prod.yml`
Production configuration with:
- Optimized builds
- Health checks
- Restart policies
- Security configurations

## Usage Examples

### Development Workflow

```bash
# Start development environment
docker-compose up -d

# Access development container
docker-compose exec waveterm-dev bash

# Inside the container:
task dev          # Start development server
task storybook    # Start Storybook
task docsite      # Start documentation
task build        # Build the application
task package      # Package the application
```

### Building the Application

```bash
# Use the dedicated builder service
docker-compose run --rm builder

# Or build specific targets
docker-compose run --rm builder task build:backend
docker-compose run --rm builder task build:wsh
```

### Running Tests

```bash
# Run tests in development environment
docker-compose exec waveterm-dev yarn test

# Run Go tests
docker-compose exec waveterm-dev go test ./...
```

### Database Operations

```bash
# Access PostgreSQL
docker-compose exec postgres psql -U waveterm -d waveterm

# Run database migrations
docker-compose exec waveterm-dev task migrate

# Backup database
docker-compose exec postgres pg_dump -U waveterm waveterm > backup.sql
```

## Dockerfiles

### `docker/Dockerfile.dev`
Full development environment with:
- Ubuntu 24.04 base
- Go 1.23, Node.js 22
- Task, Zig, build tools
- Development utilities

### `docker/Dockerfile.backend`
Optimized backend service with:
- Multi-stage build
- Alpine Linux runtime
- Security hardening
- Health checks

### `docker/Dockerfile.docs`
Documentation service with:
- Node.js 22 Alpine
- Docusaurus build
- Production optimizations

### `docker/Dockerfile.storybook`
Component library service with:
- Node.js 22 Alpine
- Storybook build
- Development tools

### `docker/Dockerfile.builder`
Build environment with:
- All build dependencies
- Cross-compilation tools
- Package managers

## Configuration

### Environment Variables

Common environment variables:

```bash
# Development
NODE_ENV=development
WAVETERM_DEV_MODE=true
WAVETERM_LOG_LEVEL=debug

# Production
NODE_ENV=production
POSTGRES_PASSWORD=your-secure-password
WAVETERM_LOG_LEVEL=info

# Cloud endpoints
WCLOUD_ENDPOINT=https://api-dev.waveterm.dev/central
WCLOUD_WS_ENDPOINT=wss://wsapi-dev.waveterm.dev/
```

### Volume Mounts

Development volumes:
- Source code: `.:/workspace`
- Node modules: `node_modules:/workspace/node_modules`
- Go cache: `go_cache:/go/pkg/mod`
- Yarn cache: `yarn_cache:/home/developer/.yarn/cache`

Production volumes:
- Application data: `wavesrv_data:/data`
- Database data: `postgres_data:/var/lib/postgresql/data`

## Troubleshooting

### Common Issues

1. **Port conflicts**:
```bash
# Check what's using ports
lsof -i :3000
lsof -i :8080

# Use different ports
docker-compose up -p 3001:3000
```

2. **Permission issues**:
```bash
# Fix file permissions
sudo chown -R $USER:$USER .
docker-compose exec waveterm-dev chown -R developer:developer /workspace
```

3. **Container build failures**:
```bash
# Clean build cache
docker system prune -a
docker-compose build --no-cache
```

4. **Database connection issues**:
```bash
# Check database logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Debugging

```bash
# View logs
docker-compose logs -f waveterm-dev
docker-compose logs -f wavesrv

# Debug specific service
docker-compose exec waveterm-dev bash -c "cd /workspace && bash"

# Check service health
docker-compose ps
docker inspect waveterm-wavesrv
```

## Advanced Usage

### Multi-Stage Development

```bash
# Backend only
docker-compose up postgres wavesrv

# Frontend only
docker-compose up waveterm-dev

# Documentation only
docker-compose up docs storybook
```

### Custom Builds

```bash
# Build with specific Go version
docker-compose build --build-arg GO_VERSION=1.23.1 waveterm-dev

# Build with custom Node version
docker-compose build --build-arg NODE_VERSION=22.5.0 docs
```

### Production Deployment

```bash
# Production with custom environment
POSTGRES_PASSWORD=secure-password docker-compose -f docker-compose.prod.yml up -d

# With nginx reverse proxy
docker-compose -f docker-compose.prod.yml --profile nginx up -d
```

## Integration with CI/CD

### GitHub Actions

```yaml
name: Docker Build Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Test Docker build
        run: |
          docker-compose build
          docker-compose run --rm waveterm-dev task test
```

### Local Development Scripts

Create convenient scripts:

```bash
# dev.sh
#!/bin/bash
docker-compose up -d
docker-compose exec waveterm-dev task dev

# build.sh
#!/bin/bash
docker-compose run --rm builder
```

## Contributing

When contributing Docker configurations:

1. Test with both development and production configurations
2. Ensure all services start correctly
3. Verify volume mounts and permissions
4. Test health checks and dependencies
5. Update documentation

## Security Considerations

- Use non-root users in containers
- Implement proper secrets management
- Enable health checks
- Use multi-stage builds for smaller images
- Regularly update base images
- Scan images for vulnerabilities

## Performance Optimization

- Use `.dockerignore` to exclude unnecessary files
- Leverage build cache effectively
- Use multi-stage builds
- Optimize volume mounts
- Use proper resource limits

---

For more information, see the main [BUILD.md](BUILD.md) and [CONTRIBUTING.md](CONTRIBUTING.md) files.