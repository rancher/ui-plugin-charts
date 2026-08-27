# SUSE UI Extension to support Rancher v2 provisioning via CAPI CAPA

Adds a **CAPI AWS** option to Rancher's cluster creation page, letting you provision and manage Kubernetes clusters on AWS through [Cluster API Provider AWS (CAPA)](https://cluster-api-aws.sigs.k8s.io/) instead of the classic AWS node driver.

With this extension installed you can:

- Provision a new RKE2/K3s cluster on AWS with a managed VPC (CAPA creates the VPC, subnets and security groups for you) or bring your own VPC/subnets.
- Configure network security: additional ingress rules for the control plane, worker nodes and CNI, plus optional security-group overrides and IPv6 support.
- Configure machine pools per-AWS-instance details: instance type, AMI, IAM instance profile, root/additional EBS volumes, on-demand/spot/capacity-block pricing, and resource tags.
- Edit an existing CAPA cluster's infrastructure and machine pool configuration from Rancher, the same way you would any other cluster.

## Requirements

- Rancher `>= 2.15.0` (Rancher Prime) with UI Extensions `>= 3.0.0 < 4.0.0`.
- [Rancher Turtles](https://github.com/rancher/turtles) installed, with the AWS infrastructure provider enabled.

This extension is experimental and available to Rancher Prime customers.

See [USAGE.md](./USAGE.md) for full usage instructions (creating/editing clusters, troubleshooting), and the [project README](https://github.com/rancher/prov-capi-ui-extensions) for guidance on building similar extensions for other infrastructure providers.
