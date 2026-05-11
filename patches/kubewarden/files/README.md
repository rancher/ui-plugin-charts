# SUSE Security Admission Controller

**Automates policy enforcement and security validation for cluster-wide admission requests.**

### Overview
SUSE Security Admission Controller provides a universal "guardrail" system for Kubernetes. It allows security teams to write and enforce policies that inspect every request coming into the cluster (like "no root containers" or "only pull from our registry"), ensuring compliance before any code actually runs.

### Core Architecture
SUSE Security Admission Controller policies are distributed as container images. When a user tries to deploy a workload, the SUSE Security Admission Controller Policy Server intercepts the request, runs it against the selected policies, and either allows, denies, or "mutates" (fixes) the request.

### Key Technical Features
* **Flexible Policy Engine**: Deploy policies for Pod Security Admissions (PSA), resource limits, and custom business logic.
* **Visual Policy Library**: Access a curated catalog of pre-built policies directly through the Rancher UI.
* **Real-Time Audit**: A "Trace" mode that allows you to see exactly why a specific request was denied or modified.
* **Context-Aware Policies**: Policies can check the state of other resources in the cluster to make complex security decisions.

### Target Use Cases
* **Regulatory Compliance**: Automatically enforcing CIS Benchmarks or PCI-DSS requirements.
* **Developer Guardrails**: Preventing accidental resource exhaustion by enforcing CPU/Memory limits.

### Deployment Path
* **Prerequisites**: Cert-manager and the "SUSE Security Admission Controller" Controller installed via Apps & Marketplace.
* **First Step**: Open the **SUSE Security Admission Controller** sidebar and deploy a **Policy Server**.

### Documentation
Documentation for SUSE Security Admission Controller can be found [here](https://docs.kubewarden.io/).