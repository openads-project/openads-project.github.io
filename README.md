# Open Automated Driving Systems - Documentation

> This project is currently under construction

The full documentation is available at [GitHub Pages](https://oads-org.github.io).

## Local Development

### Option 1: Using Dev Container (Recommended)

The easiest way to develop locally is using the VS Code Dev Container:

1. Install [Docker](https://www.docker.com/products/docker-desktop) and [VS Code](https://code.visualstudio.com/)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Open this repository in VS Code
4. Click "Reopen in Container" when prompted

All dependencies will be automatically installed. See [`.devcontainer/README.md`](.devcontainer/README.md) for more details.

### Option 2: Manual Setup

To build the documentation locally without Docker:

```bash
# Install dependencies
pip install -r docs/requirements.txt

# Build the documentation
cd docs
sphinx-build -b html . _build/html

# View the documentation
# Open docs/_build/html/index.html in your browser
```
