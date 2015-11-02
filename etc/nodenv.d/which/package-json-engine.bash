NODENV_PACKAGE_JSON_VERSION=$(nodenv-package-json-engine)

if [ -n "$NODENV_PACKAGE_JSON_VERSION" ]; then
  NODENV_COMMAND_PATH="${NODENV_ROOT}/versions/${NODENV_PACKAGE_JSON_VERSION}/bin/${NODENV_COMMAND}"

  if ! [ -d "${NODENV_ROOT}/versions/${NODENV_PACKAGE_JSON_VERSION}" ]; then
    echo "package-json-engine: version \`$NODENV_PACKAGE_JSON_VERSION' is not installed" >&2
    exit 1
  fi
fi
