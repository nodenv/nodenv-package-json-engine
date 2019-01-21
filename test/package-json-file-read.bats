#!/usr/bin/env bats

load test_helper

read="$BATS_TEST_DIRNAME/../libexec/nodenv-package-json-file-read"

@test 'Prints the version spec from engines.node' {
  in_example_package
  echo '{ "engines": { "node": ">= 8" } }' > package.json

  run $read package.json

   assert_success
   assert_output '>= 8'
}

@test 'Does not match arbitrary "node" key in package.json' {
  in_example_package
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

  run $read package.json

  assert_failure
  refute_output
}

@test 'Errors with non-JSON file' {
  in_example_package
  echo "foo" > package.json

  run $read package.json

  assert_failure
  refute_output
}

@test 'Errors with malformed JSON file' {
  in_example_package
  echo "{" > package.json

  run $read package.json

  assert_failure
  refute_output
}

@test 'Prints the right "node" key' {
  in_example_package
  cat << JSON > package.json
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

  run $read package.json

  assert_success
  assert_output '4.2.1'
}
