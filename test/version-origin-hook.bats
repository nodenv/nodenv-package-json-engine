#!/usr/bin/env bats

load test_helper

@test 'Prefers nodenv-shell over package.json' {
  in_package_for_engine 4.2.1

  NODENV_VERSION=5.0.0 run nodenv version-origin
  assert_success
  assert_output 'NODENV_VERSION environment variable'
}

@test 'Prefers nodenv-local over package.json' {
  in_package_for_engine 4.2.1
  nodenv local 5.0.0

  run nodenv version-origin
  assert_success
  assert_output "$PWD/.node-version"
}

@test 'Prefers package.json over nodenv-global' {
  in_package_for_engine '>= 4'
  nodenv global 5.0.0

  run nodenv version-origin
  assert_success
  assert_output "satisfying \`>= 4' from $PWD/package.json#engines.node"
}

@test 'Mutes error output from nodenv-package' {
  in_example_package

  run nodenv version-origin

  assert_success
  assert_output "$NODENV_ROOT/version"
}
