# shellcheck source=libexec/nodenv-package-json-engine
source "$(plugin_root)/libexec/nodenv-package-json-engine"

if ! NODENV_PACKAGE_JSON_VERSION=$(get_version_respecting_precedence); then
  echo "package-json-engine: version satisfying \`$(get_expression_respecting_precedence)' is not installed" >&2
  exit 1
elif [ -n "$NODENV_PACKAGE_JSON_VERSION" ]; then
  # shellcheck disable=2034
  NODENV_VERSION="${NODENV_PACKAGE_JSON_VERSION}"
fi
unset NODENV_PACKAGE_JSON_VERSION
