
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

>1.0.0            0.1.0     false
>1.0.0            1.0.1     true
<=1.0.0           1.0.0-b   true
<=1.0.0           1.0.0     true
<=1.0.0           2.0.0     false
<1.0.0            2.0.0     false
<1.0.0            1.0.0-b   false
<1.0.0            0.0.0     true
>=1.2.3           1.2.4     true
>=1.2.3           1.2.3     true
>=1.2.3           1.2.3-b   true
>=1.2.3           1.2.2     false
>=0.0.0           0.0.0-0   true




EOF
