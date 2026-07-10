#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Builds a Hugo site hosted on a Cloudflare Worker.
#------------------------------------------------------------------------------

main() {
  readonly HUGO_VERSION=0.162.1
  readonly HUGO_ARCHIVE="hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  readonly HUGO_CHECKSUMS="hugo_${HUGO_VERSION}_checksums.txt"
  export TZ=America/Sao_Paulo
  HUGO_TMP_DIR="$(mktemp -d)"

  echo "Installing Hugo ${HUGO_VERSION}..."
  curl --fail --location --silent --show-error \
    --output "${HUGO_TMP_DIR}/${HUGO_ARCHIVE}" \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_ARCHIVE}"
  curl --fail --location --silent --show-error \
    --output "${HUGO_TMP_DIR}/${HUGO_CHECKSUMS}" \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_CHECKSUMS}"
  (
    cd "${HUGO_TMP_DIR}"
    grep " ${HUGO_ARCHIVE}$" "${HUGO_CHECKSUMS}" | sha256sum --check --strict
  )

  mkdir -p "${HOME}/.local/bin"
  tar -C "${HOME}/.local/bin" -xzf "${HUGO_TMP_DIR}/${HUGO_ARCHIVE}" hugo
  export PATH="${HOME}/.local/bin:${PATH}"

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
