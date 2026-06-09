# 🛠️ OpenADSuite

The OpenADSuite comprises tools and templates that streamline developer workflows and improve code quality and maintainability. Check out the subsections in the navigation bar for more information on the provided tools, release processes and system analysis possibilities.

```{toctree}
:maxdepth: 1
:hidden:

tools
releases
analysis
```

## Contribution Guidelines

We welcome contributions in the various OpenADS repositories and kindly ask you to follow these contribution guidelines:

- Feel free to open issues and pull requests to report bugs and suggest improvements or new features. However, make sure to keep the `Draft` state until your request is ready for review to value the reviewer's time.
- This is also why we do not accept requests from AI agents. Of course, AI can be used to create pull requests, but a human must be responsible for feedback and change requests from the reviewer. Make sure to only open issues or pull requests if you are willing to react to the feedback of maintainers or other developers.
- Adopt community best-practices where possible. Use the [openads_demo_module](https://github.com/openads-project/openads_demo_module) as a template and make sure to integrate the provided CI workflows in your OpenADS modules.
- For code contribution, please follow the [ROS 2 developer guide](https://docs.ros.org/en/jazzy/The-ROS2-Project/Contributing/Developer-Guide.html).

## Development

The following guides explain how to [improve existing OpenADS modules](#improve-existing-modules) and how to [create new OpenADS modules](#create-new-modules). Feel free to [open an issue](https://github.com/openads-project/openads-dev-environment/issues/new/choose) if you encounter any problems in the development workflow.

### Improve Existing Modules

Found a bug or want to add a nice new feature to one of the existing OpenADS modules? The following steps will enable you to dive directly into coding and testing with minimum effort:

1. Make sure to have either the [OpenADStack](../openadstack/openadstack.md) or the [OpenADSim](../openadsim/openadsim.md) repository cloned and find the module you want to improve in one of the `docker-compose.yml` files.
1. Append `-dev` to the image tag to switch from the deployment to a development image, which includes source code and all required dependencies for code development.
1. Set `command: sleep infinity` to keep the container running while you develop, compile and run the contained code.
1. Start the docker composition (stack or simulation) with `docker compose up`.
1. Use [Visual Studio Code](https://code.visualstudio.com/) to [attach to the running development container](https://code.visualstudio.com/docs/devcontainers/attach-container).
1. In the development container, navigate to the source code at `/docker-ros/ws/src/target` and start developing.
1. Compile the source code with `CTRL-B` or by selecting `F1` &#8594; `Tasks: Run Task` &#8594; `Build with Build Type`.
1. Run the compiled code with the default command configured in `docker-ros.yml` by executing `run_default_command`.

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
1. Start developing and compile the source code with `CTRL-B` or `F1` &#8594; `Tasks: Run Task` &#8594; `Build with Build Type`
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

### Create new Modules

Want to integrate a new functionality not covered by any existing OpenADS module or integrate existing open source modules from other ecosystems into OpenADS? We appreciate a growing distributed ecosystem that facilitates comparison and testing of various existing solutions. The following steps will quickly enable you to create a new OpenADS module, which can be used to create new functionality or integrate existing modules from other ecosystems:

1. Use the [openads_demo_module](https://github.com/openads-project/openads_demo_module) template repository to create a new GitHub repository in the organization of your choice by selecting the `Use this template` &#8594; `Create a new repository` button in the upper-right corner.
2. Select a name for the new repository. This should usually be equal to the name of the main ROS package in this repository, which should follow the [ROS convention](https://ros.org/reps/rep-0144.html), e.g. `openads_test_module`.
3. Ensure that CI workflows are allowed to push Docker images to the container registry in your GitHub organization or personal namespace:
   1. In *organization* namespaces: Enable `Settings / Actions / General / Workflow permissions / Read and write permissions` and `Settings / Packages / Package creation / Public` in the organization settings.
   2. In *personal* namespaces: Enable `Settings / Actions / General / Workflow permissions / Read and write permissions` in the repository settings.
4. Verfiy that the `docker-ros` workflow successfully created a development image in the repository's [Actions](https://github.com/openads-project/openads_demo_module/actions/workflows/docker-ros.yml) tab. Hit `Re-Run All Jobs` to restart the pipeline.
5. Clone the repository to your workstation. Make sure to use the `--recursive` argument to include the development environment contained as submodule or execute `git submodule update --init` after cloning without the argument:

    ```bash
    git clone --recursive git@github.com:<your-organization>/openads_test_module.git
    ```

6. Open the cloned repository in Visual Studio Code:

    ```bash
    code openads_test_module
    ```

7. Reopen the folder in a development container. This will build a local development image including ROS 2 and required dependencies for development:

   `F1` &#8594; `Dev Containers: Rebuild and Reopen in Container`

    > If building the development image fails (e.g. with `ERROR: failed to build: failed to solve: error getting credentials`). Pull the base image manually with `docker pull rwthika/ros2:jazzy`, ensure that your [Docker credentials helper](https://github.com/docker/docker-credential-helpers) is unlocked and retry reoping in container.

8. Visual Studio Code will automatically open the source code mounted from your locally cloned repository to `/docker-ros/ws/src/target` in the container.
9.  Compile the source code with `CTRL-B` or `F1 --> Tasks: Run Task --> Build with Build Type`.
10. Run the compiled code with the default command configured in `docker-ros.yml` by executing `run_default_command`.
11. You can remove the existing ROS package samples `openads_demo_module` and `openads_demo_module_interfaces` and create a new package template according to your need with `ros2-pkg-create --template ros2_cpp_pkg .`.
12. Make sure to set a [default command](https://github.com/openads-project/openads_demo_module/blob/f524d148d43d26f77b77d3196bc445d9ef030cb9/.github/workflows/docker-ros.yml#L24), which is automatically executed on start of deployment containers.
13. Run `` to generate README files and solve the contained TODOs and run `` to check if your repository succeeds all consistency checks.
14. Once your module is ready and passes all checks, create a [release](releases.md) and open a pull request in the [OpenADStack](https://github.com/openads-project/openadstack) repository to suggest integrating the module.
