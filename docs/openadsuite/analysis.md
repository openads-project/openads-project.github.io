# System Analysis & Tracing

OpenADSuite supports runtime analysis of OpenADStack through ROS 2 tracing. Traces record callback execution and message publication and reception across the distributed stack, helping you inspect message flow, identify latency bottlenecks and timing jitter, and investigate missing messages or race conditions.

To collect trace data, run OpenADStack with tracing enabled, capture a trace, and inspect it with the provided analysis tools. The [OpenADStack System Analysis guide](../openadstack/openadstack/docs/system-analysis.md) describes the setup and capture commands, which services are traced by default, how to include additional services, and how to analyze the results with Eclipse Trace Compass or Jupyter Notebooks.
