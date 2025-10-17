#!/bin/sh

ci=false
if echo "$@" | grep -qoE '(--ci)'; then
  ci=true
fi

only_check=false
if echo "$@" | grep -qoE '(--only-check)'; then
  only_check=true
fi

with_retry() {
  retries=5
  count=0
  output=""
  status=0

  while [ $count -lt $retries ]; do
    output=$("$@" 2>&1)
    status=$?

    if echo "$output" | grep -q 'Not Found'; then
      count=$((count + 1))
      echo "attempt $count/$retries: 404 Not Found encountered, retrying..." >&2
      sleep 1
    else
      echo "[TRACE] [cmd=$*] output: $output" 1>&2
      echo "$output" | tr -d '\000-\031'
      return $status
    fi
  done

  echo "max retries reached. last output: $output (cmd=$*)" >&2
  exit 1
}

get_lunar_latest() {
  with_retry curl -sL "https://launcherupdates.lunarclientcdn.com/latest-linux.yml" 2>/dev/null
}

get_xmcl_latest() {
  with_retry curl -sL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/Voxelum/x-minecraft-launcher/releases/latest" 2>/dev/null
}

# Helper function to safely write to GITHUB_OUTPUT
write_output() {
  if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "$1" >>"$GITHUB_OUTPUT"
  fi
}

commit_lunar_version=""
commit_xmcl_version=""

update_lunar() {
  echo "Checking Lunar Client version..."

  metadata=$(get_lunar_latest)
  remote_version=$(echo "$metadata" | grep "^version:" | sed 's/version: //' | tr -d '\r')
  remote_hash=$(echo "$metadata" | grep "^sha512:" | sed 's/sha512: //' | tr -d '\r')

  local_version=$(jq -r '.lunar.version' sources.json)

  echo "Local: $local_version | Remote: $remote_version"

  if [ "$local_version" = "$remote_version" ]; then
    echo "Lunar Client is up to date"
    return
  fi

  echo "Lunar Client version mismatch, updating..."

  if $only_check; then
    write_output "should_update=true"
    exit 0
  fi

  url="https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${remote_version}.AppImage"

  # Prefetch the AppImage with a valid name
  echo "Prefetching Lunar Client AppImage..."
  prefetch_output=$(nix store prefetch-file --json --name "lunarclient-${remote_version}.AppImage" "$url")
  sha256=$(echo "$prefetch_output" | jq -r '.hash')

  # We also want to keep the sha512 for reference
  hash="sha512-${remote_hash}"

  # Update sources.json
  jq --arg version "$remote_version" \
    --arg hash "$hash" \
    --arg url "$url" \
    '.lunar.version = $version | .lunar.hash = $hash | .lunar.url = $url' \
    sources.json >sources.json.tmp
  mv sources.json.tmp sources.json

  echo "Updated Lunar Client to $remote_version"

  if $ci; then
    commit_lunar_version="$remote_version"
  fi
}

update_xmcl() {
  echo "Checking XMCL version..."

  release=$(get_xmcl_latest)
  remote_version=$(echo "$release" | jq -r '.tag_name' | sed 's/^v//')

  local_version=$(jq -r '.xmcl.version' sources.json)

  echo "Local: $local_version | Remote: $remote_version"

  if [ "$local_version" = "$remote_version" ]; then
    echo "XMCL is up to date"
    return
  fi

  echo "XMCL version mismatch, updating..."

  if $only_check; then
    write_output "should_update=true"
    exit 0
  fi

  url="https://github.com/Voxelum/x-minecraft-launcher/releases/download/v${remote_version}/xmcl-${remote_version}-x86_64.AppImage"

  # Prefetch the AppImage
  echo "Prefetching XMCL AppImage..."
  prefetch_output=$(nix store prefetch-file --json "$url")
  hash=$(echo "$prefetch_output" | jq -r '.hash')

  # Update sources.json
  jq --arg version "$remote_version" \
    --arg hash "$hash" \
    --arg url "$url" \
    '.xmcl.version = $version | .xmcl.hash = $hash | .xmcl.url = $url' \
    sources.json >sources.json.tmp
  mv sources.json.tmp sources.json

  echo "Updated XMCL to $remote_version"

  if $ci; then
    commit_xmcl_version="$remote_version"
  fi
}

main() {
  set -e

  update_lunar
  update_xmcl

  if $only_check && $ci; then
    write_output "should_update=false"
  fi

  # Check if there are changes
  if ! git diff --exit-code sources.json >/dev/null 2>&1; then
    # Prepare commit message
    init_message="chore(update):"
    message="$init_message"

    if [ "$commit_lunar_version" != "" ]; then
      message="$message lunar to $commit_lunar_version"
    fi

    if [ "$commit_xmcl_version" != "" ]; then
      if [ "$message" != "$init_message" ]; then
        message="$message and"
      fi
      message="$message xmcl to $commit_xmcl_version"
    fi

    write_output "commit_message=$message"
  fi
}

main
