#!/bin/bash

# shellcheck source=libexec/nodenv-package-json-engine
source "$(plugin_root)/libexec/nodenv-package-json-engine"

if ! NODENV_PACKAGE_JSON_VERSION=$(get_version_respecting_precedence); then
  echo "package-json-engine: no version satisfying \`$(get_expression_respecting_precedence)' installed" >&2
  exit 1
elif [ -n "$NODENV_PACKAGE_JSON_VERSION" ]; then
  export NODENV_VERSION="${NODENV_PACKAGE_JSON_VERSION}"
fi
