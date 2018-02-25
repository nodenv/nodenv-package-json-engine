ENGINES_EXPRESSION=$(nodenv-package-json-extract-expression);
if [ -n "$ENGINES_EXPRESSION" ]; then
  NODENV_VERSION_ORIGIN="package-json-engine matching $ENGINES_EXPRESSION"
fi
