# shellcheck shell=bash

load ../node_modules/bats-assert/all

EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"
mkdir -p "$EXAMPLE_PACKAGE_DIR"

setup() {
  # common nodenv setup
  unset NODENV_VERSION

  local node_modules_bin=$BATS_TEST_DIRNAME/../node_modules/.bin

  export PATH="$node_modules_bin:/usr/bin:/bin:/usr/sbin:/sbin"

  export NODENV_ROOT="$BATS_TEST_DIRNAME/fixtures/nodenv_root"
}

teardown() {
  rm "$EXAMPLE_PACKAGE_DIR"/.node-version
  rm "$EXAMPLE_PACKAGE_DIR"/package.json
  rm "$NODENV_ROOT"/versions/*
  rm -f "$NODENV_ROOT/version"
}

in_package_for_engine() {
  cd "$EXAMPLE_PACKAGE_DIR" || return 1
  cat << JSON > package.json
{
  "engines": {
    "node": "$1"
  }
}
JSON
}

cd_into_babel_env_package() {
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
    ln -fhs "$BATS_TEST_DIRNAME/fixtures/node-x.y.z/" "$NODENV_ROOT/versions/$v"
  done
}
