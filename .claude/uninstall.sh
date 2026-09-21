#!/bin/bash

# .claude アンインストールスクリプト
# managed-files.txt に列挙したファイルだけを ~/.claude から削除する。
# ~/.claude ディレクトリ自体は削除しない
# （会話履歴・プラグイン・settings.local.json などのローカル状態を保持するため）。

set -euo pipefail

# 色付きの出力用関数
print_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

CLAUDE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"
MANIFEST="$CLAUDE_DIR/managed-files.txt"

if [ ! -f "$MANIFEST" ]; then
    print_error "$MANIFEST が見つかりません"
    exit 1
fi

print_info "Claude AI設定ファイルのアンインストールを開始します..."

# 実際に存在する管理対象ファイルだけを削除対象にする
targets=()
while IFS= read -r rel || [ -n "$rel" ]; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue
    [ -f "$HOME_CLAUDE_DIR/$rel" ] && targets+=("$rel")
done < "$MANIFEST"

if [ ${#targets[@]} -eq 0 ]; then
    print_info "削除対象のファイルはありません"
    exit 0
fi

print_warning "以下のファイルが $HOME_CLAUDE_DIR から削除されます:"
printf '  %s\n' "${targets[@]}"
echo
read -p "本当に削除しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "アンインストールをキャンセルしました"
    exit 0
fi

for rel in "${targets[@]}"; do
    mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
    cp -p "$HOME_CLAUDE_DIR/$rel" "$BACKUP_DIR/$rel"
    rm -f "$HOME_CLAUDE_DIR/$rel"

    # 空になったサブディレクトリ（agents/ など）だけ片付ける
    dir="$(dirname "$HOME_CLAUDE_DIR/$rel")"
    [ "$dir" != "$HOME_CLAUDE_DIR" ] && rmdir "$dir" 2>/dev/null || true
done

print_success "アンインストールが完了しました！"
echo
print_info "注意:"
echo "  1. 削除したファイルのバックアップは $BACKUP_DIR にあります"
echo "  2. 履歴・プラグイン・settings.local.json など、管理対象外のファイルは残っています"
echo "  3. バックアップが不要になったら、手動で削除してください"
