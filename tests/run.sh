#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURES="$ROOT/tests/fixtures"
FILTER="$ROOT/_extensions/bibentry/bibentry.lua"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v pandoc >/dev/null 2>&1 || {
  echo "ERROR: pandoc is required." >&2
  exit 1
}

command -v unzip >/dev/null 2>&1 || {
  echo "ERROR: unzip is required for the DOCX regression check." >&2
  exit 1
}

cd "$FIXTURES"

pandoc bibentry-input.md --lua-filter="$FILTER" --citeproc -t plain -o "$TMP/bibentry.txt"
pandoc bibentry-input.md --lua-filter="$FILTER" --citeproc -t native -o "$TMP/bibentry.native"
pandoc bibentry-input.md --lua-filter="$FILTER" --citeproc -s -o "$TMP/bibentry.html"
pandoc bibentry-input.md --lua-filter="$FILTER" --citeproc -s -o "$TMP/bibentry.docx"
pandoc bibentry-input.md --lua-filter="$FILTER" --citeproc -t latex -o "$TMP/bibentry.tex"

grep -Fq 'Normal citation: INLINE[' "$TMP/bibentry.txt"
grep -Fq 'Standalone: FULL[' "$TMP/bibentry.txt"
grep -Fq 'Inline context: BEFORE FULL[' "$TMP/bibentry.txt"
grep -Fq ' AFTER.' "$TMP/bibentry.txt"
grep -Fq 'NOTE FULL[' "$TMP/bibentry.txt"
grep -Fq '( "ref-alpha2024" , [ "csl-entry" ]' "$TMP/bibentry.native"

if grep -Fq 'left:-10000px' "$TMP/bibentry.html"; then
  echo "ERROR: legacy hidden-citation CSS found in HTML output." >&2
  exit 1
fi

unzip -p "$TMP/bibentry.docx" word/footnotes.xml | grep -Fq 'A book used only through bibentry'
grep -Fq '\footnote{' "$TMP/bibentry.tex"
grep -Fq 'A book used only through bibentry' "$TMP/bibentry.tex"

pandoc numeric-input.md --lua-filter="$FILTER" --citeproc -t plain -o "$TMP/numeric.txt"
grep -Fq 'First normal citation [1].' "$TMP/numeric.txt"
grep -Fq 'Then a full entry [2] A book used only through bibentry.' "$TMP/numeric.txt"
grep -Fq '[1] A normally cited book' "$TMP/numeric.txt"
grep -Fq '[2] A book used only through bibentry' "$TMP/numeric.txt"

echo "All bibentry regression tests passed."
