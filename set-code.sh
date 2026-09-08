#!/bin/sh
# Stamp the Pinterest verification code into the page and create the
# FILENAME-method file. Usage: ./set-code.sh <code>
set -eu
[ $# -eq 1 ] || { echo "usage: $0 <verification-code>" >&2; exit 1; }
CODE="$1"
SHORT="$(printf '%s' "$CODE" | cut -c1-5)"

# METATAG method
python3 - "$CODE" <<'PY'
import re, sys
code = sys.argv[1]
html = open("index.html").read()
html = re.sub(r'(<meta name="p:domain_verify" content=")[^"]*(">)', rf'\g<1>{code}\g<2>', html)
open("index.html", "w").write(html)
PY

# FILENAME method — Pinterest serves this from the domain root
printf '%s\n' "$CODE" > "pinterest-$SHORT.html"

echo "stamped index.html  -> meta p:domain_verify = $CODE"
echo "created pinterest-$SHORT.html"
