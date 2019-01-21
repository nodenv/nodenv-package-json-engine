#!/usr/bin/env bats

load test_helper

@test 'Recognizes simple node version specified in package.json engines' {
  in_package_for_engine 4.2.1

  run nodenv package-json
  assert_success
  assert_output '4.2.1'
}

@test 'Prefers the greatest installed version matching a range' {
  in_package_for_engine '^4.0.0'

  run nodenv package-json
  assert_success
  assert_output '4.2.1'
}

@test 'Ignores non-matching installed versions' {
  in_package_for_engine '^1.0.0'

  run nodenv package-json
  assert_failure
  assert_output "package-json-engine: no version found satisfying \`^1.0.0'"
}
