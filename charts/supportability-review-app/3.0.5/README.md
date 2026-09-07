# SUSE Supportability Review

**Collects and analyzes cluster data for supportability assessment.**

### Overview
The SUSE Supportability Review (SR) extension is a proactive diagnostic suite. It ensures your clusters are "Support-Ready" by auditing them against the SUSE Support Matrix and best practices, preventing configuration-related downtime before it happens.

Documentation for SUSE Supportability Review can be found [**here**](https://support.scc.suse.com/s/kb/Rancher-Supportability-Review-FAQ).

### Core Architecture
This tool runs non-invasive scanners (using the SURE engine) across your management and downstream clusters. It aggregates logs, component versions, and configurations into a "Support Bundle" that is formatted for rapid analysis by SUSE engineers.

### Key Technical Features
* **Health & Compliance Audits**: Validates that OS, Docker/Containerd, and K8s versions are within the official support lifecycle.
* **Automated Data Collection**: Generates comprehensive diagnostic bundles in seconds, replacing manual log-gathering.
* **Redaction Engine**: Automatically scrubs sensitive data (passwords, secrets) from logs before they are exported.
* **Proactive Alerts**: Flags "at-risk" configurations, such as low-resource master nodes or deprecated API usage.

### Target Use Cases
* **Pre-Upgrade Checks**: Running a review before a major Rancher or Kubernetes upgrade to ensure compatibility.
* **Incident Escalation**: Providing SUSE Support with high-quality data to resolve tickets 50% faster.

### Deployment Path
* **First Step**: Click the **SUSE Supportability Review** sidebar item and select **Run New Review** to generate your first report.