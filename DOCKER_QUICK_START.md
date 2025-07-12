# Docker Quick Start Guide 🐳

Get Wave Terminal running in Docker in under 5 minutes!

## Prerequisites

- Docker 20.10+ 
- Docker Compose 2.0+

## Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/wavetermdev/waveterm.git
cd waveterm

# Setup Docker environment
./scripts/docker-dev.sh setup
```

### 2. Start Development Environment

```bash
# Start all services
./scripts/docker-dev.sh dev

# Or use individual services
docker-compose up -d waveterm-dev postgres
```

### 3. Access Development Shell

```bash
# Open interactive shell
./scripts/docker-dev.sh shell

# Inside the container:
task dev          # Start development server
task storybook    # Start Storybook
task docsite      # Start documentation
```

## Available URLs

Once running, access these services:

- **Frontend Development**: http://localhost:3000
- **Backend API**: http://localhost:8080  
- **Documentation**: http://localhost:3001
- **Storybook**: http://localhost:6006
- **Database**: postgres://waveterm:waveterm@localhost:5432/waveterm

## Common Commands

```bash
# Development
./scripts/docker-dev.sh dev        # Start development environment
./scripts/docker-dev.sh shell      # Open development shell
./scripts/docker-dev.sh logs       # View logs
./scripts/docker-dev.sh status     # Check service status

# Building
./scripts/docker-dev.sh package    # Build packages
./scripts/docker-dev.sh build      # Build Docker images

# Cleanup
./scripts/docker-dev.sh down       # Stop services
./scripts/docker-dev.sh clean      # Clean up resources
```

## Development Workflow

1. **Start services**: `./scripts/docker-dev.sh dev`
2. **Open shell**: `./scripts/docker-dev.sh shell`
3. **Run task**: `task dev` (inside container)
4. **Edit code**: Changes are automatically synced
5. **View changes**: http://localhost:3000

## File Structure

```
waveterm/
├── docker-compose.yml              # Main development config
├── docker-compose.override.yml     # Development overrides
├── docker-compose.prod.yml         # Production config
├── docker/
│   ├── Dockerfile.dev              # Development environment
│   ├── Dockerfile.backend          # Backend service
│   ├── Dockerfile.docs             # Documentation
│   ├── Dockerfile.storybook        # Storybook
│   ├── Dockerfile.builder          # Build environment
│   ├── entrypoint.sh               # Development entrypoint
│   └── build-entrypoint.sh         # Build entrypoint
├── scripts/
│   └── docker-dev.sh               # Convenience script
├── .env.example                    # Environment variables
├── .dockerignore                   # Docker ignore file
├── Makefile.docker                 # Make integration
└── DOCKER_README.md               # Full documentation
```

## Troubleshooting

### Port Conflicts
```bash
# Check what's using ports
lsof -i :3000
lsof -i :8080

# Stop conflicting services
sudo service nginx stop
```

### Permission Issues
```bash
# Fix file permissions
sudo chown -R $USER:$USER .
```

### Build Issues
```bash
# Clean and rebuild
./scripts/docker-dev.sh clean
./scripts/docker-dev.sh setup
```

### Container Issues
```bash
# Restart containers
docker-compose restart

# View container logs
docker-compose logs waveterm-dev
```

## Production Deployment

For production use:

```bash
# Start production environment
docker-compose -f docker-compose.prod.yml up -d

# With custom password
POSTGRES_PASSWORD=secure-password docker-compose -f docker-compose.prod.yml up -d
```

## Integration with Existing Workflow

The Docker setup integrates with the existing Task system:

```bash
# Traditional way
task dev

# Docker way
./scripts/docker-dev.sh dev
docker-compose exec waveterm-dev task dev
```

## Next Steps

- Read the full [Docker Documentation](DOCKER_README.md)
- Check out the [Contributing Guide](CONTRIBUTING.md)
- Join the [Discord Community](https://discord.gg/XfvZ334gwU)

## Need Help?

- 📖 [Full Docker Documentation](DOCKER_README.md)
- 🐛 [GitHub Issues](https://github.com/wavetermdev/waveterm/issues)
- 💬 [Discord Community](https://discord.gg/XfvZ334gwU)
- 📚 [Build Documentation](BUILD.md)

---

Happy coding! 🚀