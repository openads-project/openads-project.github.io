# Releases

A clearly defined release process shall ensure that OpenADS stays maintainable, does not introduce breaking changes, allows easy upgrades and rollbacks and eventually will continuously get better.

Before new modules or module updates are integrated into a composition like [OpenADStack](../openadstack/openadstack.md) or [OpenADSim](../openadsim/openadsim.md), create a release of the GitHub repository:

- Update the version number in all [`package.xml`](https://github.com/openads-project/openads_demo_module/blob/c943e431357d7876989cd13df16d7215d5f78ff4/openads_demo_module/package.xml#L6) files in the repository following the [SemVer](https://semver.org) convention, e.g. `v1.0.0`.
- [Create a new release](https://github.com/openads-project/openads_demo_module/releases/new) for your package. This will trigger the `docker-ros` CI workflow to store a new image and compose file tagged with the release version in the [package registry](https://github.com/openads-project/openads_demo_module/pkgs/container/openads_demo_module).
- Use the tagged image and compose file for integration into [OpenADSim](../openadsim/openadsim/docs/custom-integration.md).
- Once tested successfully in [OpenADSim](../openadsim/openadsim/docs/custom-integration.md), consider creating a pull request for integration into [OpenADStack](../openadstack/openadstack.md).

> **🚧 Under Construction**: Release processes with required SiL/HiL/track tests for feature, module and stack integration.
