if [ -n "$(nodenv-sh-shell 2>/dev/null)" ] ||
  [ -n "$(nodenv-local 2>/dev/null)" ]; then
  return
fi

if NODENV_PACKAGE_JSON_VERSION=$(nodenv-package-json 2>/dev/null) &&
  [ -n "$NODENV_PACKAGE_JSON_VERSION" ]; then
  export NODENV_VERSION=$NODENV_PACKAGE_JSON_VERSION
fi
