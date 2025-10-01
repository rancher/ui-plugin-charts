# Air-gapped Rancher

In order to have the `ui-plugin-charts` available in an air-gapped instance of Rancher manager, the [`ui-plugin-catalog`](https://hub.docker.com/r/rancher/ui-plugin-catalog/tags) image needs to accessible to the air-gapped node. After mirroring this image to a private registry, it can be deployed with an exposed service to target as a Helm repository.

## Steps

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

