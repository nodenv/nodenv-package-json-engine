#/usr/bin/env sh

# Tools

describe()
{
    if [ -n "$CURRENT_SECTION" ]; then
        printf "\n"
    else
        OK_COUNT=0
        FAIL_COUNT=0
    fi

    CURRENT_SECTION="$1"
    CURRENT_COUNTER=1
}

assert()
{
    if [ "$CURRENT_COUNTER" = 1 ]; then
        echo "$CURRENT_SECTION:"
    fi

    LABEL=${3:-Test $CURRENT_COUNTER}

    if [ "$1" = "$2" ]; then
        printf "    \033[32m$LABEL... OK\033[0m\n"
        OK_COUNT=$(( OK_COUNT + 1 ))
    else
        printf "    \033[31m$LABEL... FAIL\n"
        printf "      \"$1\" != \"$2\"\033[0m\n"
        FAIL_COUNT=$(( FAIL_COUNT + 1 ))
    fi

    CURRENT_COUNTER=$(( CURRENT_COUNTER + 1 ))
}

summary()
{
    printf "\n"
    printf "Total:   $(( OK_COUNT + FAIL_COUNT))\n"
    printf "Succeed: $OK_COUNT\n"
    printf "Failed:  $FAIL_COUNT\n"

    if [ "$FAIL_COUNT" != 0 ]; then
        exit 1
    fi
}


# Import semver
. ./semver.sh


# Tests

describe 'get_version'
    RET=$(get_version 1.2.3.4-1.2.3.4.a.b.c-def)
    assert "$RET" "1.2.3.4"

describe 'get_labels'
    RET=$(get_labels 1.2.3.4-1.2.3.4.a.b.c-def)
    assert "$RET" "1.2.3.4.a.b.c-def"

describe 'get_major'
    RET=$(get_major 1.2.3.4)
    assert "$RET" "1"

describe 'get_minor'
    RET=$(get_minor 1.2.3.4)
    assert "$RET" "2"

    RET=$(get_minor 1)
    assert "$RET" "0"

describe 'semver_eq'
    semver_eq 1.2.3 1.2.3
    assert $? 0

    semver_eq 1.2.3 1.2.4
    assert $? 1

describe 'semver_lt'
    semver_lt 1.2.2 1.2.3
    assert $? 0

    semver_lt 1.2.3 1.2.3
    assert $? 1

    semver_lt 1.2.4 1.2.3
    assert $? 1

describe 'semver_le'
    semver_le 1.2.2 1.2.3
    assert $? 0

    semver_le 1.2.3 1.2.3
    assert $? 0

    semver_le 1.2.4 1.2.3
    assert $? 1

describe 'semver_gt'
    semver_gt 1.2.2 1.2.3
    assert $? 1

    semver_gt 1.2.3 1.2.3
    assert $? 1

    semver_gt 1.2.4 1.2.3
    assert $? 0

describe 'semver_ge'
    semver_ge 1.2.2 1.2.3
    assert $? 1

    semver_ge 1.2.3 1.2.3
    assert $? 0

    semver_ge 1.2.4 1.2.3
    assert $? 0

describe 'regex_match'
    regex_match "1.22.333 - 1.2.3-3.2.1-a.b.c-def+011.a.1" "$RE_VER - $RE_VER"
    assert $? 0                                             "Exit code should be 0 when match"
    assert "$MATCHED_VER_1" "1.22.333"                      "Should set MATCHED_VER_1"
    assert "$MATCHED_VER_2" "1.2.3-3.2.1-a.b.c-def+011.a.1" "Should set MATCHED_VER_2"
    assert "$MATCHED_NUM_1" "1.22.333"                      "Should set MATCHED_NUM_1"
    assert "$MATCHED_NUM_2" "1.2.3"                         "Should set MATCHED_NUM_2"
    assert "$MATCHED_LAB_1" ""                              "Should set MATCHED_LAB_1"
    assert "$MATCHED_LAB_2" "3.2.1-a.b.c-def"               "Should set MATCHED_LAB_2"

    regex_match '1.2.3 - 5.6.7' '5.6.7'
    assert $? 1                                             "Exit code should be 1 when don't match"
    assert "$MATCHED_VER_1" ""                              "When don't match MATCHED_VER_x should be empty"
    assert "$MATCHED_VER_1" ""                              "When don't match MATCHED_NUM_x should be empty"
    assert "$MATCHED_LAB_1" ""                              "When don't match MATCHED_LAB_x should be empty"

