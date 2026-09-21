#!/bin/bash

# .claude インストールスクリプト
# managed-files.txt に列挙したファイルだけを ~/.claude にコピーする。
# ~/.claude ディレクトリ自体は移動・削除しない
# （会話履歴・プラグイン・settings.local.json などのローカル状態を保持するため）。
#
# 使い方: ./install.sh [--dry-run]

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

DRY_RUN=false
case "${1:-}" in
    "") ;;
    --dry-run) DRY_RUN=true ;;
    *)
        print_error "不明なオプション: $1"
        echo "使用方法: $0 [--dry-run]"
        exit 1
        ;;
esac

# dry-run のときは実行せずコマンドだけ表示する
run() {
    if $DRY_RUN; then
        echo "[DRY-RUN] $*"
    else
        "$@"
    fi
}

# スクリプトのディレクトリを取得
CLAUDE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"
MANIFEST="$CLAUDE_DIR/managed-files.txt"

if [ ! -f "$MANIFEST" ]; then
    print_error "$MANIFEST が見つかりません"
    exit 1
fi

print_info "Claude AI設定ファイルのインストールを開始します..."
print_info "インストール先: $HOME_CLAUDE_DIR"
$DRY_RUN && print_warning "dry-run: 実際の変更は行いません"

updated=0
backed_up=false
while IFS= read -r rel || [ -n "$rel" ]; do
    [[ -z "$rel" || "$rel" == \#* ]] && continue

    src="$CLAUDE_DIR/$rel"
    dest="$HOME_CLAUDE_DIR/$rel"

    if [ ! -f "$src" ]; then
        print_error "管理対象ファイルが存在しません: $rel"
        exit 1
    fi

    # statusLine は ~/.claude/statusline.js を直接実行するため、スクリプトには実行権限が必要
    mode=644
    [[ "$rel" == *.js ]] && mode=755

    # 内容が変わる場合だけ、上書き前のファイルを退避する
    if [ -f "$dest" ] && ! cmp -s "$src" "$dest"; then
        run mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
        run cp -p "$dest" "$BACKUP_DIR/$rel"
        print_info "退避: $rel -> $BACKUP_DIR/$rel"
        backed_up=true
    fi

    # 内容が同一でも実行して権限を補正する（冪等）
    [ -f "$dest" ] && cmp -s "$src" "$dest" || updated=$((updated + 1))
    run mkdir -p "$(dirname "$dest")"
    run install -m "$mode" "$src" "$dest"
done < "$MANIFEST"

print_success "インストールが完了しました（更新: ${updated}件）"
echo
print_info "補足:"
echo "  - 設定を更新する場合は、このスクリプトを再実行してください"
$backed_up && echo "  - 上書きしたファイルは $BACKUP_DIR に退避しました"
echo "  - 個別のプロジェクトで設定を上書きしたい場合は、"
echo "    プロジェクト内に .claude ディレクトリを作成してください"
