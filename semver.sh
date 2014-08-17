#/usr/bin/env sh

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
