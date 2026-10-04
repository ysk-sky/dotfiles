---
name: clean-refactor
description: Use when the user asks to review or fix code against Readable Code and Clean Architecture principles (レイヤー分離, 依存性の方向, DIP, 単一責任, 命名, ガード節, 自己文書化), when the user asks for an adversarial review of code (敵対的にレビュー, 敵対的レビュー), or to resume such a refactoring after a token limit or session break.
argument-hint: "[対象のパス・ディレクトリ・ブランチ（省略時は再開 or 現在の差分）]"
---

# Clean Refactor

Review the target against the checklist below and, when fixes are requested, fix it in small, behavior-preserving steps whose progress survives a token limit or a new session.

Target: $ARGUMENTS

## Constraints

- Do not use the Agent tool or any subagent. Work inline; the user is conserving tokens.
- Fix one finding per step and never batch unrelated fixes.
- Behavior must not change.
- Do not commit unless asked.

## Fix mode

Fix mode is on when the user's request asks for changes (修正, 直して, リファクタリング, etc.) or the progress memory records `修正: 依頼あり`. Otherwise it is off: stop after showing the findings and enter Step 3 only when the user asks for fixes. When fix mode turns on, record `修正: 依頼あり` in the progress memory so a resumed session keeps fixing.

## Step 1: Resume or start

Progress lives in `refactor-progress-<repo>-<target>.md` in the memory directory (the repo name keeps targets in different repositories apart when they share a memory directory).

- **Target given**: if its progress memory exists, resume it; otherwise go to Step 2.
- **Target empty**: list `refactor-progress-<repo>-*` memories. One → resume it. Several → ask which. None → use uncommitted changes plus the branch's diff from the default branch; if there is no diff, ask which code to review.

If fix mode is off, show the open findings and stop. Otherwise, to resume, open the code of the item marked `← 次`. If the problem is already gone (the previous session stopped before recording it), check the item and move on. Do not re-review completed items.

## Step 2: Review (new target only)

Find the verification commands (tests, lint, type check) and read the target. List findings ranked by impact, architecture first. Each finding gets an ID, `file` + function/class name (not a line number; lines shift as fixes land), the viewpoint, the problem, and the planned fix. Save the list to the progress memory and show it to the user. If fix mode is on, start Step 3 without waiting; otherwise stop.

If the project has no test framework, do not add one; ask the user, because it is a new dependency.

### Clean Architecture

- **Layer separation**: domain / use-case logic mixed with DB, framework, HTTP, file I/O, env vars, or clock/randomness.
- **Dependency direction**: domain or use-case modules importing infrastructure or framework modules.
- **DIP**: an inner layer calling a concrete outer implementation where it should depend on an interface it owns.

### Readable Code

- **Single responsibility**: a function or class doing several jobs (its summary needs "and", it mixes abstraction levels, or it is long enough to need scrolling).
- **Naming**: names that hide intent, mislead, or are generic (`data`, `info`, `handle`, `manager`, `tmp`); booleans that don't read as predicates.
- **Control flow**: nesting of 3+ levels, `else` after `return`, flag variables. Prefer guard clauses / early return.
- **Self-documenting code**: comments that restate *what* the code does. Fix the code by renaming or extracting, keep the comment, and list its deletion under 保留. Comments that remain should explain *why*.

### Proportionality

Match the project's stage and size. Introduce an interface only at a real boundary (I/O, external service, framework) or where a test needs a substitute. A fix that needs broad structural change (moving layers, new directories, public API changes) goes under 保留 and is proposed to the user before any work.

## Step 3: Fix loop

For each open finding, in order:

1. If the fix restructures logic (extraction, control flow, moving code across layers) and no test covers that behavior, add a characterization test and watch it pass against the current code. A pure rename needs only the type check / compiler.
2. Make the minimal change for that finding only.
3. Run the recorded verification commands. On failure, fix the root cause or revert this step.
4. Update the progress memory: check the item, move `← 次`, and note pitfalls.
5. Report to the user in one or two lines.

Update the memory after every finding; the session may stop at any moment.

Out-of-scope problems (bugs, unused code, outdated dependencies outside the target) go under 報告事項 and are not fixed.

## Progress memory

Create it as a `project` memory and add its index line to `MEMORY.md`:

```markdown
---
name: refactor-progress-<repo>-<target>
description: <repo> の <対象> のリーダブルコード/クリーンアーキテクチャ修正の進捗（再開用）
metadata:
  type: project
---
対象: <path or branch> / 修正: 依頼あり|なし / 検証: `<test>` `<lint>` `<typecheck>` / 開始: YYYY-MM-DD

## 指摘
- [x] F1 src/order.ts `calcTotal` 命名 — `data` → `unpaidInvoices`
- [ ] F2 src/order.ts `applyDiscount` 制御フロー — ネスト4段をガード節に ← 次

## 保留（要判断）
## 報告事項（範囲外）
```

## Finish

When every finding is checked or held, run all verification commands, delete the progress memory and its index line, and summarize: 何をしたか / 分かったこと / 判断してほしいこと（保留・報告事項）.
