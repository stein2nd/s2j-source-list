#!/usr/bin/env bash
# S2JSourceList の行カバレッジが目標以上か検証 (デフォルト 70%)
set -euo pipefail

MIN_COVERAGE="${MIN_COVERAGE:-70}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

swift test --enable-code-coverage -q

"$ROOT/scripts/export-coverage-xml.sh"

LINE_PCT=$(awk '
  /^SF:.*Sources\/S2JSourceList\// { infile = 1; next }
  infile && /^DA:/ {
    split(substr($0, 4), a, ",");
    total++;
    if (a[2] == 0) { missed++; }
  }
  /^end_of_record/ { infile = 0 }
  END {
    if (total == 0) { print "0"; exit }
    printf("%.2f", 100.0 * (total - missed) / total)
  }
' .build/coverage/coverage.lcov)

echo "S2JSourceList line coverage: ${LINE_PCT}% (min ${MIN_COVERAGE}%)"

if awk -v p="$LINE_PCT" -v m="$MIN_COVERAGE" 'BEGIN { exit !(p + 0 >= m + 0) }'; then
  exit 0
fi

echo "check-coverage: ${MIN_COVERAGE}% 未達" >&2
exit 1