describe 'reslove_rule'
    RET=$(resolve_rule 'v1.2.3')
    assert "$RET" "eq 1.2.3"                                "Specific (v1.2.3)"

    RET=$(resolve_rule '1')
    assert "$RET" "eq 1"                                    "Specific (1)"

    RET=$(resolve_rule '=1.2.3-a.2-c')
    assert "$RET" "eq 1.2.3-a.2-c"                          "Specific (=1.2.3-a.2-c)"

    RET=$(resolve_rule '>1.2.3')
    assert "$RET" "gt 1.2.3"                                "Greater than (>1.2.3)"

    RET=$(resolve_rule '<1.2.3')
    assert "$RET" "lt 1.2.3"                                "Less than (<1.2.3)"

    RET=$(resolve_rule '>=1.2.3')
    assert "$RET" "ge 1.2.3"                                "Greater than or equal to (>=1.2.3)"

    RET=$(resolve_rule '<=1.2.3')
    assert "$RET" "le 1.2.3"                                "Less than or equal to (<=1.2.3)"

    RET=$(resolve_rule '1.2.3 - 4.5.6')
    assert "$RET" "ge_le 1.2.3 4.5.6"                       "Range (1.2.3 - 4.5.6)"

    RET=$(resolve_rule '>1.2.3 <4.5.6')
    assert "$RET" "gt_lt 1.2.3 4.5.6"                       "Range (>1.2.3 <4.5.6)"

    RET=$(resolve_rule '>1.2.3 <=4.5.6')
    assert "$RET" "gt_le 1.2.3 4.5.6"                       "Range (>1.2.3 <=4.5.6)"

    RET=$(resolve_rule '>=1.2.3 <4.5.6')
    assert "$RET" "ge_lt 1.2.3 4.5.6"                       "Range (>=1.2.3 <4.5.6)"

    RET=$(resolve_rule '>=1.2.3 <=4.5.6')
    assert "$RET" "ge_le 1.2.3 4.5.6"                       "Range (>=1.2.3 <=4.5.6)"

    RET=$(resolve_rule '~1.2.3')
    assert "$RET" "tilde 1.2.3"                             "Tilde (~1.2.3)"

    #RET=$(resolve_rule '1.2.x')
    #assert "$RET" "tilde 1.2"                               "Wildcard (1.2.x)"

    #RET=$(resolve_rule '1.*')
    #assert "$RET" "tilde 1"                                 "Wildcard (1.*)"

    RET=$(resolve_rule '^1.2.3')
    assert "$RET" "caret 1.2.3"                             "Caret (^1.2.3)"

describe "rule_eq"
    rule_eq '1.2.3' '1.2.3'
    assert $? 0

    rule_eq '1.2.3-abc+abc' '1.2.3-abc+xyz'
    assert $? 0

    rule_eq '1.2.3-a' '1.2.3-b'
    assert $? 1

describe "rule_gt_lt"
    rule_gt_lt '1.2.3' '2.3.4' '1.2.3'
    assert $? 1

    rule_gt_lt '1.2.3' '2.3.4' '2.1.0'
    assert $? 0

    rule_gt_lt '1.2.3' '2.3.4' '2.3.4'
    assert $? 1

describe "rule_gt_le"
    rule_gt_le '1.2.3' '2.3.4' '1.2.3'
    assert $? 1

    rule_gt_le '1.2.3' '2.3.4' '2.1.0'
    assert $? 0

    rule_gt_le '1.2.3' '2.3.4' '2.3.4'
    assert $? 0

describe "rule_ge_lt"
    rule_ge_lt '1.2.3' '2.3.4' '1.2.3'
    assert $? 0

    rule_ge_lt '1.2.3' '2.3.4' '2.1.0'
    assert $? 0

    rule_ge_lt '1.2.3' '2.3.4' '2.3.4'
    assert $? 1

describe "rule_ge_le"
    rule_ge_le '1.2.3' '2.3.4' '1.2.3'
    assert $? 0

    rule_ge_le '1.2.3' '2.3.4' '2.1.0'
    assert $? 0

    rule_ge_le '1.2.3' '2.3.4' '2.3.4'
    assert $? 0

describe "rule_tilde"
    rule_tilde '1.2.3' '1.2.2'
    assert $? 1

    rule_tilde '1.2.3' '1.2.5'
    assert $? 0

    rule_tilde '1.2.3' '1.3.0'
    assert $? 1


# Summary
summary
