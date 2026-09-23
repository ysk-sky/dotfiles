---
allowed-tools: Read, Glob, Grep, Edit, Write, Bash, mcp__serena, mcp__context7__resolve-library-id, mcp__context7__query-docs
description: Serena MCP を使って開発タスク（実装・デバッグ・設計・レビュー）を進める
argument-hint: '[debug|design|review|implement] "<課題>" [-r] [-t] [--summary]'
---

## 使い方

```bash
/serena "ログインのバグを直す"            # 種別は内容から判断
/serena debug "本番のメモリリーク"
/serena design "認証基盤" -r              # -r: 先に Context7 で最新ドキュメントを調べる
/serena implement "検索フィルタ追加" -t   # -t: 実装タスクを TODO に分解してから進める
/serena review "この処理を最適化" --summary  # --summary: 結論と次のアクションだけを返す
```

## コンテキスト
- 設定ファイル: !`find . -maxdepth 2 \( -name "package.json" -o -name "*.config.*" \) 2>/dev/null | head -5`
- Git 状態: !`git status --porcelain 2>/dev/null | head -5`

## タスク

依頼: $ARGUMENTS

種別（debug / design / review / implement）が指定されていれば、それに応じた成果物を目指してください。debug なら再現と根本原因の特定、design なら選択肢とトレードオフを示したうえでの推奨、review なら根拠つきの指摘、implement ならテストの通った実装です。種別の指定がなければ、依頼の内容から判断します。

コードの読み取りと編集には Serena MCP のシンボル単位のツール（シンボル概要・参照検索・シンボル本体の置換など）を優先して使ってください。ファイル全体を読むより必要な箇所だけを扱えるためです。Serena に接続できない場合は、その旨を一言伝えて通常の Read / Edit / Grep で進めます。ライブラリの API は記憶に頼らず、必要に応じて Context7 で確認してください。

最後に、結論・変更内容・検証結果・次のアクションを日本語で簡潔にまとめてください。
