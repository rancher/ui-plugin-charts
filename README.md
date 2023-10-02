# Rancher UI Plugin Charts

This repository contains Helm charts for official UI Plugins (Extensions) from Rancher

## Install

### Air-gapped Rancher

In order to have the `ui-plugin-charts` available in an air-gapped instance of Rancher manager, the [`ui-plugin-catalog`](https://hub.docker.com/r/rancher/ui-plugin-catalog/tags) image needs to accessible to the air-gapped node. After mirroring this image to a private registry, it can be deployed with an exposed service to target as a Helm repository.

#### Steps

1. Mirror the [`ui-plugin-catalog`](https://hub.docker.com/r/rancher/ui-plugin-catalog/tags) image into a private registry.

```console
export REGISTRY_ENDPOINT="my-private-registry.com"

docker pull rancher/ui-plugin-catalog:1.0.0
docker tag rancher/ui-plugin-catalog:1.0.0 $REGISTRY_ENDPOINT/rancher/ui-plugin-catalog:1.0.0
docker push $REGISTRY_ENDPOINT/rancher/ui-plugin-catalog:1.0.0
```

2. Create a [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) with the mirrored image.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui-plugin-catalog
  namespace: cattle-ui-plugin-system
  labels:
    catalog.cattle.io/ui-extensions-catalog-image: ui-plugin-catalog
spec:
  replicas: 1
  selector:
    matchLabels:
      catalog.cattle.io/ui-extensions-catalog-image: ui-plugin-catalog
  template:
    metadata:
      namespace: cattle-ui-plugin-system
      labels:
        catalog.cattle.io/ui-extensions-catalog-image: ui-plugin-catalog
    spec:
      containers:
      - name: server
        image: my-private-registry.com/rancher/ui-plugin-catalog:1.0.0
        imagePullPolicy: Always
      imagePullSecrets:
        - name: my-registry-credentials
```

3. Create a [ClusterIP Service](https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip) to expose the Deployment.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ui-plugin-catalog-svc
  namespace: cattle-ui-plugin-system
spec:
  ports:
    - name: catalog-svc-port
      port: 8080
      protocol: TCP
      targetPort: 8080
  selector:
    catalog.cattle.io/ui-extensions-catalog-image: ui-plugin-catalog
  type: ClusterIP
```

4. Create a [`ClusterRepo`](https://ranchermanager.docs.rancher.com/pages-for-subheaders/helm-charts-in-rancher) targeting the ClusterIP Service.

```yaml
apiVersion: catalog.cattle.io/v1
kind: ClusterRepo
metadata:
  name: ui-plugin-catalog-repo
spec:
  url: http://ui-plugin-catalog-svc.cattle-ui-plugin-system:8080
```

After creation of these resources, the ui-plugin-charts listed in the manifest are now available to be installed within the air-gapped instance of Rancher Manager.

## Contributing

### Requirements

* Charts must be Helm 3 compatible.

* Chart must be **published** in a **public Github** repository that we can reference.

### Workflow

#### 1. Fork the [UI Plugin Charts](https://github.com/rancher/ui-plugin-charts) repository, clone your fork, checkout the **main** branch and pull the latest changes. 
Then create a new branch off of main

#### 2. Update the `manifest.json` with your Extension metadata.

```json
{
  "extensions": {
    "kubewarden": {
      "repo": "rancher/kubewarden-ui",
      "branch": "gh-pages",
      "versions": [
        "1.0.0",
        "1.1.0",
        "1.2.0
      ]
    }
  }
}
```

#### 3. Commit your changes
```bash
git add manifest.json
git commit -m "Submitting rancher/kubewarden-ui version 1.2.0"
```

#### 4. Push your commit
```bash
git push origin <your_branch>
```

#### 5. Open a pull request on the **main** branch

Once your pull request is approved and merged, an automated workflow will sync this repository with the build assets from the supplied repository within the `manifest.json` file. When fully synced, a new release will be created and added to the [releases](https://github.com/rancher/ui-plugin-charts/releases) section. 

### Configuration File

Required properties for `manifest.json`
| Property | Type | Description |
| --------- | :---: | ------------- |
| `[extension key]` | `Object` | This object is representative of the Extension **package** name. For example, the [clock](https://github.com/rancher/ui-plugin-examples/tree/main/pkg/clock) package within the [`ui-plugin-examples`](https://github.com/rancher/ui-plugin-examples/tree/main) repository, `clock` would be the extension key.
| `repo` | `String` | Defines the upstream **Github** repository to pull the build assets from.
| `branch` | `String` | Defines which branch to pull from the upstream `repo`
| `versions` | `String[]` | An array of version strings which correspond to the Extension **package** version(s) to be synced with this repository. For example, the [clock](https://github.com/rancher/ui-plugin-examples/tree/main/charts/clock) extension package has two versions, `0.1.0` and `0.2.0` would be added.

### Examples

```json
{
  "extensions": {
    "elemental": {
      "repo": "rancher/elemental-ui",
      "branch": "main",
      "versions": [
        "1.2.0",
        "1.1.0",
        "1.0.0"
      ]
    },
    "kubewarden": {
      "repo": "kubewarden/ui",
      "branch": "gh-pages",
      "versions": [
        "1.0.0",
        "1.0.1",
        "1.0.2",
        "1.0.3",
        "1.0.4",
        "1.0.5",
        "1.0.6",
        "1.1.0",
        "1.2.0"
      ]
    }
  }
}
```


