# Rancher UI Plugin Charts

This repository contains Helm charts for official UI Plugins (Extensions) from Rancher

## Requirements

* Charts must be Helm 3 compatible.

* Chart must be **published** in a **public Github** repository that we can reference.

## Workflow

### 1. Fork the [UI Plugin Charts](https://github.com/rancher/ui-plugin-charts) repository, clone your fork, checkout the **main** branch and pull the latest changes. 
Then create a new branch off of main

### 2. Update the `manifest.json` with your Extension metadata.

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

### 3. Commit your changes
```bash
git add manifest.json
git commit -m "Submitting rancher/kubewarden-ui version 1.2.0"
```

### 4. Push your commit
```bash
git push origin <your_branch>
```

### 5. Open a pull request on the **main** branch

Once your pull request is approved and merged, an automated workflow will sync this repository with the build assets from the supplied repository within the `manifest.json` file and generate a PR with all the new files to update the Helm Chart, which will need review and approval

### 6. Merging PR that updates Helm Chart

Once the PR that updates Helm Chart is approved and merged, the Helm Chart in the `main` branch should be automatically updated. After this, a new automated workflow will run that 
will release the extensions catalog (airgapped) and also create a release tag in the repository.

## Configuration File

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


