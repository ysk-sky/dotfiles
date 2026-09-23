#!/bin/bash

echo "dotfiles アンインストールを開始します..."

# 現在のディレクトリを取得
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"

# 最新のバックアップディレクトリを検索
BACKUP_DIR=$(find "$HOME" -maxdepth 1 -name '.dotfiles_backup_*' -type d | sort | tail -1)

if [ -z "$BACKUP_DIR" ]; then
    echo "警告: バックアップディレクトリが見つかりません"
    echo "インストールしたファイルの削除のみ行います"
else
    echo "バックアップディレクトリ: $BACKUP_DIR"
fi

# install.sh がコピーしたファイルを削除し、バックアップから復元する。
# インストール後に手元で編集したファイルは消さずに残す（編集内容を失わないため）。
# 旧版の install.sh が張ったシンボリックリンクも削除対象にする。
remove_installed() {
    local src="$1" target="$2"
    local name
    name="$(basename "$target")"
    if [ -L "$target" ] || { [ -f "$target" ] && cmp -s "$src" "$target"; }; then
        echo "削除: $target"
        rm "$target"
        if [ -n "$BACKUP_DIR" ] && [ -e "$BACKUP_DIR/$name" ]; then
            echo "バックアップから復元: $target"
            mv "$BACKUP_DIR/$name" "$target"
        fi
    elif [ -e "$target" ]; then
        echo "インストール後に変更されているため残します: $target"
    fi
}

for file in $(find "$DOTFILES_DIR" -maxdepth 1 -name '.*' ! -name '.git*' ! -name '.' ! -name '..' -type f); do
    remove_installed "$file" "$HOME_DIR/$(basename "$file")"
done

remove_installed "$DOTFILES_DIR/config.fish" "$HOME/.config/fish/config.fish"
remove_installed "$DOTFILES_DIR/fish_plugins" "$HOME/.config/fish/fish_plugins"

# otp.fish はシークレットを書き込んで使うため、テンプレートのままの場合だけ削除される
remove_installed "$DOTFILES_DIR/otp.fish" "$HOME/.config/fish/functions/otp.fish"

# 空になったバックアップディレクトリを削除
if [ -n "$BACKUP_DIR" ] && [ -d "$BACKUP_DIR" ]; then
    if [ -z "$(ls -A "$BACKUP_DIR")" ]; then
        echo "空のバックアップディレクトリを削除: $BACKUP_DIR"
        rmdir "$BACKUP_DIR"
    else
        echo "バックアップディレクトリに残りファイルがあります: $BACKUP_DIR"
    fi
fi

echo ""
echo "dotfiles のアンインストールが完了しました！"