# SUSE Observability

**Analyzes multi-cluster telemetry with AI-powered insights for accelerated incident resolution.**

### Vision & Value
Standard monitoring tells you *that* something is broken; SUSE Observability tells you *why*. This extension moves beyond simple dashboards to provide a correlated view of your entire stack, using AI to connect the dots between a slow database in one cluster and a failing pod in another.

### Core Architecture
Powered by the Opni and StackState engines, this extension aggregates logs, metrics, and traces into a "Global Topology Map." It uses AIOps algorithms to baseline "normal" performance and flags anomalies that human operators might miss.

### Key Technical Features
* **Automated Root Cause Analysis**: When an alert fires, the AI Assistant provides a timeline of the exact changes that led to the failure.
* **Topology-Based Correlation**: Visualize the real-time dependencies between your microservices, namespaces, and physical nodes.
* **Log Anomaly Detection**: Uses machine learning to find "needle-in-a-haystack" error patterns in millions of log lines.
* **Unified Fleet Health**: A single health-score dashboard for all clusters managed by Rancher Prime.

### Target Use Cases
* **MTTR Reduction**: Slashing the time spent in "war rooms" by pinpointing failures instantly.
* **Change Impact Analysis**: Seeing exactly how a new software deployment affects the rest of the infrastructure.

### Deployment Path
* **Prerequisites**: Rancher Prime subscription; connectivity to the SUSE Observability backend.
* **First Step**: Enable the extension and use the **Topology** view to discover your cluster dependencies.

### Documentation
Documentation for SUSE Observability can be found [here](https://documentation.suse.com/cloudnative/suse-observability/latest/en/classic.html).