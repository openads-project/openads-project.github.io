# 🛡️ OpenADSafety

```{toctree}
:maxdepth: 2
:hidden:
benchmarks
```

The goal of OpenADS is to provide a complete toolchain and reference implementation that can become the basis for a commercialized, safety-certified level 4 automated driving system. This involves technical, process-related, and regulatory requirements regarding system safety and security as specified, for example, by the German [AFGBV regulation](https://www.gesetze-im-internet.de/afgbv/BJNR098610022.html) (*Autonome-Fahrzeuge-Genehmigungs-und-Betriebs-Verordnung* / *Regulations on the Approval and Operation of Autonomous Vehicles*).

OpenADS itself is not a certified product out of the box. Instead, it aims to provide reusable modules, reproducible development environments, traceable interfaces, simulation scenarios, and automated validation pipelines that can contribute evidence to a later approval and certification process.

In practice, safety work in OpenADS spans three complementary questions:

- **Functional safety:** Are faults in hardware or software handled so that unreasonable risk is avoided?
- **SOTIF:** Is the intended functionality itself sufficiently safe within the operational design domain, even if no fault is present?
- **Cybersecurity:** Is the system protected against malicious misuse that could compromise safety or availability?

## Functional Safety (FuSa, ISO 26262)

> ❓ *Did we build the functions right?*

To achieve a safety-certified automated driving stack, functional safety according to [ISO 26262-3:2018-12](https://www.dinmedia.de/en/standard/iso-26262-3/300423934) (*Road vehicles - Functional safety - Part 3: Concept phase*) is required. For OpenADS, this means not only implementing algorithms correctly, but also defining clear system boundaries, assumptions, interfaces, failure reactions, and verification evidence for safety-relevant behavior.

Typical functional-safety work products around an OpenADS-based stack include:

- Item definition and system context, including sensors, actuators, middleware, compute platform, and external interfaces.
- Safety goals derived from hazardous events and mapped to relevant system functions.
- Functional and technical safety requirements for perception, localization, planning, control, and supporting infrastructure.
- Safety mechanisms such as plausibility checks, timeout supervision, degraded operation, and safe-state handling.
- Verification evidence from reviews, tests, simulation, static analysis, and integration campaigns.

### Hazard and Risk Analysis (HARA)

A Hazard and Risk Analysis identifies potentially hazardous events caused by malfunctioning behavior and evaluates their risk based on severity, exposure, and controllability. In automated driving, HARA is usually performed at vehicle or item level and then refined into subsystem requirements.

For OpenADS, a HARA should typically answer questions such as:

- Which vehicle functions are in scope, and under which operational situations are they allowed to operate?
- What happens if a module provides stale, missing, inconsistent, or physically implausible output?
- Which hazards can arise from invalid perception objects, wrong localization, infeasible trajectories, or missing actuation commands?
- What is the expected fallback behavior if communication, computation, or map data are unavailable?

Examples of malfunctioning behavior in an OpenADS-based stack could include missed detection of a relevant obstacle, an invalid route through a non-drivable area, or a trajectory that violates vehicle-dynamics constraints. The HARA output should lead to explicit safety goals and to a documented safe state or fallback strategy.

### Automotive Safety Integrity Levels (ASIL)

The HARA results determine the required Automotive Safety Integrity Level, ranging from `QM` for non-safety-related quality management up to `ASIL D` for the highest integrity requirements. ASIL classification affects the required rigor for architecture, development, verification, tool qualification, and independence of confirmation measures.

For OpenADS, an important implication is that not every module necessarily carries the same ASIL. Some functions may remain `QM`, while others require stronger safety mechanisms and more stringent verification. Modularization helps isolate responsibilities, but it does not replace safety engineering. ASIL decomposition, interface assumptions, and freedom-from-interference arguments still need to be justified explicitly.

Examples of measures that may support ASIL-oriented architectures include:

- Redundant or diverse information channels for safety-critical inputs.
- Runtime monitors for heartbeat, latency, range, and plausibility checks.
- Deterministic fallback behavior if a module violates timing or consistency assumptions.
- Traceable requirements and bidirectional links between requirements, code, tests, and evidence.

## Safety of the intended functionality (SOTIF, ISO/PAS 21448)

> ❓ *Did we build the right functions?*

It is also necessary to ensure that we built the right functions according to the operational design domain (ODD) and requirements of the automated driving system. This can be analyzed following [ISO 21448:2022](https://www.iso.org/standard/77490.html) (*Road vehicles — Safety of the intended functionality*).

SOTIF focuses on hazards caused by performance limitations or insufficient specification rather than faults. For automated driving, this is especially relevant for perception uncertainty, incomplete scene understanding, rare traffic interactions, map limitations, and ambiguous behavior at the edge of the intended ODD.

OpenADS can support SOTIF work through reproducible scenario execution in [OpenADSim](../openadsim/openadsim.md), controlled experiments on recorded data in [OpenADStack](../openadstack/openadstack.md), and benchmark pipelines that make limitations visible instead of hiding them behind average performance metrics.

Typical SOTIF questions for OpenADS-based systems include:

- Which weather, lighting, road-layout, and traffic conditions are inside the claimed ODD?
- Which perception classes, map assumptions, and behavioral assumptions are required for safe planning?
- Which edge cases are known and accepted, and which still require mitigation or ODD restriction?
- How are unknown unsafe scenarios discovered, reproduced, and regressed over time?

### Safety Argumentation

Structured safety argumentation is required to connect claims about system safety with assumptions, context, requirements, and evidence. Goal Structuring Notation (GSN) is a common way to make these relationships explicit.

A safety argument for OpenADS should not only claim that a module performs well, but also document:

- The exact system boundary and ODD for which the claim is made.
- Which assumptions about sensors, maps, middleware, and timing must hold.
- Which evidence supports the claim, such as tests, simulation results, code reviews, or process records.
- Which residual risks remain and how they are mitigated operationally.

This is where CI pipelines, scenario catalogs, benchmark histories, and architecture documentation become valuable: they can provide repeatable evidence instead of one-off demonstrations.

### Module Benchmarks

Module benchmarks can provide evidence supporting the safety argumentation. They are most useful when they are tied to concrete safety questions, representative scenarios, and explicit pass or warning thresholds.

More details on benchmark design, traceability, and interpretation are collected in the dedicated [Benchmarks](./benchmarks.md) page.

## Cybersecurity

> ❓ *Can the system be manipulated in a way that compromises safety?*

The system's cybersecurity shall be guaranteed according to [UN Regulation No. 155](https://unece.org/transport/documents/2021/03/standards/un-regulation-no-155-cyber-security-and-cyber-security). In practice, this means that safety arguments for OpenADS cannot ignore malicious behavior, compromised dependencies, insecure interfaces, or operational misuse.

Relevant cybersecurity topics for OpenADS include:

- Threat analysis and risk assessment for exposed interfaces such as developer tooling, container registries, middleware transport, remote access, and data pipelines.
- Secure software supply chains, including dependency tracking, image provenance, vulnerability management, and access control.
- Operational protection measures such as least-privilege deployment, logging, monitoring, secret handling, and incident response.
- Interaction between cybersecurity incidents and safety mechanisms, for example denial of service, spoofed data, or unauthorized actuation paths.

Because OpenADS is heavily based on modular repositories, container images, and CI/CD, cybersecurity engineering should be treated as a first-class systems concern rather than an afterthought. Secure defaults in development infrastructure can directly reduce the effort needed later for regulatory approval and field deployment.
