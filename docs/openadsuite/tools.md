# Tools

OpenADSuite comprises tools for [Development](#development), [monitoring](#monitoring), and common [interfaces](#interfaces).

> [!NOTE]
> Repositories tagged with 🔗 are not hosted in the [openads-project](https://github.com/openads-project/) GitHub organization

## Development

| Tool | Description | Teaser |
| --- | --- | --- |
| [openads_demo_module](https://github.com/openads-project/openads_demo_module) | Template for new OpenADS modules including the OpenADSuite development environment and CI/CD workflows as well as sample ROS 2 packages generated with [ros2-pkg-create](https://github.com/ika-rwth-aachen/ros2-pkg-create) |  |
| [ros2-pkg-create](https://github.com/ika-rwth-aachen/ros2-pkg-create) 🔗 | This tool is available in the provided base images and can be used to generate ROS 2 packages with different templates, e.g. for parameter loading, launch configurations, publishers/subscribers, services, action servers/clients, timers, diagnostics and more. | ![Teaser](https://github.com/ika-rwth-aachen/ros2-pkg-create/raw/main/assets/cli.png){ width=300px } |
| [openads-dev-environment](https://github.com/openads-project/openads-dev-environment) | Common development environment comprising default configurations of [Visual Studio Code](https://code.visualstudio.com/) for linting/formatting, development containers and debugging that works out-of-the-box. Additionally contains CI workflow descriptions, a README generator and consistency checks that enforce unified conventions across repositories. |  |
| [docker-ros](https://github.com/ika-rwth-aachen/docker-ros) 🔗 | The docker-ros GitHub/GitLab workflows automatically build development and deployment Docker images for your ROS-based repositories that include all specified dependencies. Also supports automated testing using the [industrial_ci](https://github.com/ros-industrial/industrial_ci) pipeline and creation of (minimal) slim deployment images. | ![Icon](https://github.com/ika-rwth-aachen/docker-ros/raw/main/assets/logo.png){ width=300px } |
| [docker-ros-ml-images](https://github.com/ika-rwth-aachen/docker-ros-ml-images) 🔗 | Provides several Docker images on [DockerHub](https://hub.docker.com/u/rwthika) including different combinations of `ROS` distros and different versions of `CUDA`, `TensorRT`, `Triton`, `PyTorch` and `TensorFlow`. These images can be used as base images in the [docker-ros](https://github.com/ika-rwth-aachen/docker-ros) containerization pipeline. |  |
| [docker-run](https://github.com/ika-rwth-aachen/docker-run) 🔗 | CLI tool for simplified interaction with Docker images. Use it to easily start and attach to Docker containers with useful predefined arguments, e.g. for graphical output | ![Teaser](https://github.com/ika-rwth-aachen/docker-run/raw/main/assets/teaser.png){ width=300px } |

## Monitoring

| Tool | Description | Teaser |
| --- | --- | --- |
| [monitoring](https://github.com/openads-project/monitoring) | Monitoring and visualization using [RViz](https://github.com/ros2/rviz), a native ROS 2 tool, with support for message definitions used in OpenADS. |  |

## Interfaces

| Interface Repository | Description | Teaser |
| --- | --- | --- |
| [perception_interfaces](https://github.com/ika-rwth-aachen/perception_interfaces) 🔗 | ROS packages with common messages and tools relating to the perception task in automated driving and C-ITS | ![Teaser](https://github.com/ika-rwth-aachen/perception_interfaces/raw/main/assets/teaser.png){ width=300px } |
| [planning_interfaces](https://github.com/ika-rwth-aachen/planning_interfaces) 🔗 | ROS packages with common messages and tools relating to the behavior planning task of automated vehicles | ![Teaser](https://github.com/ika-rwth-aachen/planning_interfaces/raw/main/assets/teaser.png){ width=300px } |
| [etsi_its_messages](https://github.com/ika-rwth-aachen/etsi_its_messages) 🔗 | ROS 2 Support for ETSI ITS Messages for V2X Communication | ![Teaser](https://github.com/ika-rwth-aachen/etsi_its_messages/raw/main/assets/teaser.gif){ width=300px } |
| [omega-prime](https://github.com/ika-rwth-aachen/omega-prime) 🔗 | Data Model, Format and Python Library for ground truth road traffic data containing information on dynamic objects, map and environmental factors optimized for representing urban traffic. |  |
