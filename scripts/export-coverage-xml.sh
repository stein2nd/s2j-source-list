#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PROF=$(find .build -path '*/codecov/default.profdata' 2>/dev/null | head -1)
BIN=$(find .build -name S2JSourceListTests -path '*/MacOS/*' -type f 2>/dev/null | head -1)
if [[ -z "$BIN" ]]; then
  BIN=$(find .build -name 's2j-source-listPackageTests' -path '*/MacOS/*' -type f 2>/dev/null | head -1)
fi

if [[ -z "$PROF" || -z "$BIN" ]]; then
  echo "export-coverage-xml: run swift test --enable-code-coverage first" >&2
  exit 1
fi

mkdir -p .build/coverage
xcrun llvm-cov export "$BIN" -instr-profile="$PROF" -format=codecov > .build/coverage/coverage.xml
echo "Wrote .build/coverage/coverage.xml"