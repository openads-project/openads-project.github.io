# Development Container

This directory contains the configuration for a VS Code development container.

## Quick Start

1. Install [Docker](https://www.docker.com/products/docker-desktop) and [VS Code](https://code.visualstudio.com/)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Open this repository in VS Code
4. Click "Reopen in Container" when prompted (or use Command Palette: `Dev Containers: Reopen in Container`)

## Features

The development container includes:

- **Python 3.11** with all documentation dependencies pre-installed
- **VS Code extensions** for Python, Markdown, reStructuredText, and DrawIO
- **Git** and **GitHub CLI** for version control
- **Port publishing** for the local documentation server (port 8000), reachable from other computers on the local network

## Building Documentation

Once inside the container:

```bash
cd docs
make html
```

## Serving Documentation Locally

To view the documentation with live reload:

```bash
cd docs
python -m http.server 8000 --directory _build/html
```

Then open http://localhost:8000 in your browser.

The server is published on the host with `appPort`, so it is also reachable
from other computers on the same local network at `http://<host-ip>:8000`
(find the host's IP with `ip addr` / `ipconfig`). `python -m http.server`
already binds to all interfaces by default, so no extra flags are needed.
