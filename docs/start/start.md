# 🚀 Start

```{toctree}
:maxdepth: 2
:hidden:
```

## Requirements

- The whole toolchain requires about 50 GB of disk space. Using only _OpenADStack_ without _OpenADSim_ will require significantly less.
- While some modules are built form `arm64` architectures (e.g. used in `NVIDIA Jetson Orin`), the complete toolchain is only supported on amd64.
- Thanks to consequent containerization, all operating systems supporting [Docker](https://www.docker.com/) should be finde. However, we test only on `Ubuntu 24.04`.
- Current installations of [Docker](https://docs.docker.com/engine/install/ubuntu/), [Docker Compose](https://docs.docker.com/compose/install/), the [NVIDIA driver](https://ubuntu.com/server/docs/how-to/graphics/install-nvidia-drivers/) and the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- NVIDIA GPU with at least 8 GB VRAM is recommended.
- Make sure your user is added to the `docker` group to be able to use Docker without root priviledges. This can be done with `sudo usermod -aG docker $USER`. This will be effective after a new login.
- Make sure your machine has access to its X server for graphical output, e.g. with `xhost +local:`

## Run OpenADStack using Recorded Data

- Clone `openadstack` repository
- Explore example data from real-world vehicles
- [Link](../openadstack/openadstack.md) to openadstack

## Simulate OpenADStack using OpenADSim

- Clone `openadsim` repository
- Start the simulation with the default setup
- Explore RViz and plan a custom route yourself
- [Links](../openadsim/openadsim.md) to documentation for advanced usage and development:
  - 🚘 Vehicles
  - 🗺️ Maps
  - 🎬 Scenario-based testing
  - Link to the openadsim documentation for detailed explanation about configuration options.
