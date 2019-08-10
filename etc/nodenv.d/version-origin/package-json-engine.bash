#!/bin/bash

# shellcheck source=libexec/nodenv-package-json-engine
source "$(plugin_root)/libexec/nodenv-package-json-engine"

ENGINES_EXPRESSION=$(get_expression_respecting_precedence);
if [ -n "$ENGINES_EXPRESSION" ]; then
  NODENV_VERSION_ORIGIN="$(package_json_path)#engines.node"
  export NODENV_VERSION_ORIGIN
fi
