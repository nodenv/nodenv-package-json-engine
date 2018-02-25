if ! NODENV_PACKAGE_JSON_VERSION=$(nodenv-package-json-engine); then
  echo "package-json-engine: no version satisfying \`$NODENV_PACKAGE_JSON_VERSION' installed" >&2
  exit 1
elif [ -n "$NODENV_PACKAGE_JSON_VERSION" ]; then
  NODENV_VERSION="${NODENV_PACKAGE_JSON_VERSION}"
fi
