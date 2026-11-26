#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Version range matching for `scripts/patch-extensions`.
#
# A "range" is the `versions` string used by patches/<ext>/patches.json. It is a
# space separated list of conditions joined by a logical AND, for example:
#
#   ">= 4.1.4"             every version from 4.1.4 upwards
#   ">= 1.7.2 < 1.7.999"   the 1.7.x line only
#   "3.0.1"                that exact version
#
# THIS IS THE SINGLE SOURCE OF TRUTH FOR RANGE MATCHING. `scripts/patch-extensions`
# sources it to decide which versions a patch entry applies to. Anything else that
# needs to evaluate a `versions` range should source this rather than reimplement it.
# ------------------------------------------------------------------------------

# --- Convert SemVer to a zero padded, string sortable format ---
semver_to_sortable() {
  local version=$(echo "$1" | tr '+' '-' | cut -d '-' -f 1)

  [[ -z "$version" ]] && return 1

  local PADDED_VERSION

  # Read components into an array
  IFS='.' read -r -a V_PARTS <<< "$version"

  for part in "${V_PARTS[@]}"; do
    PADDED_VERSION+="$(printf '%03d' "$part")."
  done

  echo "${PADDED_VERSION%.}"
}

# --- Compare two versions (V1 operator V2) ---
semver_check() {
  local V1="$1"
  local OP="$2"
  local V2="$3"

  local SV1=$(semver_to_sortable "$V1")
  local SV2=$(semver_to_sortable "$V2")

  if [[ "$OP" == "=" ]]; then
    [[ "$SV1" == "$SV2" ]]
  elif [[ "$OP" == ">" ]]; then
    [[ "$SV1" > "$SV2" ]]
  elif [[ "$OP" == "<" ]]; then
    [[ "$SV1" < "$SV2" ]]
  elif [[ "$OP" == ">=" ]]; then
    [[ "$SV1" == "$SV2" || "$SV1" > "$SV2" ]]
  elif [[ "$OP" == "<=" ]]; then
    [[ "$SV1" == "$SV2" || "$SV1" < "$SV2" ]]
  else
    echo "Error: Invalid operator $OP" >&2
    return 1
  fi
}

# --- Does VERSION satisfy every condition in RANGE? ---
# usage: version_matches_range <version> <range>
# returns 0 when the version matches, 1 when it does not or the range is unparseable
version_matches_range() {
  local VERSION="$1"
  local VERSION_RANGE="$2"

  [[ -z "$VERSION_RANGE" || "$VERSION_RANGE" == "N/A" ]] && return 1

  # Split the range string by space into tokens, then merge any standalone operator
  # token (e.g. ">=") with the following version token so that ">= 4.1.4" is treated
  # as one condition ">=4.1.4", not two.
  local RAW_TOKENS CONDITIONS _i _token _next
  IFS=' ' read -r -a RAW_TOKENS <<< "$VERSION_RANGE"
  CONDITIONS=()
  _i=0
  while [[ $_i -lt ${#RAW_TOKENS[@]} ]]; do
    _token="${RAW_TOKENS[$_i]}"
    if [[ "$_token" =~ ^(>=|<=|>|<|=)$ ]]; then
      _next=$(( _i + 1 ))
      if [[ $_next -lt ${#RAW_TOKENS[@]} ]]; then
        CONDITIONS+=("${_token}${RAW_TOKENS[$_next]}")
        _i=$(( _i + 2 ))
      else
        CONDITIONS+=("$_token")
        _i=$(( _i + 1 ))
      fi
    else
      CONDITIONS+=("$_token")
      _i=$(( _i + 1 ))
    fi
  done

  local CONDITION OP V2
  for CONDITION in "${CONDITIONS[@]}"; do
    if [[ "$CONDITION" == ">="* ]]; then
      OP=">="
      V2="${CONDITION:2}"
    elif [[ "$CONDITION" == "<="* ]]; then
      OP="<="
      V2="${CONDITION:2}"
    elif [[ "$CONDITION" == ">"* ]]; then
      OP=">"
      V2="${CONDITION:1}"
    elif [[ "$CONDITION" == "<"* ]]; then
      OP="<"
      V2="${CONDITION:1}"
    elif [[ "$CONDITION" == "="* ]]; then
      OP="="
      V2="${CONDITION:1}"
    elif [[ "$CONDITION" =~ ^[0-9] ]]; then
      OP="="
      V2="$CONDITION"
    else
      echo "⚠️ Sub-condition failed due to unparseable version range: $CONDITION" >&2
      return 1
    fi

    if ! semver_check "$VERSION" "$OP" "$V2"; then
      return 1
    fi
  done

  return 0
}
