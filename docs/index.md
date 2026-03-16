# OpenADS 🧠 🎮 🛠️

```{note}
🚧 This project is currently under construction.
```

## The Open Automated Driving Systems Project

The OpenADS project is a **collaborative, open-source ecosystem for Automated Driving Systems** comprising the following features:

- 🧠 The [**OpenADStack**](./openadstack/openadstack.md) is a fully-functional open-source reference implementation of an Automated Driving System based on [ROS 2](https://www.ros.org/). It comprises perception, understanding, planning, and actuation modules, which are called **OpenADServices**. [Contributions](./openadsuite/openadsuite.md#-contribution-guideline) to improve existing or integrate additional services are very welcome.
- 🎮 The [**OpenADSim**](./openadsim/openadsim.md) simulation environment supports multiple simulators for prototyping and testing, including [CARLA](https://carla.org/) for environment and vehicle simulation and [SUMO](https://eclipse.dev/sumo/) for urban traffic simulation. [Contributions](./openadsuite/openadsuite.md#-contribution-guideline) to integrate more simulators are welcome.
- 🛠️ The [**OpenADSuite**](./openadsuite/openadsuite.md) provides development tools that streamline developer workflows, such as module templates and ready-to-use development environments.
- ✅ **Automated testing** on both module and system level, including unit tests and scenario-based testing in simulation.

![OpenADS Overview](openads.drawio.svg){align=center}

## Contents

```{toctree}
:maxdepth: 2

start/start
design/design
openadstack/openadstack
openadsim/openadsim
openadsuite/openadsuite
```

## 🚀 Getting Started

📖 Check out the [**Quick Start Guide**](./start/start.md) to start using OpenADS right away — it's just a few commands away.

📐 Learn more about the [**Design Goals**](./design/design.md) and system architecture.

🤝 We greatly appreciate **Contributions**! All ADS developers are welcome to dive into the technical details of the [Services](./openadstack/services.md) and [Tools](./openadsuite/tools.md) and learn how to [contribute](./openadsuite/openadsuite.md) to OpenADS.
