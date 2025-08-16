# dotfiles

個人用の設定ファイル管理リポジトリです。

## 含まれるファイル

- `config.fish` - Fish shellの設定ファイル
- `.Brewfile` - Homebrewパッケージリスト
- `install.sh` - dotfilesのインストールスクリプト
- `uninstall.sh` - dotfilesのアンインストールスクリプト
- `dotfilesLink.sh` - シンボリックリンク作成スクリプト（レガシー）

## インストール

```bash
git clone git@github.com:ysk-sky/dotfiles.git
cd dotfiles
./install.sh
```

## アンインストール

```bash
./uninstall.sh
```

## 特徴

### Fish Shell設定

- 便利なエイリアス（ls → eza、git系コマンド等）
- 開発用のabbreviations
- npm -> bun

### 自動バックアップ

- インストール時に既存設定を自動バックアップ
- アンインストール時にバックアップから復元

### Brewfile

- 開発に必要なツールとアプリケーションを一括管理
- VSCode拡張機能も含む

## 手動セットアップ

### フォント

[UDEV Gothic](https://github.com/yuru7/udev-gothic) の `udev-gothic-35nf` がbrewでインストールされない場合は、手動でインストールしてください。

1. [リリースページ](https://github.com/yuru7/udev-gothic/releases)から最新版をダウンロード
2. `UDEVGothic_NF_vx.x.x.zip` を解凍
3. フォントファイルをFont Bookでインストール、またはシステムフォントフォルダに配置