#!/usr/bin/env bats

load test_helper

@test 'Recognizes simple node version specified in package.json engines' {
  in_package_for_engine 4.2.1

  run nodenv version
  assert_success
  assert_output "4.2.1 => node-x.y.z (set by $PWD/package.json#engines.node)"
}

@test 'Prefers the greatest installed version matching a range' {
  in_package_for_engine '^4.0.0'

  run nodenv version
  assert_success
  assert_output "4.2.1 => node-x.y.z (set by $PWD/package.json#engines.node)"
}

@test 'Ignores non-matching installed versions' {
  in_package_for_engine '^1.0.0'

  run nodenv version
  assert_failure
  assert_output - <<-MSG
package-json-engine: version satisfying \`^1.0.0' is not installed
MSG
}

@test 'Prefers nodenv-local over package.json' {
  in_package_for_engine 4.2.1
  nodenv local 5.0.0

  run nodenv version
  assert_success
  assert_output "5.0.0 => node-x.y.z (set by $PWD/.node-version)"
}

@test 'Prefers nodenv-shell over package.json' {
  in_package_for_engine 4.2.1

  NODENV_VERSION=5.0.0 run nodenv version
  assert_success
  assert_output "5.0.0 => node-x.y.z (set by NODENV_VERSION environment variable)"
}

@test 'Prefers package.json over nodenv-global' {
  in_package_for_engine 4.2.1
  nodenv global 5.0.0

  run nodenv version-name
  assert_success
  assert_output '4.2.1'
}

@test 'Is not confused by nodenv-shell shadowing nodenv-global' {
  in_package_for_engine 4.2.1
  nodenv global 5.0.0

  NODENV_VERSION=5.0.0 run nodenv version
  assert_success
  assert_output "5.0.0 => node-x.y.z (set by NODENV_VERSION environment variable)"
}

@test 'Does not match arbitrary "node" key in package.json' {
  in_package_with_babel_env

  run nodenv version-name

  assert_success
  assert_output 'system'
}

@test 'Handles missing package.json' {
  in_example_package

  run nodenv version-name

  assert_success
  assert_output 'system'
}

@test 'Does not fail with unreadable package.json' {
  in_example_package
  touch package.json
  chmod a-r package.json

  run nodenv version-name

  assert_success
  assert_output 'system'
}

@test 'Does not fail with non-file package.json' {
  in_example_package
  mkdir package.json

  run nodenv version-name

  assert_success
  assert_output 'system'
}

@test 'Does not fail with empty or malformed package.json' {
  in_example_package

  # empty
  touch package.json
  run nodenv version-name
  assert_success
  assert_output 'system'

  # non json
  echo "foo" >package.json
  run nodenv version-name
  assert_success
  assert_output 'system'

  # malformed
  echo "{" >package.json
  run nodenv version-name
  assert_success
  assert_output 'system'
}

@test 'Handles multiple occurrences of "node" key' {
  in_example_package
  cat <<JSON >package.json
{
  "engines": {
    "node": "4.2.1"
  },
  "presets": [
    ["env", {
      "targets": {
        "node": "current"
      }
    }]
  ]
}
JSON

  run nodenv version-name
  assert_success
  assert_output '4.2.1'
}
