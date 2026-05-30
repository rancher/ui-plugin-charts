# SUSE Virtualization

**Integrates and manages hyperconverged infrastructure for unified container and VM operations.**

### Overview
SUSE Virtualization is the modern, open-source alternative to legacy virtualization stacks. This extension integrates SUSE Virtualization directly into Rancher, allowing you to manage Virtual Machines (VMs) and Containers side-by-side, sharing the same networking and storage backend.

### Core Architecture
Built on KubeVirt and Longhorn, SUSE Virtualization turns bare-metal servers into a hyperconverged cluster. The Rancher extension allows you to manage these SUSE Virtualization clusters as "Virtualization Management" nodes, enabling VM operations through the standard Kubernetes API.

### Key Technical Features
* **Unified VM Management**: Create, delete, and live-migrate VMs with the same ease as deploying a Pod.
* **HCI Storage (Longhorn)**: Integrated distributed block storage that provides high availability for VM volumes.
* **Advanced Networking**: Support for VLANs, untagged networks, and bridge interfaces via Multus.
* **Cloud-Init Automation**: Declarative bootstrapping of VM guests using standard cloud-config scripts.

### Target Use Cases
* **Legacy Modernization**: Running "un-containerizable" legacy apps in VMs alongside new K8s microservices.
* **Private Cloud**: Building a self-service VM portal for development teams without expensive proprietary licensing.

### Deployment Path
* **Prerequisites**: At least one SUSE Virtualization HCI cluster installed on bare metal.
* **First Step**: Navigate to **Virtualization Management** and click **Import** to link your SUSE Virtualization cluster.