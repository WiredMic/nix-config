#!/usr/bin/env bash

FESTIVAL="./result/bin/festival"

voices=$(echo '(mapcar (lambda (v) (format t "%s\n" v)) (voice.list))' |
    "$FESTIVAL" 2>/dev/null)

pass=0
fail=0
errors=()

echo $voices

for voice in $voices; do
    echo -n "Testing $voice ... "
    tmpfile=$(mktemp /tmp/XXXXXX.wav)
    echo "(voice_${voice})(utt.save.wave (utt.synth (Utterance Text \"hello world\")) \"$tmpfile\")" |
        "$FESTIVAL" 2>&1
    size=$(stat -c%s "$tmpfile")
    if [[ $size -gt 44 ]]; then
        echo "ok ($size bytes)"
        ((pass++))
    else
        echo "FAIL (only $size bytes)"
        ((fail++))
    fi
    rm -f "$tmpfile"
done

echo ""
echo "Results: $pass passed, $fail failed"
if [[ ${#errors[@]} -gt 0 ]]; then
    echo "Failures:"
    printf '  %s\n' "${errors[@]}"
fi
