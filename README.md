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

## How to patch an extension metadata

We now provide the ability to change metadata on published extensions in this repository. Let's cover the fundamentals on how this works.

### What metadata can be updated

- extension "card" `name`, which will be updated as `catalog.cattle.io/display-name` annotation in `Chart.yaml` and `values.yaml` (both `charts` folder and TGZ)
- extension "card" `description`, which will be updated as `description` field in `Chart.yaml` (both `charts` folder and TGZ)
- extension annotations, which will be updated in `Chart.yaml` and `values.yaml` (both `charts` folder and TGZ)
- extension `README` (present in slide-in panel when you click on extension card), which will be applied to `charts` folder  (and also same folder inside TGZ)
- extension ICON, which will be renamed, applied to `/icons` folder and path updated to point to the correct asset in in `Chart.yaml` (both `charts` folder and TGZ)


### How to apply these changes

- create a folder called `patches` in the root of this repo
- create a folder per extension. Ex: if you want to apply changes to Elemental, create a folder called `elemental` (folder name must match the same folder name as applied to other areas of this repo)
- inside that `elemental` folder create a file called `patches.json` which will contain the changes you want to apply for `name`, `description` and `annotations`, like:
```
{
  "patches": [
    {
      "versions": ">3.0.0 <4.0.0",
      "dir": "3.0.1",
      "name": "some-new-name-for-extension",
      "description": "some-new-description-for-extension",
      "annotations": {
        "a-demo-annotation111": "some-value-for-the-annotation111",
        "a-demo-annotation11122": "some-value-for-the-annotation11122"
      }
    }
  ]
}
```
- the `versions` semver check will only apply the changes to the interval (or simple condition) that you want to
- the `dir` folder is the name of the folder **inside** `elemental` folder, where file assets like `README` and `icon` will live, which will be applied as patch

### Caveats

- For the **ICON** change, the icon file must be called `icon` (it doesn't care about the file extension, since it can be a `svg` or `png`) in order for it to be considered as change
- For the **README** change: the file content must be different than the `README` originally present on the extension in order to be applied, otherwise it's ignored


### How does the script work

- starts by going through `manifest.json` and list all of the extensions we have in the repo
- goes through the `patches` folder structure and cross-checks if there's a match with the given `manifest.json` it's going through
- if there's a folder match, it goes through `patches.json`, does a check on the versions condition present on the file and see if the version of given extension on the manifest we are looking at fits as patch candidate
- if it matches, then it starts by doing checks on whether to apply any of the above changes and creates "APPLY" flags for each different metadata change
- after all checks are done, it's time to apply them. Starts by unpacking the TGZ and changing all the metadata we've check before both outside the TGZ assets and inside them as well
- once all changes are done, repacks the TGZ, applies the same permissions as the original file and regens the `index.yaml`

## Running the patch-extensions script

The `patch-extensions` script can be run with optional arguments to override the default repository organization and branch:

```bash
# Default: uses rancher organization and main branch
./scripts/patch-extensions

# Custom organization and branch (useful for testing/previewing on forks)
./scripts/patch-extensions aalves08 15413-update-names-extensions-test

# Only override organization
./scripts/patch-extensions your-github-username
```

**Parameters:**
- `$1` (optional): GitHub organization name (default: `rancher`)
- `$2` (optional): Branch name (default: `main`)

## Patching as Part of the Sync Mechanism

The `patch-extensions` script is now automatically executed as part of the sync workflow. This means that whenever extensions are synced into the repository, any patches defined for those extensions are applied immediately.

### Automated Sync Workflow

1. When `manifest.json` is updated on the `main` branch, a GitHub Actions workflow triggers automatically
2. The workflow syncs extension assets from upstream repositories
3. The `patch-extensions` script runs automatically to apply any configured patches
4. All changes (synced assets + patches) are committed together in a single PR

This ensures that patches are always applied consistently and are never missed during the sync process.

## Preventing Duplicate Patching with `.patched.json`

To prevent the same extension@version from being patched multiple times across syncs, the system maintains a `.patched.json` file that tracks which extensions have already been patched.

### How `.patched.json` Works

When patches are applied, an entry is automatically added to `.patched.json` with a timestamp:

```json
{
  "observability@2.3.1": "2026-05-14T16:38:04Z",
  "stackvista@1.0.0": "2026-05-14T16:38:04Z",
  "kubewarden@4.1.1": "2026-05-14T12:00:00Z"
}
```

**Behavior:**
- **First sync**: Extensions matching patch conditions are patched and logged to `.patched.json`
- **Subsequent syncs**: Extensions already in `.patched.json` are skipped (not re-patched)
- The `.patched.json` file is committed as part of the workflow, ensuring all environments stay in sync

### Re-patching an Extension

If you need to re-patch an extension that was previously patched:

1. **Remove the entry** from `.patched.json`:
   ```bash
   # Edit .patched.json and remove the line:
   # "observability@2.3.1": "2026-05-14T16:38:04Z",
   ```

2. **Update your patch definition** in `patches/[extension]/patches.json` as needed

3. **Commit both changes** and push
   ```bash
   git add .patched.json patches/[extension]/patches.json
   git commit -m "Re-patch observability@2.3.1"
   git push
   ```

4. The next sync will re-apply the patches to that extension@version

This explicit removal approach ensures that re-patching is intentional and visible in git history.
