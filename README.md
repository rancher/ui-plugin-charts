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

## Which versions ship in the airgap catalog image

Everything listed in `manifest.json` is published to the GitHub Helm repo at
`rancher/ui-plugin-charts`, which is the repo connected Rancher installs use. Adding a version here is still a
plain append, and versions are not removed from the manifest as a matter of routine.

The **airgap catalog image** (`rancher/ui-plugin-catalog`) is different. Every version in it costs airgap
customers bandwidth and disk, and the image had grown past a gigabyte, so it ships a filtered subset:

> **For each major version, keep the last 3 minors, and for each of those keep only the latest patch.**

For example, Kubewarden publishes 63 versions; the image ships 10 of them — `1.4.3`, `1.5.0`, `1.6.10`,
`2.0.1`, `2.1.6`, `3.0.3`, `3.1.3`, `4.0.3`, `4.1.5`, `4.2.3`.

The filter is applied at build time by `scripts/bundle-catalog`, not by editing the manifest. That means the
policy is reversible — change the rule and the next image is different — and that no installed extension ever
loses the endpoint it loads from.

### What this means when you add a version

Nothing changes about how you add one: append it to `manifest.json` as before.

Be aware that the image contents are a sliding window, so **adding a version can push another one out of the
image**. Publishing Kubewarden `4.3.0` means major 4 has four minor lines, so `4.0.3` stops being bundled. The
version is still published to the Helm repo and still installable on connected clusters; it just stops being
available to new airgap installs.

You do not need to work this out by hand. CI posts the before/after image contents on every PR that touches
`manifest.json` (`.github/workflows/catalog-contents-report.yml`), so the effect is visible in review.

### Exceptions

Sometimes a version has to stay in the image even though the rule would drop it — almost always because it is
the only build compatible with a Rancher line we still support. Declare those under `versionPolicy.exceptions`,
with a reason:

```json
{
  "versionPolicy": {
    "minorsPerMajor": 3,
    "exceptions": {
      "harvester": [
        { "version": "1.0.6", "reason": "Newest Harvester build compatible with Rancher 2.10 (requires >= 2.10.1)" }
      ]
    }
  },
  "extensions": { "...": {} }
}
```

Harvester is the live example: it has only ever shipped major 1, so the rule alone would leave Rancher 2.10,
2.11 and 2.12 with no compatible build in the image at all.

Before adding an exception, check the `catalog.cattle.io/rancher-version` annotation in that version's
`Chart.yaml` — that is what decides whether dropping it leaves a supported Rancher release with nothing to
install. When a Rancher line goes EOL, the exceptions that existed only to serve it should be removed.

An exception can only ever re-add a version that is already in the manifest; it cannot introduce one we do not
publish.

### Working with the policy locally

```bash
# what the catalog image would contain
./scripts/catalog-versions

# just one extension, as bundle-catalog asks for it
./scripts/catalog-versions --ext kubewarden

# machine-readable
./scripts/catalog-versions --format json

# flag exceptions that no longer point at a published version
./scripts/catalog-versions --warn

# what a manifest change would do to the image
./scripts/catalog-report <base-manifest> [<head-manifest>]

# unit tests for the resolver
./scripts/test-catalog-versions
```

`scripts/catalog-versions` is the single source of truth for catalog contents. `scripts/bundle-catalog` calls it
to decide what to bundle and CI calls it to build the report, so the report cannot drift from what ships. Do not
reimplement the rule anywhere else.

### Removing a version deliberately

The policy is about what the image ships. If a version needs to be **withdrawn** — a bad release, a security
problem — remove it from `manifest.json` as normal. `scripts/sync-charts` still deletes its chart, extension and
asset directories on the next sync, and it disappears from both the Helm repo and the image.

Note that doing so breaks any connected cluster currently running that version: the installed `UIPlugin` CR
points at `raw.githubusercontent.com/rancher/ui-plugin-charts/main/extensions/<name>/<version>`, and Rancher
re-fetches from there whenever its plugin cache is rebuilt. That is the right behaviour for a withdrawal, and
the reason routine cleanup is not done this way.

### Checking the catalog still builds

The catalog build takes about 4-5 minutes, so it runs as a dry run — building the image and stopping before the
push — on **every PR that touches `manifest.json`**, alongside the contents report. A PR therefore exercises
exactly what a release will do.

The same job also runs **weekly on a schedule**, because `scripts/bundle-catalog` fetches its Dockerfile and
packaging scripts from `rancher/dashboard` master at build time, unpinned:

```bash
git checkout subdir/master -- shell/scripts/extension/helm
```

A change on dashboard master can break the catalog release with no commit in this repository at all, and no PR
trigger would ever catch it.

Both paths call the same reusable workflow (`.github/workflows/catalog-build-dry-run.yml`), so there is no
second copy of the build steps to drift. It can be run on demand from the Actions tab, or locally:

```bash
./scripts/bundle-catalog --tag dry-run --dry-run
```

The dry run needs no registry credentials, so it also works on pull requests from forks.

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
