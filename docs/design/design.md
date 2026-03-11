# Design

```{toctree}
:maxdepth: 2
:hidden:

```

OpenADS is the result of intense discussions held as part of research projects, PhD theses, student theses, hackathons and demonstration events in the context of automated and connected mobility. As one of the largest German research institues in Automotive Engineering with a historiy of more than 120 years, the Institute for Automotive Engineering at RWTH Aachen University has been actively researching automated and connected driving for a while and founded a dedicated research department for *Vehicle Intelligence and Automated Driving* in 2019. While the team was growing and more and more students were eager to participate in research and development, first architectural designs came to their limit and needed improvement.

[The Robot Operating System (ROS)](https://ros.org/) has become the main software ecosystem for automated driving research and is used in other open-source projects like [Autoware](https://autoware.org/). Supported by an active open-source community, ROS offers a lot of helpful base libraries and tooling, just to mention some:

- Huge ecosystem of ROS libraries and tools, e.g. [common interface definitions](https://github.com/ros2/common_interfaces) and the [Transform Library](https://docs.ros.org/en/rolling/Concepts/Intermediate/About-Tf2.html) for spatio-temporal transformations available as released packages listed in [ROS Index](https://index.ros.org) or from open-source projects.
- [Dependency management](https://docs.ros.org/en/rolling/Tutorials/Intermediate/Rosdep.html) and [build toolchain](https://docs.ros.org/en/humble/Concepts/Advanced/About-Build-System.html).
- Support for different communication middleware implementations (e.g. [Eprosima FastDDS](https://github.com/ros2/rmw_fastrtps) or [Zenoh](https://github.com/ros2/rmw_zenoh)), which are abstracted by a ROS middleware adapter and support different [Quality of Service](https://docs.ros.org/en/rolling/Concepts/Intermediate/About-Quality-of-Service-Settings.html) settings and [zero-copy inter-process communication](https://github.com/ros2/rmw_zenoh#zenoh-shared-memory).
- And a lot more as explained in the [ROS Developer Documentation](https://docs.ros.org)

With change from ROS, which originally targeted only rapid-prototyping and research to ROS 2 also targeting industrial deployment with a focus on real-time capability and safety, the team behin OpenADS completely re-designed the grown architecture, which had become difficult to maintain and extend with an increasing number of developers involved.

## Design Goals

- **Code first:** Instead of spending too much time in discussions about standards and theoretically perfect architectures, we collected what we had developed and learned from the past, combined it with the open-source tools and practices available and drafted a working minimum viable product.
- **Reusability for distributed teams:** Teams are often involved in different project with different focus. However, there is often a big potential of reusing and extending existing solutions without too much overhead caused by system complexity.
- **Scalability in mind:** It should be as easy as possible to leverage the open-source software already around instead of re-inventing the wheel over and over again.

## OpenADS Design

- **Microservice architecture**: Isolated modules that can be used in different stacks, easy module development without system knowledge.
- **Containerization**:
- Support for different AD stack architectures (e.g. modular vs. end-to-end)
- Transparent benchmarking and integration decisions.
- ...

## Architecture

The following diagram visualizes the OpenADS ecosystem architecture that defines the basis for collaboratively developing Open Automated Driving Systems.

### OpenADS Ecosystem

A comprehensive documentation is the main entrypoint to the OpenADS ecosystem. It allows low-effort jump start to get everythin up and running and start using and contributing to the development of OpenADS. It explains the architecture of the functional components and tooling enabling the use of the OpenADStack with OpenADSimulation.

![Architecture Diagram](architecture.drawio.svg)

### OpenADStack

- AD-Stack-Diagramm von Miro (überführen in draw.io)?
