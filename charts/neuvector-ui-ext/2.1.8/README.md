# SUSE Security Extension

**Centralizes security dashboards and vulnerability scanning for full-lifecycle container protection.**

### Overview
SUSE Security is the industry's only 100% open-source, Zero Trust container security platform. This extension embeds SUSE Security's deep-visibility tools into Rancher, moving your security posture from "reactionary" (logs/alerts) to "preventative" (blocking threats in real-time).

### Core Architecture
SUSE Security uses "Enforcers" on every node to perform Deep Packet Inspection (DPI) on container traffic. It learns your application's normal behavior and automatically creates a Zero Trust firewall that blocks anything outside that "known-good" baseline.

### Key Technical Features
* **Layer 7 Container Firewall**: Inspects over 30 protocols (HTTP, MySQL, MongoDB, etc.) to block lateral movement and SQL injection.
* **Security-as-Code**: Export learned security rules as Kubernetes Custom Resources (CRDs) for GitOps-driven security.
* **Full-Lifecycle Scanning**: Scans images in the registry, the CI/CD pipeline, and while they are running in production.
* **Zero-Drift Protection**: Automatically detects and blocks unauthorized process execution or file system changes.

### Target Use Cases
* **High-Security Environments**: Protecting financial, healthcare, or government data from zero-day exploits.
* **Network Segmentation**: Implementing strict "micro-segmentation" without complex firewall hardware.

### Deployment Path
* **Prerequisites**: SUSE Security helm chart installed; Rancher SSO configured.
* **First Step**: Click the **SUSE Security** icon in the sidebar to open the integrated Zero Trust dashboard.

### Documentation
Documentation for SUSE Security can be found [here](https://documentation.suse.com/cloudnative/security/5.4/en/overview.html).