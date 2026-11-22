#!/usr/bin/env bash
# DocC HTML を .build/docs/S2JSourceList に生成
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SYMBOL_GRAPHS="$ROOT/.build/symbol-graphs"
OUTPUT="$ROOT/.build/docs/S2JSourceList"
mkdir -p "$SYMBOL_GRAPHS" "$OUTPUT"

swift build --target S2JSourceList \
  -Xswiftc -emit-symbol-graph \
  -Xswiftc -emit-symbol-graph-dir -Xswiftc "$SYMBOL_GRAPHS"

xcrun docc convert Sources/S2JSourceList/S2JSourceList.docc \
  --fallback-bundle-identifier com.s2j.S2JSourceList \
  --fallback-display-name S2JSourceList \
  --fallback-bundle-version "$(node -p "require('./package.json').version")" \
  --additional-symbol-graph-dir "$SYMBOL_GRAPHS" \
  --output-path "$OUTPUT" \
  --transform-for-static-hosting

echo "DocC HTML: $OUTPUT/index.html"