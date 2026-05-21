# SUSE OS Management

**Automates and manages cloud-native OS lifecycles for immutable infrastructure deployments.**

### Vision & Value
SUSE OS Management revolutionizes node management by treating the Operating System as just another Kubernetes resource. It enables a "bare-metal-to-cluster" workflow that removes the need for traditional, complex configuration management tools (like Ansible or Salt) by using a cloud-native, image-based approach.

### Core Architecture
SUSE OS Management uses a "containerized" build of SLE Micro. The entire OS stack is stored as an OCI image in your container registry. When a node boots, it pulls its entire identity and system state from the registry, ensuring a 100% predictable, immutable system.

### Key Technical Features
* **OCI-Based OS Delivery**: Ship your Operating System updates via the same registry you use for application containers.
* **Zero-Touch Provisioning (ZTP)**: New hardware registers automatically with Rancher via `MachineRegistration` upon first boot.
* **Immutable Infrastructure**: Prevents configuration drift by ensuring the system disk is read-only and state is managed declaratively.
* **Full-Stack Upgrades**: Trigger rolling OS and Kubernetes upgrades simultaneously from the Rancher UI.

### Target Use Cases
* **Edge Computing**: Managing hundreds of remote, headless nodes with zero local IT staff.
* **Secure Data Centers**: Enforcing immutable system states to prevent unauthorized persistent changes (malware/drift).

### Deployment Path
* **Prerequisites**: A cluster running the SUSE OS Management Operator.
* **First Step**: Create a **Machine Registration** in the SUSE OS Management sidebar to generate your initial boot ISO.

### Documentation
Documentation for SUSE OS Management can be found [here](https://documentation.suse.com/cloudnative/os-manager/latest/en/index.html).