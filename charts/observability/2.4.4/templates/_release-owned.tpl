{{- /*
  Renders when the looked-up object is absent or owned by this release.
  Omitting an owned object makes Helm delete it on upgrade.
  Usage: include "suse-observability-extension.absentOrOwned" (list (lookup ...) $)
*/ -}}
{{- define "suse-observability-extension.absentOrOwned" -}}
{{- $obj := index . 0 | default dict -}}
{{- $root := index . 1 -}}
{{- $owner := dig "metadata" "annotations" "meta.helm.sh/release-name" "" $obj -}}
{{- $ownerNs := dig "metadata" "annotations" "meta.helm.sh/release-namespace" "" $obj -}}
{{- if or (not $obj) (and (eq $owner $root.Release.Name) (eq $ownerNs $root.Release.Namespace)) -}}
true
{{- end -}}
{{- end -}}
