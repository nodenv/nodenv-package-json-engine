#!/usr/bin/env bats

load test_helper

@test 'Recognizes simple node version specified in package.json engines' {
  in_package_for_engine 4.2.1

  run nodenv version
  assert_success '4.2.1 (set by package-json-engine matching 4.2.1)'
}

@test 'Prefers the greatest installed version matching a range' {
  in_package_for_engine '^4.0.0'

  run nodenv version
  assert_success '4.2.1 (set by package-json-engine matching ^4.0.0)'
}

@test 'Ignores non-matching installed versions' {
  in_package_for_engine '^1.0.0'

  # For unknown reasons, nodenv-version succeeds when version-name fails,
  # so we're testing version-name directly
  run nodenv version-name
  assert_failure "package-json-engine: no version satisfying \`^1.0.0' installed"

  # `which` should fail similarly
  run nodenv which node
  assert_failure "package-json-engine: no version satisfying \`^1.0.0' installed"
}

@test 'Prefers nodenv-local over package.json' {
  in_package_for_engine 4.2.1
  nodenv local 5.0.0

  run nodenv version
  assert_success "5.0.0 (set by $PWD/.node-version)"
}

@test 'Prefers nodenv-shell over package.json' {
  in_package_for_engine 4.2.1

  NODENV_VERSION=5.0.0 run nodenv version
  assert_success "5.0.0 (set by NODENV_VERSION environment variable)"
}

@test 'Prefers package.json over nodenv-global' {
  in_package_for_engine 4.2.1
  nodenv global 5.0.0

  run nodenv version-name
  assert_success '4.2.1'
}

@test 'Is not confused by nodenv-shell shadowing nodenv-global' {
  in_package_for_engine 4.2.1
  nodenv global 5.0.0

  NODENV_VERSION=5.0.0 run nodenv version
  assert_success "5.0.0 (set by NODENV_VERSION environment variable)"
}

@test 'Does not match babel preset env settings' {
  cd_into_babel_env_package

  run nodenv version-name

  assert_success 'system'
}
