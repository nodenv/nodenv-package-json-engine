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
    regex_match '1.2.3 - 5.6.7' '(.*) - (.*)'
    assert $? 0
    assert "$REGEX_MATCHED_GROUP_0" "1.2.3 - 5.6.7"
    assert "$REGEX_MATCHED_GROUP_1" "1.2.3"
    assert "$REGEX_MATCHED_GROUP_2" "5.6.7"
    assert "$REGEX_MATCHED_GROUP_3" ""

    regex_match '1.2.3 - 5.6.7' '5.6.7'
    assert $? 1
    assert "$REGEX_MATCHED_GROUP_0" ""
    assert "$REGEX_MATCHED_GROUP_1" ""
    assert "$REGEX_MATCHED_GROUP_2" ""
    assert "$REGEX_MATCHED_GROUP_3" ""


# Summary
summary
