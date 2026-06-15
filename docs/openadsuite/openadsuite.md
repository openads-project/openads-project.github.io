# 🛠️ OpenADSuite

OpenADSuite provides tools and templates that streamline development workflows and improve code quality and maintainability. The subsections in the navigation bar describe the available tools, release process, and analysis capabilities in more detail.

```{toctree}
:maxdepth: 1
:hidden:

tools
releases
analysis
```

## Contribution Guidelines

We welcome contributions across the OpenADS repositories and ask you to follow these guidelines:

- Feel free to open issues and pull requests to report bugs, suggest improvements, or propose new features. Keep pull requests in the `Draft` state until they are ready for review to respect reviewers' time.
- AI tools may assist with preparing issues or pull requests, but a human author must remain responsible for the submission and for addressing maintainer feedback and requested changes.
- Adopt community best practices where possible. Use [openads_demo_module](https://github.com/openads-project/openads_demo_module) as a template and integrate the provided CI workflows into your OpenADS modules.
- For code contributions, follow the [ROS 2 developer guide](https://docs.ros.org/en/jazzy/The-ROS2-Project/Contributing/Developer-Guide.html).

## Development

The guides below explain how to [improve existing OpenADS modules](#improve-existing-modules) and how to [create new OpenADS modules](#create-new-modules). If you encounter problems in the development workflow, feel free to [open an issue](https://github.com/openads-project/openads-dev-environment/issues/new/choose).

### Improve Existing Modules

Found a bug or want to add a feature to an existing OpenADS module? The following steps let you start coding and testing with minimal setup effort:

1. Clone either the [OpenADStack](https://github.com/openads-project/openadstack) or the [OpenADSim](https://github.com/openads-project/openadsim) repository, then locate the module you want to improve in one of the `docker-compose.yml` files.
2. Append `-dev` to the image tag to switch from the deployment to a development image, which includes source code and all required dependencies for code development.
3. Set `command: sleep infinity` to keep the container running while you develop, compile and run the contained code.
4. Start the Docker composition with `docker compose up`.
5. Use [Visual Studio Code](https://code.visualstudio.com/) to [attach to the running development container](https://code.visualstudio.com/docs/devcontainers/attach-container).
6. In the development container, navigate to the source code at `/docker-ros/ws/src/target` and start developing.
7. Compile the source code with `CTRL-B` or by selecting `F1` &#8594; `Tasks: Run Task` &#8594; `Build with Build Type`.
8. Run the compiled code with the default command configured in `docker-ros.yml` by executing `run_default_command`.

:::{dropdown} Example: Improve `ackermann_trajectory_control`

1. Clone the [OpenADStack](../openadstack/openadstack.md) and the [ackermann_trajectory_control](https://github.com/openads-project/ackermann_trajectory_control) repositories:

    ```bash
    git clone --recursive https://github.com/openads-project/openadstack.git
    git clone --recursive https://github.com/openads-project/ackermann_trajectory_control.git
    ```

1. Change the following lines in the `ackermann-trajectory-control` [Docker service](https://github.com/openads-project/openadstack/blob/cc99efb1115179485a0e5fedf577f68e51ef8e9f/control/ackermann_trajectory_control/docker-compose.yml#L3-L35):

    ```yaml
    image: gitlab.ika.rwth-aachen.de:5050/fb-fi/its-modules/control/ackermann_trajectory_control:v1.3.0-dev  # append '-dev'
    command: sleep infinity  # replace the existing command to keep the development container running

    # mount the cloned `ackermann_trajectory_control` repository from your host into the container to make changes persistent
    volumes:
      - ../../../ackermann_trajectory_control:/docker-ros/ws/src/target
    ```

1. Run the OpenADStack:

    ```bash
    cd openadstack
    docker compose up
    ```

1. Open Visual Studio Code, select `F1` &#8594; `Dev Containers: Attach to Running Container...` and select the `openadstack-control-ackermann-trajectory-control` container.
1. Open the source code folder (`/docker-ros/ws/src/target`) in Visual Studio Code with `Open Folder` (or `CTRL-O`).
1. Start developing and compile the source code with `CTRL-B` or `F1` &#8594; `Tasks: Run Task` &#8594; `Build with Build Type`.
1. Run the compiled code using the [default command](https://github.com/openads-project/ackermann_trajectory_control/blob/f1b84f6d6d481f430bafd7edc7f99183cf053ca6/.github/workflows/docker-ros.yml#L24) of the image:

    ```bash
    run_default_command
    ```

1. You can also modify the start command as required. However, make sure to source the compiled install space (or open a new terminal with `Terminal` &#8594; `New Terminal`):

    ```bash
    source /docker-ros/ws/install/setup.bash
    ros2 launch ackermann_trajectory_control ackermann_trajectory_control.launch.py
    ```

1. Once your changes are ready for publication, push them to a fork of the original git repository and [create a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) in the OpenADS repository.

:::

### Create New Modules

Want to add functionality that is not yet covered by an existing OpenADS module, or integrate open source software from another ecosystem into OpenADS? A growing distributed ecosystem makes it easier to compare and test different approaches. The following steps will help you create a new OpenADS module quickly, whether you are building new functionality or integrating an existing solution:

1. Use the [openads_demo_module](https://github.com/openads-project/openads_demo_module) template repository to create a new GitHub repository in the organization of your choice by selecting the ![Use this template](./assets/template-button.png){width=100px} &#8594; `Create a new repository` button in the upper-right corner.
2. Select a name for the new repository. In most cases, this should match the name of the main ROS package in the repository and follow the [ROS naming convention](https://ros.org/reps/rep-0144.html), for example `openads_test_module`.
3. Configure the [recommended GitHub repository settings](https://github.com/openads-project/openads_demo_module#%EF%B8%8F-recommended-github-settings). This also allows CI workflows to push Docker images to the container registry in your GitHub organization or personal namespace.
4. Verify that the `docker-ros` workflow successfully created a development image in the repository's [Actions](https://github.com/openads-project/openads_demo_module/actions/workflows/docker-ros.yml) tab. If needed, use `Re-Run All Jobs` to restart the pipeline.
5. Clone the repository to your workstation. Use the `--recursive` argument to include the development environment submodule, or run `git submodule update --init` afterward if you cloned without it:

    ```bash
    git clone --recursive git@github.com:<your-organization>/openads_test_module.git
    ```

6. Open the cloned repository in Visual Studio Code:

    ```bash
    code openads_test_module
    ```

7. Reopen the folder in a development container. This will build a local development image including ROS 2 and required dependencies for development:

   `F1` &#8594; `Dev Containers: Rebuild and Reopen in Container`

    > If building the development image fails, for example with `ERROR: failed to build: failed to solve: error getting credentials`, pull the base image manually with `docker pull rwthika/ros2:jazzy`, ensure that your [Docker credentials helper](https://github.com/docker/docker-credential-helpers) is unlocked, and retry reopening the folder in the container.

8. Visual Studio Code will automatically open the source code mounted from your locally cloned repository to `/docker-ros/ws/src/target` in the container.
9. Compile the source code with `CTRL-B` or `F1` &#8594; `Tasks: Run Task` &#8594; `Build with Build Type`.
10. Run the compiled code with the default command configured in `docker-ros.yml` by executing `run_default_command`.
11. You can remove the sample ROS packages `openads_demo_module` and `openads_demo_module_interfaces` and create a new package template that matches your needs with `ros2-pkg-create --template ros2_cpp_pkg .`.
12. Make sure to set a [default command](https://github.com/openads-project/openads_demo_module/blob/f524d148d43d26f77b77d3196bc445d9ef030cb9/.github/workflows/docker-ros.yml#L24), which is automatically executed on start of deployment containers.
13. Run `.openads-dev-environment/scripts/generate_readme.py` to generate the top-level and package README files, resolve the remaining TODO placeholders, then rerun the generator until it produces no further changes. Run `.openads-dev-environment/scripts/check_repository_consistency.py` to verify that the repository passes the consistency checks.
14. Once your module is ready and passes all checks, create a [release](releases.md) and open a pull request in the [OpenADStack](https://github.com/openads-project/openadstack) repository to suggest integrating the module.
