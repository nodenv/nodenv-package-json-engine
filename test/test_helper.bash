# shellcheck shell=bash

load ../node_modules/bats-assert/all

setup() {
  # common nodenv setup
  unset NODENV_VERSION

  local node_modules_bin=$BATS_TEST_DIRNAME/../node_modules/.bin

  export PATH="$node_modules_bin:/usr/bin:/bin:/usr/sbin:/sbin"

  export NODENV_ROOT="$BATS_TEST_DIRNAME/fixtures/nodenv_root"

  # unique

  EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"
}

teardown() {
  rm -r "$EXAMPLE_PACKAGE_DIR"
  rm "$NODENV_ROOT"/versions/*
  rm -f "$NODENV_ROOT/version"
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

with_installed_node_versions() {
  for v in "$@"; do
    ln -fhs $BATS_TEST_DIRNAME/fixtures/node-x.y.z/ $NODENV_ROOT/versions/$v
  done
}
