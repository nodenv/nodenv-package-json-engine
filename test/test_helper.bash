# shellcheck shell=bash

load ../node_modules/bats-assert/all

setup() {
  unset NODENV_VERSION

  EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"

  export NODENV_ROOT="$BATS_TMPDIR/nodenv_root"

  PATH="$(npm bin):/usr/bin:/bin:/usr/sbin:/sbin"
  PATH="${BATS_TEST_DIRNAME}/../bin:$PATH"
  export PATH

  eval "$(nodenv init -)"
}

teardown() {
  rm -r "$EXAMPLE_PACKAGE_DIR"
  rm -r "$NODENV_ROOT"
}

# cd_into_package nodeVersion [extraArgs]
cd_into_package() {
  mkdir -p "$EXAMPLE_PACKAGE_DIR"
  cd "$EXAMPLE_PACKAGE_DIR" || return 1
  local version="$1"
  cat << JSON > package.json
{
  "engines": {
    "node": "$version"
  }
}
JSON
}

cd_into_babel_env_package() {
  mkdir -p "$EXAMPLE_PACKAGE_DIR"
  cd "$EXAMPLE_PACKAGE_DIR" || return 1
  cat << JSON > package.json
{
  "presets": [
    ["env", {
      "targets": {
        "node": "current"
      }
    }]
  ]
}
JSON
}

# Creates fake version directory
create_version() {
  d="$NODENV_ROOT/versions/$1/bin"
  mkdir -p "$d"
  ln -s /bin/echo "$d/node"
}
