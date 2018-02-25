source "$(plugin_root)/libexec/nodenv-package-json-engine"

ENGINES_EXPRESSION=$(get_expression_respecting_precedence);
if [ -n "$ENGINES_EXPRESSION" ]; then
  NODENV_VERSION_ORIGIN="package-json-engine matching $ENGINES_EXPRESSION"
fi
