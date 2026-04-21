# Alibaba Cloud (ACK) Provisioning

**Provisions and manages Alibaba Cloud (ACK) clusters for integrated cloud resource management.**

### Vision & Value
The Alibaba Cloud (ACK) extension provides a native bridge between Rancher Prime and Alibaba Cloud's Container Service. It eliminates the friction of managing disparate cloud console environments by centralizing the lifecycle of ACK clusters alongside your on-premise and multi-cloud workloads.

### Core Architecture
This extension leverages the Alibaba Cloud Cloud-API to translate Rancher cluster definitions into ACK resources. It handles the orchestration of the control plane, worker nodes (ECS), and networking components (VPC/SLB) through a single declarative workflow.

### Key Technical Features
* **Native ACK Lifecycle**: Create, upgrade, and scale Alibaba Cloud clusters directly from the Rancher UI.
* **Integrated Identity (RAM)**: Seamlessly maps Rancher RBAC to Alibaba Resource Access Management (RAM) for secure, audited access.
* **Global Region Support**: Deploy clusters across all Alibaba Cloud global regions, including specialized China regions.
* **Optimized Networking**: Automatic configuration of VPC, Terway, and SLB (Server Load Balancer) for container workloads.

### Target Use Cases
* **Asia-Pacific Expansion**: Organizations scaling their cloud footprint into China or Southeast Asia.
* **Multi-Cloud Operations**: Maintaining a consistent management plane across Alibaba Cloud, AWS, and Azure.

### Deployment Path
* **Prerequisites**: Rancher Prime subscription; Alibaba Cloud RAM credentials (AccessKey/Secret).
* **First Step**: Go to **Cluster Management** > **Cloud Credentials** to link your Alibaba account.