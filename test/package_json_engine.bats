#!/usr/bin/env bats

load test_helper

@test 'Recognizes simple node version' {
  create_version 4.2.1
  cd_into_package 4.2.1
  run nodenv package-json-engine
  assert_success '4.2.1'
}

@test 'Recognizes semver range matching an installed version' {
  create_version 4.2.1
  cd_into_package '>= 4.0.0'
  run nodenv package-json-engine
  assert_success '4.2.1'
}

@test 'Prefers the greatest installed version matching a range' {
  create_version 4.0.0
  create_version 4.2.1
  cd_into_package '^4.0.0'
  run nodenv package-json-engine
  assert_success '4.2.1'
}

@test 'Ignores non-matching installed versions' {
  create_version 0.12.7
  cd_into_package '>= 4.0.0'
  run nodenv package-json-engine
  assert [ "$output" = '>= 4.0.0' ]
  assert [ "$status" -eq 1 ]
}

@test 'Prefers `nodenv local` over package.json' {
  create_version 5.0.0
  cd_into_package 4.2.1
  nodenv local 5.0.0
  run nodenv package-json-engine
  assert_success ''
}

@test 'Prefers `nodenv shell` over package.json' {
  create_version 5.0.0
  cd_into_package 4.2.1
  eval "$(nodenv sh-shell 5.0.0)"
  run nodenv package-json-engine
  assert_success ''
}

@test 'Prefers package.json over `nodenv global`' {
  create_version 4.2.1
  create_version 5.0.0
  cd_into_package 4.2.1
  nodenv global 5.0.0
  run nodenv package-json-engine
  assert_success '4.2.1'
}
