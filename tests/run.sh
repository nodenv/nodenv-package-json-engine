#/usr/bin/env sh

# Tools

OK_COUNT=0
FAIL_COUNT=0

describe()
{
    if [ -n "$CURRENT_SECTION" ]; then
        printf "\n"
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

    # This echoes are required for multiline strings comparison.
    # Belive me or not, but this is not true:
    #   a="a\nb"
    #   b="$(echo 'a'; echo 'b')"
    #   [ "$a" = "$b" ]
    if [ "$(printf "$1")" = "$(printf "$2")" ]; then
        printf "    \033[32m$LABEL\033[0m\n"
        OK_COUNT=$(( OK_COUNT + 1 ))
    else
        printf "    \033[31m$LABEL\n"
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


# Import specs
. ./tests/tests.sh
. ./tests/strict_rules_tests.sh
#. ./tests/node_semver_tests.sh


# Summarize
summary



