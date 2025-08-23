# SuperClaude サマリー

## 概要

**SuperClaude**は、Claude（AI）を10倍便利にする拡張ツールです。コード自動生成、バグ自動修正、設計書自動作成など、開発作業の効率化を実現します。

## 主な機能

- コード自動生成
- バグ自動修正
- 設計書自動作成
- その他めんどくさい作業全般の自動化

## 環境構築

### 前提条件

1. **uv** - Pythonパッケージ管理ツール（環境設定済み）

### インストール手順



#### 1. SuperClaudeのインストール

```bash
# uvを使ってSuperClaudeをインストール
uv add SuperClaude

# 確認
SuperClaude --version
```

#### 2. セットアップ

```bash
# 対話形式でセットアップ
SuperClaude install

# 推奨プロファイル: quick（基本機能のみ、2分で完了）
```

## 基本コマンド

### コマンドプレフィックス
- `/sc:` - SuperClaudeコマンドの基本プレフィックス

### 主要コマンド

#### 分析・診断
```bash
/sc:analyze .                    # プロジェクト全体を分析
/sc:analyze . --focus quality    # 品質に焦点を当てて分析
/sc:analyze . --focus security   # セキュリティに焦点を当てて分析
```

#### 開発支援
```bash
/sc:workflow requirements.md     # 要件から設計を生成
/sc:design feature --type detailed # 設計を詳細化
/sc:implement feature --safe --with-tests # 実装（テスト付き）
```

#### バグ修正
```bash
/sc:troubleshoot "エラーログ"   # エラー内容を即座に分析
/sc:improve file.js --focus error-handling --safe # 修正案を生成
/sc:test file.js --add-tests    # テストを追加
```

#### ドキュメント生成
```bash
/sc:document feature --type api # APIドキュメント生成
/sc:document changelog --type release # リリースノート生成
```

## 実践的な使用例

### Phase 1: プロジェクト分析時
```bash
# 1. 現状把握
/sc:analyze . --focus quality
/sc:analyze . --focus security

# 2. 改善計画を立てる
/sc:workflow improvements.md --estimate
```

### Phase 2: 機能開発時
```bash
# 黄金の開発フロー
/sc:workflow requirements/new-feature.md
/sc:design new-feature --type detailed
/sc:implement new-feature --safe --with-tests
/sc:document new-feature --type api
```

### Phase 3: バグ修正時
```bash
# 緊急対応フロー
/sc:troubleshoot "本番のエラーログをコピペ"
/sc:analyze affected-files --focus dependencies
/sc:improve buggy-file.js --focus error-handling --safe
/sc:test buggy-file.js --add-tests
```

### Phase 4: リリース前
```bash
# リリース前チェックリスト
/sc:analyze . --focus security
/sc:analyze . --focus performance
/sc:test . --coverage
/sc:build . --type prod --optimize
/sc:document changelog --type release
```

## 上級テクニック

### Wave Mode（複数AI協調作業）
```bash
# 大規模機能を一気に実装
/sc:spawn "implement-payment-system" --wave-mode

# 裏で起きてること：
# - Architectペルソナ: システム設計
# - Backendペルソナ: API実装
# - Frontendペルソナ: UI実装
# - QAペルソナ: テスト作成
```

### トークン節約術
```bash
--uc              # Ultra Compressed（50%節約）
--answer-only     # 余計な説明カット（30%節約）

# 組み合わせ例
/sc:analyze large-project/ --uc --answer-only
```

### 深思考モード
```bash
--think        # ちょっと考える（+5秒）
--think-hard   # めっちゃ考える（+15秒）
--ultrathink   # 限界まで考える（+30秒）
```

## トラブルシューティング

### よくある問題と解決方法

**Q: コマンド打っても反応しない**
- Claude Codeの再起動
- プロジェクトフォルダで実行しているか確認
- `/sc:` のプレフィックスを忘れていないか確認

**Q: エラーが英語で意味不明**
```bash
/sc:explain "エラーメッセージ" --persona-scribe=ja
```

**Q: 実行が遅い**
```bash
# 軽量モードを使う
--uc --no-mcp
```

## 参考リンク

- [【完全保存版】SuperClaudeコマンドチート集 - ゼロから始めるつよつよAI開発エージェント環境構築](https://qiita.com/akira_papa_AI/items/b350c2a6911408b45e59) - Qiita

## まとめ

SuperClaudeは、開発作業の効率化を大幅に向上させる強力なツールです。uvが環境設定済みのため、`uv add SuperClaude`で簡単にインストールでき、基本的なセットアップが完了すれば、`/sc:`コマンドで様々な開発タスクを自動化できます。

特に以下の場面で効果を発揮します：
- プロジェクトの現状分析
- 新機能の設計・実装
- バグの迅速な修正
- リリース前の品質確認
- レガシーコードのメンテナンス

uvによる高速なパッケージ管理とSuperClaudeの強力な機能を組み合わせることで、開発効率が大幅に向上します。初心者は「quick」プロファイルから始めて、徐々に高度な機能を活用していくことをお勧めします。
