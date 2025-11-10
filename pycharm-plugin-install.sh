#!/usr/bin/env bash
set -euo pipefail

# PyCharm 실행 파일 경로 (환경에 맞게 수정 가능)
# ~ 를 직접 쓰면 안 풀리니까 $HOME 사용
PYCHARM_BIN="${PYCHARM_BIN:-/Applications/PyCharm.app/Contents/MacOS/pycharm}"

# 플러그인 목록 파일 (기본: 스크립트와 같은 디렉토리의 pycharm-plugins.txt)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PLUGIN_LIST="${1:-"$SCRIPT_DIR/pycharm-plugins.txt"}"

if [[ ! -x "$PYCHARM_BIN" ]]; then
  echo "❌ PyCharm binary not found or not executable: $PYCHARM_BIN" >&2
  echo "   Set PYCHARM_BIN env var to correct path." >&2
  exit 1
fi

if [[ ! -f "$PLUGIN_LIST" ]]; then
  echo "❌ Plugin list file not found: $PLUGIN_LIST" >&2
  echo "   Run ./update-pycharm-plugin-list.sh first." >&2
  exit 1
fi

echo "=> Installing PyCharm plugins from: $PLUGIN_LIST"
echo "   Using PyCharm binary: $PYCHARM_BIN"
echo

while IFS= read -r PLUGIN_ID; do
  # 빈 줄 / 주석 스킵
  [[ -z "$PLUGIN_ID" ]] && continue
  [[ "$PLUGIN_ID" =~ ^# ]] && continue

  echo "   Installing: $PLUGIN_ID"
  "$PYCHARM_BIN" installPlugins "$PLUGIN_ID"
done < "$PLUGIN_LIST"

echo
echo "✅ PyCharm plugins installed successfully."

