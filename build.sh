#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds a Hugo site hosted on a Cloudflare Worker.
#------------------------------------------------------------------------------

install_hugo() {
  local -r hugo_version=0.165.0
  local current_version=""

  if command -v hugo >/dev/null 2>&1; then
    current_version="$(hugo version)"
  fi
  if [[ "${current_version}" == *"hugo v${hugo_version}"* && "${current_version}" == *"+extended"* ]]; then
    return
  fi

  if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
    echo "Hugo Extended ${hugo_version} is required; run 'mise install'." >&2
    return 1
  fi

  local -r hugo_archive="hugo_extended_${hugo_version}_linux-amd64.tar.gz"
  local -r hugo_checksums="hugo_${hugo_version}_checksums.txt"
  HUGO_TMP_DIR="$(mktemp -d)"

  echo "Installing Hugo ${hugo_version}..."
  curl --fail --location --silent --show-error \
    --output "${HUGO_TMP_DIR}/${hugo_archive}" \
    "https://github.com/gohugoio/hugo/releases/download/v${hugo_version}/${hugo_archive}"
  curl --fail --location --silent --show-error \
    --output "${HUGO_TMP_DIR}/${hugo_checksums}" \
    "https://github.com/gohugoio/hugo/releases/download/v${hugo_version}/${hugo_checksums}"
  (
    cd "${HUGO_TMP_DIR}"
    grep " ${hugo_archive}$" "${hugo_checksums}" | sha256sum --check --strict
  )

  mkdir -p "${HOME}/.local/bin"
  tar -C "${HOME}/.local/bin" -xzf "${HUGO_TMP_DIR}/${hugo_archive}" hugo
  export PATH="${HOME}/.local/bin:${PATH}"
}

main() {
  export TZ=America/Sao_Paulo
  install_hugo

  echo "Using $(hugo version)"

  git config core.quotepath false
  if [ "$(git rev-parse --is-shallow-repository)" = "true" ]; then
    git fetch --unshallow
  fi

  echo "Building the site..."
  hugo --cleanDestinationDir --gc --minify --panicOnWarning
}

HUGO_TMP_DIR=""
cleanup() {
  if [[ -n "${HUGO_TMP_DIR}" ]]; then
    rm -rf "${HUGO_TMP_DIR}"
  fi
}

set -euo pipefail
trap cleanup EXIT
main "$@"
