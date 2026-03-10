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
- **Port forwarding** for local documentation server (port 8000)

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
