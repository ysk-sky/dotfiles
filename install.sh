#!/bin/bash

echo "dotfiles インストールを開始します..."

# 現在のディレクトリを取得
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# 既存ファイルの退避先（何も退避しなければ最後に削除する）
mkdir -p "$BACKUP_DIR"

# リポジトリのファイルを dest にコピーする。
# リポジトリは後で削除する前提なので、シンボリックリンクではなく実ファイルとして置く。
# 既存のファイル（旧版が張ったシンボリックリンクを含む）は退避する。mv はリンク先をたどらないので、
# リンク経由でリポジトリのファイルを上書きすることはない。
copy_from_repo() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
            echo "変更なし: $dest"
            return
        fi
        echo "既存の $dest をバックアップしています..."
        mv "$dest" "$BACKUP_DIR/"
    fi
    cp "$src" "$dest"
    echo "コピー: $dest"
}

# リポジトリ直下のドットファイル（.vimrc など）をホームにコピー
for file in $(find "$DOTFILES_DIR" -maxdepth 1 -name '.*' ! -name '.git*' ! -name '.' ! -name '..' -type f); do
    copy_from_repo "$file" "$HOME_DIR/$(basename "$file")"
done

# fish
FISH_CONFIG_DIR="$HOME/.config/fish"
copy_from_repo "$DOTFILES_DIR/config.fish" "$FISH_CONFIG_DIR/config.fish"
copy_from_repo "$DOTFILES_DIR/fish_plugins" "$FISH_CONFIG_DIR/fish_plugins"

# otp.fish はシークレットを書き込んで使うテンプレートなので、書き込み済みのものを上書きしないよう初回だけコピーする
otp_dest="$FISH_CONFIG_DIR/functions/otp.fish"
if [ -e "$otp_dest" ]; then
    echo "otp.fish は既に存在するため変更しません: $otp_dest"
else
    mkdir -p "$(dirname "$otp_dest")"
    cp "$DOTFILES_DIR/otp.fish" "$otp_dest"
    echo "otp.fish をコピーしました。シークレットを $otp_dest に設定してください"
fi

# Homebrewがインストールされているかチェック
if command -v brew >/dev/null 2>&1; then
    echo ""
    echo "Homebrewが見つかりました。パッケージをインストールしています..."
    
    # Brewfileが存在する場合、bundle installを実行
    if [ -f "$DOTFILES_DIR/.Brewfile" ]; then
        echo "Brewfileからパッケージをインストールしています..."
        brew bundle install --file="$DOTFILES_DIR/.Brewfile"
    else
        echo "Brewfileが見つかりません。手動でパッケージをインストールしてください。"
    fi
else
    echo ""
    echo "Homebrewがインストールされていません。"
    echo "まずHomebrewをインストールしてから、以下のコマンドでパッケージをインストールしてください:"
    echo "  brew bundle install --file=\"$DOTFILES_DIR/.Brewfile\""
fi

# fisher で fish_plugins のプラグインを入れる（fish は Brewfile で入るので brew bundle の後に行う）
if command -v fish >/dev/null 2>&1; then
    echo ""
    echo "fisher で fish プラグインをインストールしています..."
    # fisher 未導入の新環境では、公式のインストール手順どおり fisher 本体を読み込んでから update する
    if ! fish -c 'functions -q fisher; or curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher update'; then
        echo "警告: fish プラグインのインストールに失敗しました。fish で 'fisher update' を実行してください"
    fi
else
    echo ""
    echo "fish が見つからないため、fish プラグインのインストールをスキップしました"
fi

# NeoBundleとプラグインのインストール
if [ -f "$HOME/.vimrc" ]; then
    echo ""
    echo "Vimプラグインをインストールしています..."
    # NeoBundle ディレクトリを作成
    mkdir -p "$HOME/.vim/bundle"
    # NeoBundleをクローン
    if [ ! -d "$HOME/.vim/bundle/neobundle.vim" ]; then
        git clone https://github.com/Shougo/neobundle.vim.git "$HOME/.vim/bundle/neobundle.vim"
    fi
    # Vimを起動してNeoBundleInstallを実行
    vim +NeoBundleInstall +qall
    echo "Vimプラグインのインストールが完了しました。"
fi

echo ""
echo "dotfiles のインストールが完了しました！"
# 退避したファイルが無ければ空のバックアップディレクトリは残さない（uninstall.sh が最新のバックアップを参照するため）
if rmdir "$BACKUP_DIR" 2>/dev/null; then
    echo "退避したファイルはありません"
else
    echo "バックアップは $BACKUP_DIR に保存されています"
fi