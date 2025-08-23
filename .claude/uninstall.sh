#!/bin/bash

# .claude アンインストールスクリプト
# ホームディレクトリから.claude設定を削除

set -e

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

# ホームディレクトリの.claudeパス
HOME_CLAUDE_DIR="$HOME/.claude"

print_info "Claude AI設定ファイルのアンインストールを開始します..."
print_info "削除対象: $HOME_CLAUDE_DIR"

# ホームディレクトリに.claudeディレクトリが存在するかチェック
if [ ! -d "$HOME_CLAUDE_DIR" ]; then
    print_warning "$HOME_CLAUDE_DIR ディレクトリが見つかりません"
    print_info "アンインストールは不要です"
    exit 0
fi

# 削除前の確認
print_warning "以下のディレクトリとファイルが削除されます:"
echo
ls -la "$HOME_CLAUDE_DIR"
echo
read -p "本当に削除しますか？ (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "アンインストールをキャンセルしました"
    exit 0
fi

# バックアップの作成（念のため）
BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"
print_info "安全のため、$BACKUP_DIR にバックアップを作成します"
cp -r "$HOME_CLAUDE_DIR" "$BACKUP_DIR"
print_success "バックアップ完了: $BACKUP_DIR"

# ファイルの削除
print_info "ファイルを削除中..."
rm -rf "$HOME_CLAUDE_DIR"
print_success "ファイルの削除が完了しました"

print_success "アンインストールが完了しました！"
echo
print_info "注意:"
echo "  1. バックアップは $BACKUP_DIR に保存されています"
echo "  2. 必要に応じて、バックアップから特定のファイルを復元できます"
echo "  3. 完全に削除したい場合は、手動でバックアップディレクトリも削除してください"
echo
print_info "バックアップ場所: $BACKUP_DIR"
