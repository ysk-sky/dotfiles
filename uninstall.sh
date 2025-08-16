#!/bin/bash

echo "dotfiles アンインストールを開始します..."

# 現在のディレクトリを取得
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"

# 最新のバックアップディレクトリを検索
BACKUP_DIR=$(find "$HOME" -maxdepth 1 -name '.dotfiles_backup_*' -type d | sort | tail -1)

if [ -z "$BACKUP_DIR" ]; then
    echo "警告: バックアップディレクトリが見つかりません"
    echo "シンボリックリンクのみ削除します"
else
    echo "バックアップディレクトリ: $BACKUP_DIR"
fi

# dotfilesディレクトリ内の隠しファイルに対応するシンボリックリンクを削除
for file in $(find "$DOTFILES_DIR" -name '.*' ! -name '.git*' ! -name '.' ! -name '..' -type f); do
    filename=$(basename "$file")
    target="$HOME_DIR/$filename"
    
    # シンボリックリンクの場合のみ削除
    if [ -L "$target" ]; then
        echo "シンボリックリンクを削除: $filename"
        rm "$target"
        
        # バックアップから復元
        if [ -n "$BACKUP_DIR" ] && [ -f "$BACKUP_DIR/$filename" ]; then
            echo "バックアップから復元: $filename"
            mv "$BACKUP_DIR/$filename" "$target"
        fi
    fi
done

# fish設定ファイルの特別な処理
fish_config="$HOME/.config/fish/config.fish"
if [ -L "$fish_config" ]; then
    echo "fish設定ファイルのシンボリックリンクを削除しています..."
    rm "$fish_config"
    
    # バックアップから復元
    if [ -n "$BACKUP_DIR" ] && [ -f "$BACKUP_DIR/config.fish" ]; then
        echo "fish設定ファイルをバックアップから復元しています..."
        mv "$BACKUP_DIR/config.fish" "$fish_config"
    fi
fi

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