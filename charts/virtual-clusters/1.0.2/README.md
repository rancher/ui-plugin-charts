# SUSE Virtual Clusters

**Provisions and isolates lightweight K3s clusters within shared environments for multi-tenancy.**

### Overview
SUSE Virtual Clusters solve the "Cluster Sprawl" problem. Instead of provisioning 50 heavy, expensive cloud clusters for 50 developers, you can spin up 50 virtual K3s clusters inside a single "Host" cluster. This provides full API isolation at a fraction of the infrastructure cost.

Documentation for SUSE Virtual Clusters can be found [here](https://documentation.suse.com/cloudnative/suse-virtual-clusters/latest/en/introduction.html).

### Core Architecture
K3k (Kubernetes-in-Kubernetes) runs a K3s control plane as a set of Pods within a namespace of a host cluster. It supports **Shared Mode** (pods run on host nodes) for maximum efficiency or **Isolated Mode** for high-security environments, using virtualized networking to separate traffic.

### Key Technical Features
* **Extreme Resource Efficiency**: Consolidate multiple Kubernetes control planes onto a single set of nodes, reducing cloud compute costs by up to 80%.
* **Full Cluster-Admin Isolation**: Tenants get full `cluster-admin` privileges within their virtual bubble, allowing them to install CRDs and manage namespaces without affecting the host.
* **Instant Lifecycle**: Provision or delete a fully functional Kubernetes cluster in under 30 seconds—perfect for ephemeral CI/CD test environments.
* **Resource Quotas**: Set strict CPU/Memory limits on the virtual cluster itself to ensure no single tenant can "starve" the host cluster.

### Target Use Cases
* **Developer Self-Service**: Giving every engineer their own dedicated cluster playground that doesn't cost a fortune.
* **SaaS Tenant Isolation**: Hosting multiple customers on shared hardware while ensuring they cannot see or impact each other's workloads.

### Deployment Path
* **Prerequisites**: Rancher Prime subscription; a host cluster with sufficient capacity (RKE2 or K3s).
* **First Step**: Navigate to **SUSE Virtual Clusters** in the sidebar and click **Create** to deploy your first K3k instance.