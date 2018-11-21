# shellcheck shell=bash

load ../node_modules/bats-assert/all

setup() {
  # common nodenv setup
  unset NODENV_VERSION

  local node_modules_bin=$BATS_TEST_DIRNAME/../node_modules/.bin
  local plugin_bin=$BATS_TEST_DIRNAME/../bin

  export PATH="$plugin_bin:$node_modules_bin:/usr/bin:/bin:/usr/sbin:/sbin"

  export NODENV_ROOT="$BATS_TMPDIR/nodenv_root"
  export NODENV_HOOK_PATH="$BATS_TEST_DIRNAME/../etc/nodenv.d"

  # unique

  EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"
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
