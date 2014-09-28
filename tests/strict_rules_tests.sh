
describe 'Strict ranges'

while read -r line; do
    if [ -z "$line" ] || [ "${line#\#}" != "${line}" ]; then
        continue
    fi

    parts=$(echo "$line" | sed 's/ \{2,\}/#/g')

    rule=$( echo "$parts" | cut -d "#" -f 1)
    ver=$(  echo "$parts" | cut -d "#" -f 2)
    mode=$( echo "$parts" | cut -d "#" -f 3)
    ret=$(  eval "./semver.sh -r '$rule' '$ver'")
    #ret=$(  eval "semver -r '$rule' '$ver'")

    if [ "$mode" = "false" ]; then
        assert "$ret" "" "$ver should not match the range $rule"
    else
        assert "$ret" "$ver" "$ver should match the range $rule"
    fi

done <<EOF

# Less than

<1.0.0          0.0.0       true
<1.0.0          0.5.0-b     false
<1.0.0          0.5.0       true
<1.0.0          1.0.0-0     false
<1.0.0          1.0.0       false
<1.0.0          2.0.0       false
<1.0.0-a.b      0.0.0       true
<1.0.0-a.b      0.5.0-4     false
<1.0.0-a.b      1.0.0-a     true
<1.0.0-a.b      1.0.0-a.b   false
<1.0.0-a.b      1.0.0-a.b.0  false
<1.0.0-a.b      1.0.0       false


# Less than or equal

<=1.0.0         0.0.0       true
<=1.0.0         0.5.0-b     false
<=1.0.0         0.5.0       true
<=1.0.0         1.0.0-0     false
<=1.0.0         1.0.0       true
<=1.0.0         2.0.0       false
<=1.0.0-a.b     0.0.0       true
<=1.0.0-a.b     0.5.0-4     false
<=1.0.0-a.b     1.0.0-a     true
<=1.0.0-a.b     1.0.0-a.b   true
<=1.0.0-a.b     1.0.0-a.b.0  false
<=1.0.0-a.b     1.0.0       false


# Greater than

>1.0.0         0.9.99      false
>1.0.0         1.0.0       false
>1.0.0         1.0.1-b     false
>1.0.0         1.0.1       true
>1.0.0         2.0.0-0     false
>1.0.0         2.0.0       true
>1.0.0-a.b     0.9.99      false
>1.0.0-a.b     1.0.0-a     false
>1.0.0-a.b     1.0.0-a.b   false
>1.0.0-a.b     1.0.0-a.c   true
>1.0.0-a.b     1.0.0       true
>1.0.0-a.b     2.5.0-4     false
>1.0.0-a.b     2.5.0       true


# Greater than or equal

>=1.0.0        0.9.99      false
>=1.0.0        1.0.0       true
>=1.0.0        1.0.1-b     false
>=1.0.0        1.0.1       true
>=1.0.0        2.0.0-0     false
>=1.0.0        2.0.0       true
>=1.0.0-a.b    0.9.99      false
>=1.0.0-a.b    1.0.0-a     false
>=1.0.0-a.b    1.0.0-a.b   true
>=1.0.0-a.b    1.0.0-a.c   true
>=1.0.0-a.b    1.0.0       true
>=1.0.0-a.b    2.5.0-4     false
>=1.0.0-a.b    2.5.0       true


# Specific version

1               0.0.99      false
1               1.0.0       true
1               1.2.3-0     false
1               1.2.3       true
1               2.0.0       false
1.2             1.1.99      false
1.2             1.2.0       true
1.2             1.2.3-0     false
1.2             1.2.3       true
1.2             1.3.0       false
1.2.3           1.2.3-b     false
1.2.3           1.2.3       true
1.2.3           1.2.4       false
1.2.3-b         1.2.3-a     false
1.2.3-b         1.2.3-b     true
1.2.3-b         1.2.3-b.2   false


# Hyphen range

1.2.3 - 1.2.5   1.2.2       false
1.2.3 - 1.2.5   1.2.3-0     false
1.2.3 - 1.2.5   1.2.3       true
1.2.3 - 1.2.5   1.2.4-0     false
1.2.3 - 1.2.5   1.2.5-0     false
1.2.3 - 1.2.5   1.2.5       true
1.2.3 - 1.2.5   1.2.6-0     false
1.2.3 - 1.2.5   1.2.6       false
2 - 5           1.0.0       false
2 - 5           2.0.0       true
2 - 5           3.0.0-1     false
2 - 5           5.0.0       true
2 - 5           6.0.0       false
1.2.3-a - 1.2.5-c  1.2.3-0  false
1.2.3-a - 1.2.5-c  1.2.3-a  true
1.2.3-a - 1.2.5-c  1.2.3-b  true
1.2.3-a - 1.2.5-c  1.2.3    true
1.2.3-a - 1.2.5-c  1.2.4-0  false
1.2.3-a - 1.2.5-c  1.2.4    true
1.2.3-a - 1.2.5-c  1.2.5-b  true
1.2.3-a - 1.2.5-c  1.2.5-c  true
1.2.3-a - 1.2.5-c  1.2.5-d  false
1.2.3-a - 1.2.5-c  1.2.5    false


