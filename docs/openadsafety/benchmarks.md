# Benchmarks

```{note}
🚧 This section is currently under construction.
```

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

## Benchmarks in the OpenADS ecosystem

Benchmarks should become a standard part of the OpenADS development lifecycle:

- Developers use them locally to compare parameter changes or algorithm variants.
- CI uses them to detect regressions before code is merged.
- Integration teams use them to assess compatibility of modules inside a larger stack.
- Safety engineering uses them as one source of evidence inside a broader argument that also includes reviews, requirements, simulation, and fault handling.

This means benchmark definitions should be versioned like code, and benchmark results should be stored in a way that supports historical comparison.
