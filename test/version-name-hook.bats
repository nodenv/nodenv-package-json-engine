#!/usr/bin/env bats

load test_helper

@test 'Prefers nodenv-shell over package.json' {
  in_package_for_engine 4.2.1

  NODENV_VERSION=5.0.0 run nodenv version-name
  assert_success
  assert_output '5.0.0'
}

@test 'Prefers nodenv-local over package.json' {
  in_package_for_engine 4.2.1
  nodenv local 5.0.0

  run nodenv version-name
  assert_success
  assert_output '5.0.0'
}

@test 'Prefers package.json over nodenv-global' {
  in_package_for_engine 4.2.1
  nodenv global 5.0.0

  run nodenv version-name
  assert_success
  assert_output '4.2.1'
}

@test 'Mutes error output from nodenv-package' {
  in_example_package

  run nodenv version-name

  assert_success
  assert_output 'system'
}
