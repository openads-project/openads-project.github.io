# Benchmarks

Benchmarking modules in a transparent and traceable way is at the core of OpenADS' modular design. In OpenADS, benchmarks are not only used to compare algorithms, but also to generate repeatable evidence about capability, limitations, regression behavior, and operational assumptions.

No single benchmark score is sufficient for an automated driving function. OpenADS therefore favors benchmark suites that combine scenario diversity, multiple metrics, and full traceability of code, data, and runtime conditions.

## Benchmark Design Principles

A useful OpenADS benchmark should be:

- **Representative:** It should reflect the relevant operational design domain, interfaces, and failure modes.
- **Reproducible:** The same code, configuration, dataset, and scenario version should yield the same result.
- **Traceable:** Each result should be linked to the exact repository revision, container image, and benchmark configuration.
- **Comparable:** Outputs should be normalized so that multiple module versions or implementations can be compared fairly.
- **Actionable:** The benchmark should make it clear what changed and why a result is acceptable, degraded, or failed.

These principles match the broader OpenADS architecture with containerized modules, CI/CD workflows, and clearly defined interfaces between services.

## Benchmark Categories

OpenADS can support several complementary benchmark types:

### Perception Benchmarks

Perception benchmarks typically evaluate whether relevant objects and scene elements are detected, classified, and tracked with sufficient accuracy and latency.

Typical metrics include:

- Recall and precision for safety-relevant classes.
- Position, orientation, velocity, and tracking accuracy.
- End-to-end latency.
- Confidence calibration and robustness under domain shift.

Important benchmark slices include rare objects, occlusions, low-visibility conditions, and crowded urban scenes. Average performance alone is rarely sufficient for safety-relevant decision making.

### Planning And Control Benchmarks

Planning and control benchmarks evaluate whether generated routes, trajectories, or control actions are safe, feasible, and understandable.

Typical metrics include:

- Collision rate and minimum time-to-collision.
- Route completion and rule-compliance rates.
- Kinematic and dynamic feasibility.
- Comfort-related measures such as jerk, curvature continuity, or oscillation.

In addition to nominal cases, benchmarks should explicitly test degraded inputs such as missing objects, uncertain localization, or invalid map segments.

### Runtime And Systems Benchmarks

Not all relevant evidence is algorithmic. System-level benchmarks can reveal integration issues that strongly affect safety and usability.

Examples include:

- CPU, GPU, memory, and bandwidth usage under representative load.
- Startup time, recovery time, and service restart behavior.
- Middleware latency, message loss, and timing jitter.
- Behavior under partial failures or overloaded compute resources.

These measurements are especially important for distributed ROS 2 based deployments where timing and communication assumptions directly influence system behavior.

## Benchmarks In The OpenADS Workflow

Benchmarks should become a standard part of the OpenADS development lifecycle:

- Developers use them locally to compare parameter changes or algorithm variants.
- CI uses them to detect regressions before code is merged.
- Integration teams use them to assess compatibility of modules inside a larger stack.
- Safety engineering uses them as one source of evidence inside a broader argument that also includes reviews, requirements, simulation, and fault handling.

This means benchmark definitions should be versioned like code, and benchmark results should be stored in a way that supports historical comparison.

## Limits Of Benchmarks

Benchmarks are necessary, but they are not a substitute for systems engineering. A benchmark can show that a module performs well on a defined workload, but it cannot by itself prove system safety, SOTIF compliance, or regulatory approval.

In particular, benchmark results should always be interpreted together with:

- The intended ODD and its explicit exclusions.
- Known failure cases and residual risks.
- Assumptions about upstream and downstream modules.
- Complementary evidence from scenario-based testing, recorded-data replay, code review, and safety analysis.

For this reason, OpenADS treats benchmarks as structured evidence, not as a single leaderboard score.
