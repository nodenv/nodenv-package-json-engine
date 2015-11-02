#!/usr/bin/env bats

load test_helper

@test 'Allow overriding version with nodenv local' {
  cd_into_package 4.2.1
  create_version 5.0.0
  nodenv local 5.0.0
  run nodenv package-json-engine
  assert_success ''
}

@test 'Recognize simple node version' {
  cd_into_package 4.2.1
  run nodenv package-json-engine
  assert_success '4.2.1'
}
