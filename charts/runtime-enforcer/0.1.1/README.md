# SUSE Security Runtime Enforcer

**Provides runtime enforcement to observe process executions in your workloads and to enforce allow-list based security policies at the kernel level.**

### Overview
SUSE's Cloud Native product family introduces additional value with greater security assurances, extended lifecycles, access to focused architectures and Kubernetes advisories. It will also offer options to get production support for innovative Cloud Native projects. With SUSE's Cloud Native, installation assets are hosted on a trusted registry owned and managed by SUSE.

SUSE Security Runtime Enforcer is a high-performance runtime security engine that provides deep visibility and active protection for containerized workloads. Using eBPF, it learns application behavior to identify, alert on, and deny unauthorized process execution or anomalous activity in real time. This helps ensure strict adherence to zero-trust security policies.

Documentation for SUSE Security Runtime Enforcer can be found [**here**](https://documentation.suse.com/cloudnative/runtime-enforcer/latest/en/installation/quickstart.html).

### Core Architecture

SUSE Security Runtime Enforcer runs as three cooperating components in the Kubernetes cluster:

* **Controller manager**: Watches `WorkloadPolicy` and `WorkloadPolicyProposal` resources, coordinates policy assignment, and periodically collects violation status from node agents.
* **Node agents**: Observe process executions on each node and generate a policy proposal from the executables seen in each workload. Once a workload is associated with a `WorkloadPolicy`, agents report violations in monitor mode or block disallowed executions in protect mode.
* **OpenTelemetry collector**: Runs as a standalone deployment and receives violation events from agents for forwarding and metrics. The controller also records recent violations in policy status, so an external observability stack is not required to inspect them.

The workflow is: agents observe workload activity, proposals provide an initial allow-list, and an operator promotes a proposal to a policy and associates it with the workload. Policies can first run in monitor mode to report unexpected executions, then switch to protect mode to enforce the allow-list at the kernel level.


### Key Technical Features

* **eBPF-Based Runtime Visibility**: Observe process executions in workloads at the node level, with workload and container context.
* **Learn Mode**: Build a `WorkloadPolicyProposal` from observed executables to help establish an allow-list for each workload.
* **Monitor and Protect Modes**: Report executions outside an approved policy in monitor mode, or block them at the kernel level in protect mode.
* **Kubernetes-Native Policies**: Define and manage proposals and allow-list policies through Kubernetes custom resources, and bind policies to workloads.
* **Violation Reporting**: Review recent violations in policy status and forward events and metrics through the included OpenTelemetry collector or a configured external collector.


### Target Use Cases

* **Establish Workload Baselines**: Observe normal process activity and create an executable allow-list proposal for each workload.
* **Validate Policies Safely**: Run policies in monitor mode to identify unexpected executions and tune allow-lists before enforcing them.
* **Prevent Unauthorized Execution**: Apply protect-mode policies to block processes that are not on the approved allow-list, especially for sensitive workloads.
* **Investigate Runtime Violations**: Review violation details by workload and container, forward telemetry to observability tools, and acknowledge resolved events.


### Deployment Path

**Prerequisites**

* A Kubernetes cluster with `kubectl` and Helm available.
* cert-manager installed with its CRDs enabled, plus the cert-manager CSI driver for mounting certificates into the agent and OpenTelemetry collector pods.

**Install**

Install the chart into its own namespace:

```bash
helm repo add runtime-enforcer oci://dp.apps.rancher.io/charts/suse-security-runtime-enforcer
helm repo update
helm install runtime-enforcer runtime-enforcer/runtime-enforcer \
	--namespace runtime-enforcer \
	--create-namespace \
	--wait
```

Verify that the controller manager, node agents, and OpenTelemetry collector are running:

```bash
kubectl get pods -n runtime-enforcer
```

**Apply a Policy**

1. Deploy the workload to protect. The node agents observe its process executions and create a `WorkloadPolicyProposal` with the observed executables.
2. Review the proposal and promote it to a `WorkloadPolicy` in monitor mode. Associate the policy with the workload by setting the `security.rancher.io/policy` label on its pod template before pods are created.
3. Review reported violations and adjust the allow-list as needed. When the policy is ready, switch it to protect mode to block unapproved executions.

The included OpenTelemetry collector forwards violation events and exposes metrics. An external collector can be configured instead. See the [SUSE Security Runtime Enforcer Quick Start](https://documentation.suse.com/cloudnative/runtime-enforcer/latest/en/installation/quickstart.html) for detailed configuration and operational guidance.

