#!/usr/bin/env bash

# Validate that a URL is safe to download from (SSRF prevention):
# - Must use HTTPS
# - Must be hosted on raw.githubusercontent.com or github.com
# - Must come from an allowed repository
validate_icon_url() {
  local url="$1"

  if [[ ! "$url" =~ ^https:// ]]; then
    echo "Rejected icon URL (not HTTPS): $url"
    return 1
  fi

  # Ensure URL strictly starts with allowed hosts and immediately follows with a slash
  # to prevent SSRF vulnerabilities using userinfo (@) or port (:) tricks.
  if [[ ! "$url" =~ ^https://(raw\.githubusercontent\.com|github\.com)(/.*) ]]; then
    echo "Rejected icon URL (host not allowed, must be raw.githubusercontent.com or github.com): $url"
    return 1
  fi

  local path="${BASH_REMATCH[2]}"

  # rancher/* wildcard
  if [[ "$path" =~ ^/rancher/ ]]; then
    return 0
  fi

  local -a allowed_repos=(
    "stackvista/rancher-extension-stackstate"
    "neuvector/manager-ext"
    "harvester/harvester-ui-extension"
  )

  for repo in "${allowed_repos[@]}"; do
    if [[ "$path" == "/${repo}/"* ]]; then
      return 0
    fi
  done

  echo "Rejected icon URL (repository not in allowlist): $url"
  return 1
}
