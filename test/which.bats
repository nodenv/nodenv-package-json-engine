#!/usr/bin/env bats

load test_helper

@test 'exits with error when node version in package.json is not installed' {
  cd_into_package 4.2.1
  run nodenv which node
  assert [ "$status" -eq 1 ]
}

@test 'which recognizes node version in package.json' {
  create_version 4.2.1
  cd_into_package 4.2.1
  run nodenv which node
  assert_success "${NODENV_ROOT}/versions/4.2.1/bin/node"
}
