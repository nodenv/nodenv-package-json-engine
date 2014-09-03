
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

    if [ "$mode" = "false" ]; then
        assert "$ret" "" "$ver should not match the range $rule"
    else
        assert "$ret" "$ver" "$ver should match the range $rule"
    fi

done <<EOF

# Basic rules

>1.0.0          0.1.0       false
>1.0.0          1.0.1       true
<=1.0.0         1.0.0-b     true
<=1.0.0         1.0.0       true
<=1.0.0         2.0.0       false
<1.0.0          2.0.0       false
<1.0.0          1.0.0-b     false
<1.0.0          0.0.0       true
>=1.2.3         1.2.4       true
>=1.2.3         1.2.3       true
>=1.2.3         1.2.3-b     true
>=1.2.3         1.2.2       false
>=0.0.0         0.0.0-0     true
>1.2            1.2.1       false
>1.2            1.3.0-0     true
>1              1.5.0       false
>1              2.0.0       true
>=1.2           1.2.0-0     true


# Specific version

1.2             1.2.3       true
1.2             1.3.0-0     false
1.2.3           1.2.4       false
1.2.3           1.2.3-b     true
#1.2.3-b         1.2.3-a     false
#1.2.3-b         1.2.3-b.2   true


# Hyphen range

1.2.3 - 1.2.4   1.2.2       false
1.2.3 - 1.2.4   1.2.3-0     true
1.2.3 - 1.2.4   1.2.4       true
1.2.3 - 1.2.4   1.2.5-0     false
2 - 5           1.0.0       false
2 - 5           3.1.5       true
2 - 5           6.0.0-0     false


# Wildcards

*               0.0.0-0     true
x               9999.13.37  true
*.*.*           5.10.15     true
1.*.*           0.0.99      false
1.*.*           1.5.7       true
1.*.*           2.0.0-0     false
1.2.x           1.2.3-0     true
1.2.x           1.3.3       false

# Tilde

~4.5.6          4.5.5       false
~4.5.6          4.5.6-0     true
~4.5.6          4.5.7       true
~4.5.6          4.6.0-0     false
~6.2            6.2.0-0     true
~6.2            6.2.3       true
~6.2            7.0.0-0     false
~7              6.2.3       false
~7              7.0.0-0     true
~7              7.8.9       true
~7              8.0.0-0     false


# Caret

^0.5.1          0.5.0       false
^0.5.1          0.5.1-0     true
^0.5.1          0.5.1       true
^0.5.1          0.5.2-0     false
^0.5            0.4.9999    false
^0.5            0.5.1       true
^0.5            0.6.0-0     false
^1.5.9          1.4.9999    false
^1.5.9          1.5.0       false
^1.5.9          1.5.9-0     true
^1.5.9          1.7.12      true
^1.5.9          2.0.0-0     false
^5              4.9.99      false
^5              5.0.0-0     true
^5              5.100.0     true
^5              6.0.0-0     false

EOF