# Wildcards

*               0.0.0-0     true
x.x             0.0.0-0     true
*.*.*           0.0.0-0     true
*               0.0.0       true
x.x             0.0.0       true
*.*.*           0.0.0       true
*               1.2.3-a.b.c  true
x.x             1.2.3-a.b.c  true
*.*.*           1.2.3-a.b.c  true
*               9999.9999.9999  true
x.x             9999.9999.9999  true
*.*.*           9999.9999.9999  true
1.*.*           0.0.99      false
1.*.*           1.0.0-0     false
1.*.*           1.0.0       true
1.*.*           1.5.7-0     false
1.*.*           1.5.7       true
1.*.*           2.0.0-0     false
1.*.*           2.0.0       false
1.2.x           1.1.99      false
1.2.x           1.2.0-0     false
1.2.x           1.2.0       true
1.2.x           1.2.5-0     false
1.2.x           1.2.5       true
1.2.x           1.3.0-0     false
1.2.x           1.3.0       false


# Tilde

~4.5.6          4.5.5       false
~4.5.6          4.5.6-0     false
~4.5.6          4.5.6       true
~4.5.6          4.5.7-0     false
~4.5.6          4.5.7       true
~4.5.6          4.6.0       false
~6.2            6.2.0       true
~6.2            6.2.3-0     false
~6.2            6.2.3       true
~6.2            7.0.0       false
~7              6.2.3       false
~7              7.0.0-0     false
~7              7.8.9       true
~7              8.0.0       false
~4.5.6-1        4.5.5       false
~4.5.6-1        4.5.6-0     false
~4.5.6-1        4.5.6-1     true
~4.5.6-1        4.5.6-2     true
~4.5.6-1        4.5.6       true
~4.5.6-1        4.5.7-0     false
~4.5.6-1        4.5.7       true
~4.5.6-1        4.6.0       false


# Caret

^0.5.1          0.5.0       false
^0.5.1          0.5.1-0     false
^0.5.1          0.5.1       true
^0.5.1          0.5.2-0     false
^0.5            0.4.9999    false
^0.5            0.5.0       true
^0.5            0.5.1-0     false
^0.5            0.5.1       true
^0.5            0.6.0       false
^1.5.9          1.4.9999    false
^1.5.9          1.5.0       false
^1.5.9          1.5.9-0     false
^1.5.9          1.5.9       true
^1.5.9          1.7.12-0    false
^1.5.9          1.7.12      true
^1.5.9          2.0.0       false
^5              4.9.99      false
^5              5.0.0       true
^5              5.100.0-0   false
^5              5.100.0     true
^5              6.0.0-0     false
^1.5.9-1        1.4.9999    false
^1.5.9-1        1.5.0       false
^1.5.9-1        1.5.9-0     false
^1.5.9-1        1.5.9-1     true
^1.5.9-1        1.5.9-2     true
^1.5.9-1        1.5.9       true
^1.5.9-1        1.5.10-0    false
^1.5.9-1        1.5.10      true
^1.5.9-1        1.7.12      true
^1.5.9-1        2.0.0       false


# Multiple rules

>1.2.3-c <=2.7.0            1.2.3-c             false
>1.2.3-c <=2.7.0            1.2.3-d             true
>1.2.3-c <=2.7.0            1.4.0-d             false
>1.2.3-c <=2.7.0            2.7.0-0             false
>1.2.3-c <=2.7.0            2.7.0               true
>1.2.3-c <=2.7.0            2.7.1               false
>1.2.3-c <=2.7.0 *          1.2.3-c             false
>1.2.3-c <=2.7.0 *          1.2.3-d             true
>1.2.3-c <=2.7.0 *          1.4.0-d             true
>1.2.3-c <=2.7.0 *          2.7.0-0             true
>1.2.3-c <=2.7.0 *          2.7.0               true
>1.2.3-c <=2.7.0 *          2.7.1               false
>1.2.3-c <=2.7.0-9          1.2.3-c             false
>1.2.3-c <=2.7.0-9          1.2.3-d             true
>1.2.3-c <=2.7.0-9          1.4.0-d             false
>1.2.3-c <=2.7.0-9          2.7.0-0             true
>1.2.3-c <=2.7.0-9          2.7.0               false
>1.2.3-c <=2.7.0-9          2.7.1               false


# Multiple ranges

~1.2.3 || ~4.5.6            1.2.2               false
~1.2.3 || ~4.5.6            1.2.3               true
~1.2.3 || ~4.5.6            1.2.4-0             false
~1.2.3 || ~4.5.6            1.2.4               true
~1.2.3 || ~4.5.6            1.3.0               false
~1.2.3 || ~4.5.6            4.5.5               false
~1.2.3 || ~4.5.6            4.5.6               true
~1.2.3 || ~4.5.6            4.5.9-0             false
~1.2.3 || ~4.5.6            4.5.9               true
~1.2.3 || ~4.5.6            4.6.0               false
<5.0.0 * || 5.*.*           4.4.4-4             true
<5.0.0 * || 5.*.*           4.4.4               true
<5.0.0 * || 5.*.*           5.5.5-5             false
<5.0.0 * || 5.*.*           5.5.5               true


EOF
