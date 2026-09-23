# dotfiles

個人用の設定ファイル管理リポジトリです。

## 含まれるファイル

- `config.fish` - Fish shell の設定（`~/.config/fish/config.fish`）
- `fish_plugins` - fisher で入れる Fish プラグインの一覧
- `otp.fish` - TOTP のワンタイムパスワードを生成してクリップボードにコピーする Fish 関数
- `.Brewfile` - Homebrew パッケージ・アプリ・VSCode 拡張の一覧
- `.vimrc` / `.vim/` - Vim の設定と NeoBundle プラグイン
- `.bashrc` - Bash の設定
- `.claude/` - Claude Code の共通設定（詳細は [.claude/README.md](.claude/README.md)）
- `install.sh` / `uninstall.sh` - dotfiles のインストール・アンインストール
- `dotfilesLink.sh` - シンボリックリンク作成スクリプト（レガシー）

## インストール

```bash
ghq get git@github.com:ysk-sky/dotfiles.git
cd "$(ghq root)/github.com/ysk-sky/dotfiles"
./install.sh
.claude/install.sh   # Claude Code の設定は別スクリプトで反映する
```

`install.sh` は次の処理を行います。

- リポジトリ直下のドットファイル（`.vimrc` など）を `~` にコピー
- `config.fish` と `fish_plugins` を `~/.config/fish/` にコピー
- `otp.fish` を `~/.config/fish/functions/otp.fish` にコピー（まだ無いときだけ。シークレットを書き込んだものを上書きしないため）
- 既存のファイルは `~/.dotfiles_backup_<日時>/` に退避
- Homebrew があれば `.Brewfile` で `brew bundle install`
- fish があれば fisher を入れ、`fish_plugins` のプラグインをインストール（`fisher update`）
- NeoBundle を入れて Vim プラグインをインストール

このリポジトリは新しい環境を作るためのもので、インストール後に削除してかまいません。ファイルはシンボリックリンクではなく実ファイルとしてコピーするので、リポジトリを消しても設定はそのまま残ります。何度実行しても同じ状態になり、既存のファイルと内容が同じならコピーしません。

インストール後、`~/.config/fish/functions/otp.fish` に実際のシークレットを設定してください。

## アンインストール

```bash
./uninstall.sh
```

`install.sh` がコピーしたファイルのうち、インストール後に編集していないものを削除し、最新の `~/.dotfiles_backup_*` から元のファイルを戻します。編集したファイルは消さずに残します。リポジトリを削除したあとは使えません。

## Fish shell 設定の概要

- `ls` / `ll` / `la` / `lt` を eza に置き換える abbr（eza があるときだけ）
- git 系のエイリアス（`gb`・`gco`・`glog`、マージ済みブランチを消す `gbdm`、main に戻って pull と掃除をする `gmain` など）
- Claude Code の短縮コマンド（`cc` = `claude -c`、`cr` = `claude -r`）
- `npx` を `bunx --bun` に、`pip` を `uv pip` に置き換え
- fzf（`GHQ_SELECTOR` と `difit` のコミット選択）と zoxide の初期化
- Homebrew・Go・pyenv・`~/.local/bin` の PATH と、ビルド用の `LDFLAGS` / `CPPFLAGS` / `PKG_CONFIG_PATH`

インストールした設定は、それぞれの環境で独立して編集します。この内容を次の新しい環境にも使いたい場合は、リポジトリの `config.fish` に手で反映してください。

## 秘密情報の扱い

秘密情報はこのリポジトリに含めません。

- API キーなどの環境変数は `~/.config/fish/conf.d/secrets.fish` に書き、リポジトリでは管理しません。
- `otp.fish` の TOTP シークレットはプレースホルダです。`install.sh` がコピーした `~/.config/fish/functions/otp.fish` にだけ実際の値を書きます（コピーなので、リポジトリには入りません）。

## 手動セットアップ

### フォント

[UDEV Gothic](https://github.com/yuru7/udev-gothic) の `udev-gothic-35nf` が brew でインストールされない場合は、手動でインストールしてください。

1. [リリースページ](https://github.com/yuru7/udev-gothic/releases)から最新版をダウンロード
2. `UDEVGothic_NF_vx.x.x.zip` を解凍
3. フォントファイルを Font Book でインストール、またはシステムフォントフォルダに配置
