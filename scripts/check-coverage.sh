#!/usr/bin/env bash
# S2JSourceList の行カバレッジが目標以上か検証 (デフォルト 70%)
set -euo pipefail

MIN_COVERAGE="${MIN_COVERAGE:-70}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

swift test --enable-code-coverage -q

PROF=$(find .build -path '*/codecov/default.profdata' 2>/dev/null | head -1)
BIN=$(find .build -name S2JSourceListTests -path '*/MacOS/*' -type f 2>/dev/null | head -1)
if [[ -z "$BIN" ]]; then
  BIN=$(find .build -name 's2j-source-listPackageTests' -path '*/MacOS/*' -type f 2>/dev/null | head -1)
fi

if [[ -z "$PROF" || -z "$BIN" ]]; then
  echo "check-coverage: profdata またはテストバイナリが見つかりません" >&2
  exit 1
fi

LINE_PCT=$(xcrun llvm-cov report "$BIN" -instr-profile="$PROF" 2>/dev/null | awk '
  /^Sources\/S2JSourceList\// {
    lines += $8
    missed += $9
  }
  END {
    if (lines == 0) { print "0"; exit }
    printf("%.2f", 100.0 * (lines - missed) / lines)
  }')

echo "S2JSourceList line coverage: ${LINE_PCT}% (min ${MIN_COVERAGE}%)"

if awk -v p="$LINE_PCT" -v m="$MIN_COVERAGE" 'BEGIN { exit !(p + 0 >= m + 0) }'; then
  exit 0
fi

echo "check-coverage: ${MIN_COVERAGE}% 未達" >&2
exit 1