# .claude 共通設定

Claude Code のユーザー設定（`~/.claude`）のうち、全プロジェクト共通で使うものを管理するディレクトリです。
`managed-files.txt` に列挙したファイルだけを `~/.claude` にコピーします。会話履歴・プラグイン・`settings.local.json` などのローカル状態には触れません。

## ファイル構成

```
.claude/
├── CLAUDE.md              # 全プロジェクト共通の指示（日本語出力・TDD・コミット承認など）
├── settings.json          # permissions / sandbox / model / effortLevel などの設定
├── statusline.js          # ステータスライン表示スクリプト
├── agents/
│   └── serena.md          # serena-expert サブエージェント（Serena MCP で実装を進める）
├── commands/
│   ├── dependabot-check.md  # /dependabot-check: Dependabot アラートの解決方針を分析
│   ├── pr.md                # /pr: PR 本文を生成し、承認後に作成・更新
│   ├── serena.md            # /serena: Serena MCP を使った開発タスク
│   └── ui-advice.md         # /ui-advice: UI パターン提案とテキストワイヤーフレーム
├── managed-files.txt      # install.sh / uninstall.sh が扱うファイルの一覧
├── install.sh             # ~/.claude へのインストール
├── uninstall.sh           # ~/.claude からの削除
├── superclaude-summary.md # SuperClaude の調査メモ（配布対象外）
└── README.md              # このファイル（配布対象外）
```

## 設定方針（Claude Opus 5.5 前提）

- `model` は `opus` エイリアスで、現行の Opus（Opus 5.5）を使います。
- `effortLevel` は `medium` にしています。Opus 5.5 は同じ effort でも以前の Opus より多く考えるため、API の既定値と同じ `medium` から始め、難しいタスクだけ `/effort` で `high` 以上に上げます。
- `CLAUDE.md`・エージェント・コマンドには、モデルが言われなくてもできる一般論や「N 回考える」といった思考量の指定を書きません。長く細かい指示は思考コストを増やし、かえって品質を下げるためです。守ってほしいルールだけを、理由と一緒に書きます。
- コミットや PR への Claude の署名は、`settings.json` の `attribution` を空にしたうえで `CLAUDE.md` でも禁止しています。

## インストール

```bash
./install.sh --dry-run   # 変更内容だけを表示
./install.sh             # ~/.claude に反映
```

- `managed-files.txt` のファイルだけを `~/.claude` にコピーします（`statusline.js` は実行権限付き）。
- 内容が変わるファイルだけを、上書き前に `~/.claude.backup.<日時>/` に退避します。
- 設定を変更するときは、このディレクトリで編集してから `install.sh` を再実行します。`~/.claude` 側を直接編集すると、次のインストールで上書きされます。
- 新しいファイルを配布対象にするときは、`managed-files.txt` に追記します。

反映した設定は、次に起動した Claude Code のセッションから有効になります。

## アンインストール

```bash
./uninstall.sh
```

`managed-files.txt` のファイルだけを、確認プロンプトのあとで `~/.claude` から削除します。削除前のファイルは `~/.claude.backup.<日時>/` に退避され、`~/.claude` ディレクトリ自体と管理対象外のファイルは残ります。

## プロジェクト固有の設定

プロジェクトごとに設定を変えたい場合は、そのプロジェクトの `.claude/` や `CLAUDE.md` に書きます。プロジェクト側の設定がユーザー設定より優先されます。

## 参考リンク

* [社内で「え、そんなことできるの？」と話題になった Claude Code Custom slash commands の実践活用](https://zenn.dev/hacobu/articles/d4a194b95aacd5) - Hacobuテックブログ
* [Claude Codeを10倍賢くする無料ツール「Serena」の威力とトークン効率化術](https://zenn.dev/sc30gsw/articles/ff81891959aaef) - Zenn
