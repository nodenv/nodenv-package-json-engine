#!/usr/bin/env bats

load test_helper

nodenv_package_json_file="$BATS_TEST_DIRNAME/../libexec/nodenv-package-json-file"

@test 'Looks in provided directory' {
  in_example_package
  cd ..

  run "$nodenv_package_json_file" "$EXAMPLE_PACKAGE_DIR"

  assert_success
  assert_output "$EXAMPLE_PACKAGE_DIR/package.json"
}

@test 'Looks in $NODENV_DIR by default' {
  in_example_package
  cd ..

  NODENV_DIR="$EXAMPLE_PACKAGE_DIR" run "$nodenv_package_json_file"

  assert_success
  assert_output "$EXAMPLE_PACKAGE_DIR/package.json"
}

@test 'Falls back to $PWD' {
  in_example_package

  run "$nodenv_package_json_file"

  assert_success
  assert_output "$EXAMPLE_PACKAGE_DIR/package.json"
}

@test 'Works up the directory hierarchy' {
  in_example_package
  mkdir -p "sub/dir"
  cd "sub/dir"

  run "$nodenv_package_json_file"

  assert_success
  assert_output "$EXAMPLE_PACKAGE_DIR/package.json"
}

@test 'Exits non-zero when missing package.json' {
  in_example_package
  rm package.json

  run "$nodenv_package_json_file"

  assert_failure
  refute_output
}

@test 'Treats non-readable same as missing' {
  in_example_package
  chmod -r package.json

  run "$nodenv_package_json_file"

  assert_failure
  refute_output
}

@test 'Treats non-file same as missing' {
  in_example_package
  rm package.json
  mkdir package.json

  run "$nodenv_package_json_file"

  assert_failure
  refute_output
}

@test 'Treats empty same as missing' {
  in_example_package
  > package.json

  run "$nodenv_package_json_file"

  assert_failure
  refute_output
}
