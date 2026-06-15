# 🛡️ OpenADSafety

```{toctree}
:maxdepth: 2
:hidden:
```

> 🚧 Under Construction

The goal of OpenADS is to provide a complete toolchain and reference implementation that can be the basis for a commerzialized, safety-certified level 4 automated driving system. This involves various requirements with respect to the system's safety and security as specified, e.g. by the German [AFGBV regulation](https://www.gesetze-im-internet.de/afgbv/BJNR098610022.html) (*Autonome-Fahrzeuge-Genehmigungs-und-Betriebs-Verordnung* / *Regulations on the Approval and Operation of Autonomous Vehicles*).

## Functional Safety (FuSa, ISO 26262)

> ❓ *Did we build the functions right?*

To achieve a safety-certified automated driving stack, functional safety according to [ISO 26262-3:2018-12](https://www.dinmedia.de/en/standard/iso-26262-3/300423934) (*Road vehicles - Functional safety - Part 3: Concept phase*) is required. This includes processes to ensure that all safety-relevant functions were built correctly, e.g., no bugs are present in the software. HARA, ASIL level, ...

## Safety of the intended functionality (SOTIF, ISO/PAS 21448)

> ❓ *Did we build the right functions?*

It is also necessary to ensure that we built the right functions according to the operational design domain (ODD) and requirements of the automated driving system. This can be analyzed following the [ISO 21448:2022](https://www.iso.org/standard/77490.html) (*Road vehicles — Safety of the intended functionality*).

### Safety Argumentation

> ➡️ Structured safety argumentation following GSN (goal structuring notation) syntax and linking safety goals to requirements and evidence supporting assumptions.

### Module Benchmarks

Module benchmarks, e.g. percpetion and planning performance can provide evidence supporting the safety argumentation.

#### Perception Benchmarks

> 🚧 Under Construction

#### Planning Benchmarks

> 🚧 Under Construction

## Cybersecurity

> ❓ *TODO*

The system's cybersecurity shall be guaranteed according to [UN Regulation No. 155](https://unece.org/transport/documents/2021/03/standards/un-regulation-no-155-cyber-security-and-cyber-security).
