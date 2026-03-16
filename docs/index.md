# 🚗 OpenADS

```{note}
🚧 This project is currently under construction.
```

## The Open Automated Driving Systems Project

The OpenADS project is a **collaborative, open-source ecosystem for Automated Driving Systems**:

- 🧠 Complete functional open-source **OpenADStack** reference implementation of an Automated Driving System based on [ROS 2](https://www.ros.org/), comprising perception, understanding, planning, and actuation modules. [Contributions](./development/development.md#-module-development) to improve or integrate additional modules are welcome.
- 🎮 The **OpenADSim** simulation environment supports multiple simulators for prototyping and testing, including [CARLA](https://carla.org/) for environment and vehicle simulation and [SUMO](https://eclipse.dev/sumo/) for urban traffic simulation. [Contributions](./development/development.md#-simulation-development) to integrate more simulators are welcome.
- 🛠️ **DevOps tools** that streamline developer workflows, such as module templates and ready-to-use development environments.
- ✅ **Automated testing** on both module and system level, including unit tests and scenario-based testing in simulation.

![OpenADS Overview](openads.drawio.svg){align=center}

## Contents

```{toctree}
:maxdepth: 2

usage/usage
design/design
development/development
```

## 🚀 Getting Started

📖 Check out the [**Quick Start Guide**](./usage/usage.md) to start using OpenADS right away — it's just a few commands away.

📐 Learn more about the [**Design Goals**](./design/design.md) and system architecture.

🤝 We greatly appreciate **Contributions**! All ADS developers are welcome to dive into the technical details of the [Modules](./usage/modules.md) and [Tools](./usage/tools.md) and learn how to [contribute](./development/development.md) to OpenADS.
