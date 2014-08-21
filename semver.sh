#/usr/bin/env sh

_num_part='([0-9]|[1-9][0-9]*)'
_lab_part='([0-9]|[1-9][0-9]*|[0-9]*[a-zA-Z-][a-zA-Z0-9-]*)'
_met_part='([0-9A-Za-z-]+)'

RE_NUM="$_num_part(\.$_num_part)*"
RE_LAB="$_lab_part(\.$_lab_part)*"
RE_MET="$_met_part(\.$_met_part)*"
RE_VER="$RE_NUM(-$RE_LAB)?(\+$RE_MET)?"


get_version()
{
    echo -n ${1%%-*}
}

get_labels()
{
    local labels=${1#*-}
    if [ "$labels" != "$1" ]; then
        echo -n "$labels"
    fi

}

semver_eq()
{
    [ "$1" = "$2" ] && return 0 || return 1
}

semver_lt()
{
    local version_a=$(get_version $1)
    local version_b=$(get_version $2)
    local labels_a=$(get_labels $1)
    local labels_b=$(get_labels $2)

    local head_a=''
    local head_b=''
    local rest_a=$version_a
    local rest_b=$version_b
    while [ -n "$rest_a" ] || [ -n "$rest_b" ]; do
        head_a=${rest_a%%.*}
        head_b=${rest_b%%.*}
        rest_a=${rest_a#*.}
        rest_b=${rest_b#*.}
        [ "$rest_a" = "$head_a" ] && rest_a=''
        [ "$rest_b" = "$head_b" ] && rest_b=''
        [ -z "$head_a" ] && head_a=0
        [ -z "$head_b" ] && head_b=0

        if [ "$head_a" -eq "$head_b" ]; then
            continue
        fi

        if [ "$head_a" -lt "$head_b" ]; then
            return 0
        else
            return 1
        fi
    done

    if [ -n "$labels_a" ] && [ -z "$labels_b" ]; then
        return 0
    fi

    return 1
}

semver_gt()
{
    if semver_lt "$1" "$2" || semver_eq "$1" "$2"; then
        return 1
    else
        return 0
    fi
}

semver_le()
{
    semver_gt "$1" "$2" && return 1 || return 0
}

semver_ge()
{
    semver_lt "$1" "$2" && return 1 || return 0
}

regex_match()
{
    local string="$1"
    local regexp="$2"
    local bre="$(eval "echo '$regexp' | sed 's/\\([(){}]\\)/\\\\\\1/g'")"
    local match="$(eval "echo '$string' | grep --extended-regexp --line-regexp '$regexp'")";

    for i in $(seq 0 9); do
        unset "MATCHED_VER_$i"
        unset "MATCHED_NUM_$i"
        unset "MATCHED_LAB_$i"
    done

    if [ -z "$match" ]; then
        return 1
    fi

    local part
    local i=1
    for part in $(echo $string); do
        local ver="$(eval "echo '$part' | grep --extended-regexp --only-matching '$RE_VER'")";
        local num="$(eval "echo '$part' | grep -E -o '$RE_NUM' | head -n1")";
        local lab="$(eval "echo '$part' | grep -E -o '\-$RE_LAB' | cut -c 2-")";

        if [ -n "$ver" ]; then
            eval "MATCHED_VER_$i='$ver'"
            eval "MATCHED_NUM_$i='$num'"
            eval "MATCHED_LAB_$i='$lab'"
            i=$(( i + 1 ))
        fi
    done

    return 0
}

resolve_rule()
{
    # Specific version
    if regex_match "$1" "$RE_VER"; then
        echo "specific $MATCHED_VER_1"

    # Greater than
    elif regex_match "$1" ">$RE_VER"; then
        echo "gt $MATCHED_VER_1"

    # Less than
    elif regex_match "$1" "<$RE_VER"; then
        echo "lt $MATCHED_VER_1"

    # Greater than or equal to
    elif regex_match "$1" ">=$RE_VER"; then
        echo "ge $MATCHED_VER_1"

    # Less than or equal to
    elif regex_match "$1" "<=$RE_VER"; then
        echo "le $MATCHED_VER_1"

    # Ranges
    elif regex_match "$1" "$RE_VER - $RE_VER"; then
        echo "ge_le $MATCHED_VER_1 $MATCHED_VER_2"
    elif regex_match "$1" ">$RE_VER <$RE_VER"; then
        echo "gt_lt $MATCHED_VER_1 $MATCHED_VER_2"
    elif regex_match "$1" ">$RE_VER <=$RE_VER"; then
        echo "gt_le $MATCHED_VER_1 $MATCHED_VER_2"
    elif regex_match "$1" ">=$RE_VER <$RE_VER"; then
        echo "ge_lt $MATCHED_VER_1 $MATCHED_VER_2"
    elif regex_match "$1" ">=$RE_VER <=$RE_VER"; then
        echo "ge_le $MATCHED_VER_1 $MATCHED_VER_2"

    # Tilde
    elif regex_match "$1" "~$RE_VER"; then
        echo "tilde $MATCHED_VER_1"
    elif regex_match "$1" "$RE_NUM(\.[x*])+"; then
        echo "tilde $MATCHED_VER_1"

    # Caret
    elif regex_match "$1" "\^$RE_VER"; then
        echo "caret $MATCHED_VER_1"

    else
        return 1
    fi

    return 0
}
