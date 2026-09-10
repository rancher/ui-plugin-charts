# SUSE CAPI AWS (CAPA) Provisioning

**Provisions and manages AWS EC2-backed Kubernetes clusters via Cluster API directly from the Rancher UI.**

### Overview
The SUSE CAPI AWS extension brings upstream Cluster API Provider AWS (CAPA) into the Rancher Prime experience. Instead of relying on Rancher's legacy node driver, it lets you provision and manage RKE2 clusters on AWS entirely through a native, declarative workflow — using the same CAPI controllers that the wider Kubernetes ecosystem depends on.

Documentation for SUSE CAPI AWS Provisioning can be found [**here**](https://documentation.suse.com/cloudnative/rancher-srfa/latest/en/cluster-deployment/configuration/capi-infrastructure-providers.html).

This extension is **experimental** and available to Rancher Prime customers.


### Core Architecture
This extension integrates with [Rancher Turtles](https://github.com/rancher/turtles) as the backend operator responsible for deploying and reconciling CAPI infrastructure providers. The UI extension registers directly into Rancher's cluster provisioner extension point, managing three layers of CAPI resources on the user's behalf: an `AWSCluster` (VPC, subnets, security groups, load balancer), per-pool `AWSMachineTemplate` (EC2 instance configuration), and the `provisioning.cattle.io.cluster` binding that ties them together.

### Key Technical Features
* **Managed or Unmanaged Networking**: Let CAPA auto-create your VPC, subnets, and security groups, or bring your own existing infrastructure.
* **Flexible Machine Pools**: Configure EC2 instance type, AMI, IAM instance profile, EBS volumes, and spot/on-demand/capacity-block pricing per pool.
* **Full Cluster Lifecycle**: Create, edit, and scale CAPA clusters from Rancher — including machine template immutability handled transparently (new templates are created on edit and old ones cleaned up only after a successful save).
* **Advanced Security Controls**: Fine-grained security group overrides and additional ingress rules per role (control plane, worker, load balancer), with automatic updates when the CNI changes.
* **IPv6 Support**: Optional dual-stack networking for clusters that require it.

### Target Use Cases
* **AWS-Native Provisioning**: Teams that want to manage AWS clusters through CAPI controllers rather than Rancher's legacy node drivers.
* **Multi-Cloud Standardisation**: Organizations standardising cluster lifecycle management across providers using the upstream CAPI model.

### Deployment Path
* **Prerequisites**: Rancher Prime subscription; Rancher Turtles installed on the management cluster with the AWS CAPI provider enabled; IAM roles and instance profiles pre-configured via `clusterawsadm`; an AWS cloud credential registered in Rancher.
* **First Step**: Go to **Cluster Management** > **Create** and select the **CAPI AWS** provisioner card.

See [USAGE.md](./USAGE.md) for full usage instructions (creating/editing clusters, troubleshooting), and the [project README](https://github.com/rancher/prov-capi-ui-extensions) for guidance on building similar extensions for other infrastructure providers.
