# shellcheck shell=bash

unset NODENV_VERSION

EXAMPLE_PACKAGE_DIR="$BATS_TMPDIR/example_package"

setup() {
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

assert() {
  if ! "$@"; then
    flunk "failed: $*"
  fi
}

assert_equal() {
  if [ "$1" != "$2" ]; then
    { echo "expected: $1"
      echo "actual:   $2"
    } | flunk
  fi
}

assert_output() {
  local expected
  if [ $# -eq 0 ]; then expected="$(cat -)"
  else expected="$1"
  fi
  # shellcheck disable=SC2154
  assert_equal "$expected" "$output"
}

assert_success() {
  # shellcheck disable=SC2154
  if [ "$status" -ne 0 ]; then
    flunk "command failed with exit status $status"
  elif [ "$#" -gt 0 ]; then
    assert_output "$1"
  fi
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

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } >&2
  return 1
}
