#!/bin/bash

# .claude インストールスクリプト
# すべてのプロジェクトで共通設定として使用するためのインストール

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

# スクリプトのディレクトリを取得
CLAUDE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ホームディレクトリの.claudeパス
HOME_CLAUDE_DIR="$HOME/.claude"

print_info "Claude AI設定ファイルのインストールを開始します..."
print_info "スクリプトディレクトリ: $CLAUDE_DIR"
print_info "インストール先: $HOME_CLAUDE_DIR"

# ホームディレクトリに.claudeディレクトリが存在するかチェック
if [ -d "$HOME_CLAUDE_DIR" ]; then
    print_warning "既存の $HOME_CLAUDE_DIR ディレクトリが見つかりました"
    read -p "既存のファイルをバックアップして上書きしますか？ (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR="$HOME/.claude.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "既存のファイルを $BACKUP_DIR にバックアップします"
        mv "$HOME_CLAUDE_DIR" "$BACKUP_DIR"
        print_success "バックアップ完了: $BACKUP_DIR"
    else
        print_info "インストールをキャンセルしました"
        exit 0
    fi
fi

# ホームディレクトリに.claudeディレクトリを作成
print_info "ホームディレクトリに.claudeディレクトリを作成中..."
mkdir -p "$HOME_CLAUDE_DIR"

# ファイルとディレクトリをコピー
print_info "ファイルをコピー中..."

# ルートファイルをコピー
cp -r "$CLAUDE_DIR"/*.md "$CLAUDE_DIR"/*.json "$CLAUDE_DIR"/*.js "$HOME_CLAUDE_DIR/"

# サブディレクトリをコピー
for dir in agents commands; do
    mkdir -p "$HOME_CLAUDE_DIR/$dir"
    cp -r "$CLAUDE_DIR/$dir/"* "$HOME_CLAUDE_DIR/$dir/"
done

print_success "ファイルのコピーが完了しました"

# 権限を設定
print_info "ファイルの権限を設定中..."
chmod 644 "$HOME_CLAUDE_DIR"/*.{md,json,js}
chmod 644 "$HOME_CLAUDE_DIR"/{agents,commands}/*

print_success "権限の設定が完了しました"

# インストール結果の確認
print_info "インストール結果を確認中..."
echo
for dir in "" agents commands; do
    [ -n "$dir" ] && echo "${dir}ディレクトリ:" || echo "インストールされたファイル:"
    ls -la "$HOME_CLAUDE_DIR${dir:+/$dir}"
    echo
done

print_success "インストールが完了しました！"
echo
print_info "使用方法:"
echo "  1. 新しいプロジェクトでClaude AIを使用する際は、"
echo "     $HOME_CLAUDE_DIR の設定が自動的に使用されます"
echo "  2. 設定を更新する場合は、このスクリプトを再実行してください"
echo "  3. 個別のプロジェクトで設定を上書きしたい場合は、"
echo "     プロジェクト内に .claude ディレクトリを作成してください"
echo
print_info "インストール先: $HOME_CLAUDE_DIR"
