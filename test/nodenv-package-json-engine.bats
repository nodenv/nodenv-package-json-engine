#!/usr/bin/env bats

load test_helper

@test 'Recognizes simple node version specified in package.json engines' {
  with_installed_node_versions 4.2.1
  cd_into_package 4.2.1

  run nodenv version
  assert_success '4.2.1 (set by package-json-engine matching 4.2.1)'
  run nodenv which node
  assert_success "${NODENV_ROOT}/versions/4.2.1/bin/node"
}

@test 'Recognizes a semver range matching an installed version' {
  with_installed_node_versions 4.2.1
  cd_into_package '>= 4.0.0'

  run nodenv version
  assert_success '4.2.1 (set by package-json-engine matching >= 4.0.0)'
}

@test 'Prefers the greatest installed version matching a range' {
  with_installed_node_versions 4.0.0 4.2.1
  cd_into_package '^4.0.0'

  run nodenv version
  assert_success '4.2.1 (set by package-json-engine matching ^4.0.0)'
}

@test 'Ignores non-matching installed versions' {
  with_installed_node_versions 0.12.7
  cd_into_package '>= 4.0.0'

  # For unknown reasons, nodenv-version succeeds when version-name fails,
  # so we're testing version-name directly
  run nodenv version-name
  assert [ "$output" = "package-json-engine: no version satisfying \`>= 4.0.0' installed" ]
  assert [ "$status" -eq 1 ]

  # `which` should fail similarly
  run nodenv which node
  assert echo "$output" | grep 'no version satisfying'
  assert [ "$status" -eq 1 ]
}

@test 'Prefers nodenv-local over package.json' {
  with_installed_node_versions 4.2.1 5.0.0
  cd_into_package 4.2.1
  nodenv local 5.0.0

  run nodenv version
  assert_success "5.0.0 (set by $PWD/.node-version)"
}

@test 'Prefers nodenv-shell over package.json' {
  with_installed_node_versions 5.0.0
  cd_into_package 4.2.1
  eval "$(nodenv sh-shell 5.0.0)"

  run nodenv version
  assert_success "5.0.0 (set by NODENV_VERSION environment variable)"
}

@test 'Prefers package.json over nodenv-global' {
  with_installed_node_versions 4.2.1 5.0.0
  cd_into_package 4.2.1
  nodenv global 5.0.0

  run nodenv version-name
  assert_success '4.2.1'
}

@test 'Is not confused by nodenv-shell shadowing nodenv-global' {
  with_installed_node_versions 4.2.1 5.0.0
  cd_into_package 4.2.1
  nodenv global 5.0.0
  eval "$(nodenv sh-shell 5.0.0)"

  run nodenv version-name
  assert_success '5.0.0'
}

@test 'Does not match babel preset env settings' {
  with_installed_node_versions 4.2.1
  cd_into_babel_env_package
  run nodenv version-name
  assert_success 'system'
}
