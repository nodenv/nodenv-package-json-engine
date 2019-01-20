# shellcheck shell=bash

load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

setup() {
  # common nodenv setup
  unset NODENV_VERSION

  local node_modules_bin=$BATS_TEST_DIRNAME/../node_modules/.bin

  export PATH="$BATS_TEST_DIRNAME/../bin:$node_modules_bin:/usr/bin:/bin:/usr/sbin:/sbin"

  export NODENV_ROOT="$BATS_TEST_DIRNAME/fixtures/nodenv_root"

  # custom setup
  EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"
  mkdir -p "$EXAMPLE_PACKAGE_DIR"
  cd "$EXAMPLE_PACKAGE_DIR" || return 1
}

teardown() {
  rm -f "$EXAMPLE_PACKAGE_DIR"/.node-version
  rm -rf "$EXAMPLE_PACKAGE_DIR"/package.json
  rm -f "$NODENV_ROOT/version"
}

in_example_package() {
  cd "$EXAMPLE_PACKAGE_DIR" || return 1
  echo '{}' > package.json
}

in_package_for_engine() {
  in_example_package
  cat << JSON > package.json
{
  "engines": {
    "node": "$1"
  }
}
JSON
}

in_package_with_babel_env() {
  in_example_package
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
