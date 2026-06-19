#!/usr/bin/env bash

FESTIVAL="./result/bin/festival"

voices=$(echo '(mapcar (lambda (v) (format t "%s\n" v)) (voice.list))' |
    "$FESTIVAL" 2>/dev/null)

pass=0
fail=0
errors=()

for voice in $voices; do
    echo -n "Testing $voice ... "
    result=$(echo "(voice_${voice})(SayText \"test\")" |
        "$FESTIVAL" 2>&1)
    if echo "$result" | grep -qi "error\|unbound"; then
        echo "FAIL"
        errors+=("$voice: $(echo "$result" | grep -i 'error\|unbound' | head -1)")
        ((fail++))
    else
        echo "ok"
        ((pass++))
    fi
done

echo ""
echo "Results: $pass passed, $fail failed"
if [[ ${#errors[@]} -gt 0 ]]; then
    echo "Failures:"
    printf '  %s\n' "${errors[@]}"
fi
