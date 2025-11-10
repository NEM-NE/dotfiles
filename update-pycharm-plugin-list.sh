#!/usr/bin/env bash
set -euo pipefail

# JetBrains 설정 루트 (macOS 기준)
JETBRAINS_CONFIG_DIR="$HOME/Library/Application Support/JetBrains"

# 출력 파일 경로 (기본: 현재 스크립트와 같은 디렉토리)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
OUTPUT_FILE="${OUTPUT_FILE:-"$SCRIPT_DIR/pycharm-plugins.txt"}"

# 최신 PyCharm 설정 디렉토리 선택
# 예: PyCharm2023.2, PyCharm2024.3 등 중에서 버전 가장 큰 것
LATEST_PYCHARM_DIR="$(
  ls -1d "$JETBRAINS_CONFIG_DIR"/PyCharm* 2>/dev/null \
    | sort -V \
    | tail -n 1 || true
)"

if [[ -z "${LATEST_PYCHARM_DIR}" ]]; then
  echo "❌ PyCharm settings directory not found under: $JETBRAINS_CONFIG_DIR" >&2
  exit 1
fi

PLUGIN_DIR="$LATEST_PYCHARM_DIR/plugins"

if [[ ! -d "$PLUGIN_DIR" ]]; then
  echo "❌ Plugins directory not found: $PLUGIN_DIR" >&2
  exit 1
fi

echo "🔍 Using PyCharm config: $(basename "$LATEST_PYCHARM_DIR")"
echo "📁 Scanning plugins from: $PLUGIN_DIR"
: > "$OUTPUT_FILE"

# plugins 디렉토리 내 폴더명을 그대로 plugin ID로 사용
for path in "$PLUGIN_DIR"/*; do
  [[ -d "$path" ]] || continue
  name="$(basename "$path")"

  # JetBrains 내부용 extensions 디렉토리는 제외 (대소문자 구분 없이)
  if [[ "$name" =~ ^[Ee]xtensions$ ]]; then
    continue
  fi

  echo "$name" >> "$OUTPUT_FILE"
done

echo "✅ Exported plugin list to: $OUTPUT_FILE"

