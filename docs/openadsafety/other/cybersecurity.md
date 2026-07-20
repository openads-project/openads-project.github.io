
# Cybersecurity

[![](https://img.shields.io/badge/UN_ECE-R_155-green?logo=GitBook)](https://unece.org/transport/documents/2021/03/standards/un-regulation-no-155-cyber-security-and-cyber-security)

> ❓ *Can the system be manipulated in a way that compromises safety?*

The system's cybersecurity shall be guaranteed according to [UN Regulation No. 155](https://unece.org/transport/documents/2021/03/standards/un-regulation-no-155-cyber-security-and-cyber-security). In practice, this means that safety arguments for OpenADS cannot ignore malicious behavior, compromised dependencies, insecure interfaces, or operational misuse.

Relevant cybersecurity topics for OpenADS include:

- Threat analysis and risk assessment for exposed interfaces such as developer tooling, container registries, middleware transport, remote access, and data pipelines.
- Secure software supply chains, including dependency tracking, image provenance, vulnerability management, and access control.
- Operational protection measures such as least-privilege deployment, logging, monitoring, secret handling, and incident response.
- Interaction between cybersecurity incidents and safety mechanisms, for example denial of service, spoofed data, or unauthorized actuation paths.

Because OpenADS is heavily based on modular repositories, container images, and CI/CD, cybersecurity engineering should be treated as a first-class systems concern rather than an afterthought. Secure defaults in development infrastructure can directly reduce the effort needed later for regulatory approval and field deployment.