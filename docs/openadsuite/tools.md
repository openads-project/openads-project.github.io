# Tools

OpenADSuite comprises tools for developing and deploying ROS 2 applications, working with recorded and live data, and providing common interfaces and data models.

> [!NOTE]
> Repositories tagged with 🔗 are not hosted in the [openads-project](https://github.com/openads-project/) GitHub organization.

## Development and Deployment

| Tool | Description | Teaser |
| --- | --- | --- |
| [openads_demo_module](https://github.com/openads-project/openads_demo_module) | Template for new OpenADS modules including the OpenADSuite development environment and CI/CD workflows as well as sample ROS 2 packages generated with [ros2-pkg-create](https://github.com/ika-rwth-aachen/ros2-pkg-create) |  |
| [ros2-pkg-create](https://github.com/ika-rwth-aachen/ros2-pkg-create) 🔗 | This tool is available in the provided base images and can be used to generate ROS 2 packages with different templates, e.g. for parameter loading, launch configurations, publishers/subscribers, services, action servers/clients, timers, diagnostics and more. | <img src="https://github.com/ika-rwth-aachen/ros2-pkg-create/raw/main/assets/cli.png" alt="Teaser" width="300"> |
| [openads-dev-environment](https://github.com/openads-project/openads-dev-environment) | Common development environment comprising default configurations of [Visual Studio Code](https://code.visualstudio.com/) for linting/formatting, development containers and debugging that works out-of-the-box. Additionally contains CI workflow descriptions, a README generator and consistency checks that enforce unified conventions across repositories. |  |
| [docker-ros](https://github.com/ika-rwth-aachen/docker-ros) 🔗 | The docker-ros GitHub/GitLab workflows automatically build development and deployment Docker images for your ROS-based repositories that include all specified dependencies. Also supports automated testing using the [industrial_ci](https://github.com/ros-industrial/industrial_ci) pipeline and creation of (minimal) slim deployment images. | <img src="https://github.com/ika-rwth-aachen/docker-ros/raw/main/assets/logo.png" alt="Icon" width="300"> |
| [docker-ros-ml-images](https://github.com/ika-rwth-aachen/docker-ros-ml-images) 🔗 | Provides several Docker images on [DockerHub](https://hub.docker.com/u/rwthika) including different combinations of `ROS` distros and different versions of `CUDA`, `TensorRT`, `Triton`, `PyTorch` and `TensorFlow`. These images can be used as base images in the [docker-ros](https://github.com/ika-rwth-aachen/docker-ros) containerization pipeline. |  |
| [docker-run](https://github.com/ika-rwth-aachen/docker-run) 🔗 | CLI tool for simplified interaction with Docker images. Use it to easily start and attach to Docker containers with useful predefined arguments, e.g. for graphical output | <img src="https://github.com/ika-rwth-aachen/docker-run/raw/main/assets/teaser.png" alt="Teaser" width="300"> |

## Data and Visualization

| Tool                                                           | Description                                                                                                                    | Teaser |
| -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ | ------ |
| [monitoring](https://github.com/openads-project/monitoring)    | Monitoring and visualization using [RViz](https://github.com/ros2/rviz), with support for message definitions used in OpenADS. |        |
| [ros2_unbag](https://github.com/ika-rwth-aachen/ros2_unbag) 🔗 | GUI and CLI tool for exporting topics from ROS 2 bag files to formats such as CSV, JSON, PCD, and images.                      | <img src="https://github.com/ika-rwth-aachen/ros2_unbag/raw/main/qt_resources/assets/badge.svg" alt="ros2 unbag badge" width="300"> |
| [ros2_unbag_plugins](https://github.com/openads-project/ros2_unbag_plugins) | OpenADSuite plugins for [ros2_unbag](https://github.com/ika-rwth-aachen/ros2_unbag), providing exports and integrations tailored to OpenADS workflows. | |

## Interfaces and Data Models

| Repository | Description | Teaser |
| --- | --- | --- |
| [perception_interfaces](https://github.com/ika-rwth-aachen/perception_interfaces) 🔗 | ROS packages with common messages and tools relating to the perception task in automated driving and C-ITS | <img src="https://github.com/ika-rwth-aachen/perception_interfaces/raw/main/assets/teaser.png" alt="Teaser" width="300"> |
| [planning_interfaces](https://github.com/ika-rwth-aachen/planning_interfaces) 🔗 | ROS packages with common messages and tools relating to the behavior planning task of automated vehicles | <img src="https://github.com/ika-rwth-aachen/planning_interfaces/raw/main/assets/teaser.png" alt="Teaser" width="300"> |
| [etsi_its_messages](https://github.com/ika-rwth-aachen/etsi_its_messages) 🔗 | ROS 2 Support for ETSI ITS Messages for V2X Communication | <img src="https://github.com/ika-rwth-aachen/etsi_its_messages/raw/main/assets/teaser.gif" alt="Teaser" width="300"> |
| [omega-prime](https://github.com/ika-rwth-aachen/omega-prime) 🔗 | Data Model, Format and Python Library for ground truth road traffic data containing information on dynamic objects, map and environmental factors optimized for representing urban traffic. |  |
