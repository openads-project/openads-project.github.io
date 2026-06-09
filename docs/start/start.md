# 🚀 Start

```{toctree}
:maxdepth: 2
:hidden:
```

## Requirements

- The whole toolchain requires about 50 GB of disk space. Using only *OpenADStack* without *OpenADSim* will require significantly less.
- While some modules are built for `arm64` architectures (e.g. used in *NVIDIA Jetson Orin*), the complete toolchain is only supported on `amd64`.
- Thanks to consequent containerization, all operating systems supporting [Docker](https://www.docker.com/) should be fine. However, we currently test only on `Ubuntu 24.04`.
- Current installations of [Docker](https://docs.docker.com/engine/install/ubuntu/), [Docker Compose](https://docs.docker.com/compose/install/), the [NVIDIA driver](https://ubuntu.com/server/docs/how-to/graphics/install-nvidia-drivers/) and the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) are required.
- NVIDIA GPU with at least 8 GB VRAM is recommended.
- Make sure your user is added to the `docker` group to be able to use Docker without root priviledges. This can be done with `sudo usermod -aG docker $USER`, which  will be effective after a new login.
- Make sure to allow local connections to the X server to enable graphical output from Docker containers, e.g. with `xhost +local:`.
- The development environment is based on [Visual Studio Code](https://code.visualstudio.com/) with [Remote Development Extension Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack).

## Running OpenADStack on recorded data

Clone the [OpenADStack](https://github.com/openads-project/openadstack) repository and start the provided docker composition. This will pull the required Docker images and run the stack on recorded sensor data.

TODO: add screenshot

```bash
git clone --recursive https://github.com/openads-project/openadstack.git
cd openadstack
docker compose up
```

The execution can be stopped with `CTRL-C`. Chekout the [OpenADStack](../openadstack/openadstack.md) section for more information.

## Closed-loop simulation with OpenADSim

Clone the [OpenADSim](https://github.com/openads-project/openadsim) repository and start the provided docker composition. This will pull the required Docker images and run the stack in CARLA simulation.

TODO: add screenshot

```bash
git clone --recursive https://github.com/openads-project/openadsim.git
cd openadsim
docker compose up
```

The execution can be stopped with `CTRL-C`. Chekout the [OpenADSim](../openadsim/openadsim.md) section for more information.
