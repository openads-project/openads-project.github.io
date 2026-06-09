# Tools

OpenADSuite comprises tools for [DevOps](#devops), common [interfaces](#interfaces) and [monitoring](#monitoring).

> Repositories tagged with 🔗 are not hosted in the [openads-project](https://github.com/openads-project/) GitHub organization

## DevOps

### OpenADS Module Template

[`openads_demo_module`](https://github.com/openads-project/openads_demo_module)

Template for new OpenADS modules including the OpenADSuite development environment and CI/CD workflows as well as sample ROS 2 packages generated with [ros2-pkg-create](https://github.com/ika-rwth-aachen/ros2-pkg-create).

### Common development environment for OpenADS modules

[`openads-dev-environment`](https://github.com/openads-project/openads-dev-environment)

Common development environment comprising default configurations of [Visual Studio Code](https://code.visualstudio.com/) for linting/formatting, development containers and debugging that works out-of-the-box. Additionally contains CI workflow descriptions, a README generator and consistency checks that enforce unified conventions across repositories.

### Automated containerization of ROS modules

[`docker-ros`](https://github.com/ika-rwth-aachen/docker-ros) 🔗

The docker-ros GitHub/GitLab workflows automatically build development and deployment Docker images for your ROS-based repositories that include all specified dependencies. Also supports automated testing using the [industrial_ci](https://github.com/ros-industrial/industrial_ci) pipeline and creation of (minimal) slim deployment images.

### Machine Learning-enabled ROS Docker Images

[`docker-ros-ml-images`](https://github.com/ika-rwth-aachen/docker-ros-ml-images) 🔗

Provides several Docker images on [DockerHub](https://hub.docker.com/u/rwthika) including different combinations of `ROS` distros and different versions of `CUDA`, `TensorRT`, `Triton`, `PyTorch` and `TensorFlow`. These images can be used as base images in the [docker-ros](https://github.com/ika-rwth-aachen/docker-ros) containerization pipeline.

### Powerful ROS 2 Package Generator

[`ros2-pkg-create`](https://github.com/ika-rwth-aachen/ros2-pkg-create) 🔗

This tool is available in the provided base images and can be used to generate ROS 2 packages with different templates, e.g. for parameter loading, launch configurations, publishers/subscribers, services, action servers/clients, timers, diagnostics and more.

## Interfaces

### Common perception message definitions and tools

[`perception_interfaces`](https://github.com/ika-rwth-aachen/perception_interfaces) 🔗

Provides extensible ROS message definitions for the perception task in Cooperative Intelligent Transport Systems. It follows a "code-first" approach and provides tools for easy data access, coordinate transformations and data visualization.

### Common planning message definitions and tools

[`planning_interfaces`](https://github.com/ika-rwth-aachen/planning_interfaces) 🔗

Provides extensible ROS message definitions for the planning task in Cooperative Intelligent Transport Systems. It follows a "code-first" approach and provides tools for easy data access, coordinate transformations and data visualization.

### ROS 2 Support for ETSI ITS messages for V2X Communication

[`etsi_its_messages`](https://github.com/ika-rwth-aachen/etsi_its_messages) 🔗

ROS message definitions for V2X applications (e.g. `CAM`, `CPM`, `DENM`, `MAPEM`, `SPATEM`) generated from the `ASN.1` files officially published by the [European Telecommunications Standards Institute](https://forge.etsi.org/rep/ITS/asn1)

## Monitoring

### Monitoring and Visualization using native ROS tools

[`rviz-monitoring`](https://github.com/openads-project/rviz-monitoring)

Monitoring and visualization using [RViz](https://github.com/ros2/rviz), a native ROS 2 tool, with support for message definitions used in OpenADS.

### Web-based Visualization using Lichtblick

[`lichtblick-monitoring`](https://github.com/openads-project/lichtblick-monitoring)

Monitoring and visualization using the web-based [Lichtblick](https://github.com/lichtblick-suite/lichtblick) tool with support for message definitions used in OpenADS.
