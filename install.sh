#!/bin/bash

echo "dotfiles インストールを開始します..."

# 現在のディレクトリを取得
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# バックアップディレクトリを作成
mkdir -p "$BACKUP_DIR"
echo "既存設定のバックアップを $BACKUP_DIR に作成しました"

# dotfilesディレクトリ内の隠しファイルを検索してリンクを作成
for file in $(find "$DOTFILES_DIR" -name '.*' ! -name '.git*' ! -name '.' ! -name '..' -type f); do
    filename=$(basename "$file")
    target="$HOME_DIR/$filename"
    
    # 既存ファイルがある場合はバックアップ
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "既存の $filename をバックアップしています..."
        mv "$target" "$BACKUP_DIR/"
    fi
    
    # シンボリックリンクを作成
    echo "リンクを作成: $filename"
    ln -sf "$file" "$target"
done

# fish設定ファイルの特別な処理
if [ -f "$DOTFILES_DIR/config.fish" ]; then
    fish_config_dir="$HOME/.config/fish"
    mkdir -p "$fish_config_dir"
    
    if [ -f "$fish_config_dir/config.fish" ] && [ ! -L "$fish_config_dir/config.fish" ]; then
        echo "既存の fish config.fish をバックアップしています..."
        mv "$fish_config_dir/config.fish" "$BACKUP_DIR/"
    fi
    
    echo "fish設定ファイルをリンクしています..."
    ln -sf "$DOTFILES_DIR/config.fish" "$fish_config_dir/config.fish"
fi

echo ""
echo "dotfiles のインストールが完了しました！"
echo "バックアップは $BACKUP_DIR に保存されています"
echo ""
echo "推奨: 以下のツールがインストールされていない場合は手動でインストールしてください:"
echo "  - fish shell: brew install fish"
echo "  - eza (ls replacement): brew install eza"
echo "  - htop: brew install htop"