if [ -n "$(nodenv-sh-shell 2>/dev/null)" ] ||
  [ -n "$(nodenv-local 2>/dev/null)" ]; then
  return
fi

READLINK=$(type -p greadlink readlink | head -1)
[ -n "$READLINK" ] || return 1

abs_dirname() {
  local cwd="$PWD"
  local path="$1"

  while [ -n "$path" ]; do
    cd "${path%/*}"
    local name="${path##*/}"
    path="$($READLINK "$name" || true)"
  done

  pwd
  cd "$cwd"
}

bin_path="$(abs_dirname "${BASH_SOURCE[0]}")/../../../libexec"

if NODENV_PACKAGE_JSON_VERSION=$(nodenv-package-json 2>/dev/null) &&
  [ -n "$NODENV_PACKAGE_JSON_VERSION" ]; then
  NODENV_PACKAGE_JSON_FILE=$("$bin_path/nodenv-package-json-file")
  NODENV_PACKAGE_JSON_SPEC=$("$bin_path/nodenv-package-json-file-read" "$NODENV_PACKAGE_JSON_FILE")
  # shellcheck disable=2034
  NODENV_VERSION_ORIGIN="satisfying \`$NODENV_PACKAGE_JSON_SPEC' from $NODENV_PACKAGE_JSON_FILE#engines.node"
fi
