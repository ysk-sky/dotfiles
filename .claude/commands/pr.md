---
allowed-tools: Bash(gh:*), Bash(git:*)
description: Generate PR description, get approval, then create pull request on GitHub
---

## Context

- Default branch: !`git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || gh repo view --json defaultBranchRef -q '"origin/" + .defaultBranchRef.name' 2>/dev/null || echo origin/main`
- Current git status: !`git status`
- Changes in this PR: !`git diff $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)...HEAD`
- Commits in this PR: !`git log --oneline $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)..HEAD`
- PR template: !`cat .github/pull_request_template.md 2>/dev/null || echo "(テンプレートなし)"`
- Recent merged PRs (style reference): !`gh pr list --state merged --limit 3 --json number,title -q '.[] | "#\(.number) \(.title)"' 2>/dev/null`

## Your task

Options:

- **No option**: draft the PR, get approval, push the branch if it has no upstream, then `gh pr create`
- **-u**: draft a new body for the existing PR, get approval, then `gh pr edit --body-file`

Show the full title and body before any `git push`, `gh pr create`, or `gh pr edit`, and wait for explicit approval. Ask for approval of the push in the same message, because approving the text is not approving the push.

Write the body to a file in the scratchpad and pass it with `--body-file`, so that tables and backticks survive shell quoting. Do not pass `--draft` unless the user asks for it.

## How to write the PR

Match the repository's recent merged PRs (read one or two with `gh pr view <number>`). If the repository has a PR template, follow it. Otherwise use these structures:

- **Fix**: `## 概要` (what was happening and what it broke, stated directly) / `## 原因` / `## 修正内容` / `## 補足`
- **Feature or other change**: `## 概要` (what becomes possible and why it is needed) / `## 実装内容` / `## 補足`

Rules, with the reason each one exists:

- `## 原因` must reach the mechanism: why the code or design produced the symptom, not a restatement of the symptom. The user rejects PRs with shallow analysis. If part of the cause is still unconfirmed, say which part.
- Present changes as a `| WHAT | WHY |` table. Reviewers need the reason for each decision, not only the list of edits.
- Include at least one Mermaid diagram so the change can be grasped at a glance: for a fix, the path from cause to symptom in `## 原因`; for a feature, the new flow or structure in `## 実装内容`. Show before and after side by side when the flow changes. Use a table to contrast states or conditions.
- Keep diagrams on standard Mermaid elements without custom colors, so they stay readable in both GitHub light and dark themes.
- Do not report results that CI already shows, such as test counts or lint passing.
- Never write admissions of weakness in the PR body, such as "未確認", "未検証", "見送った", or "別件で判断する". They push reviewers toward rejection. Verify what you can before drafting. Report anything still unverified or deliberately out of scope to the user in the chat, alongside the draft, and let the user decide.
- `## 補足` is optional and holds only facts the reviewer or operator needs, such as deploy steps or migration notes, stated affirmatively.
- Write in Japanese, in plain form (だ・である・体言止め), with bullet points and short sentences. Describe the symptom, cause, and change, not how the work was carried out.
- Title: `type: 要約` in Japanese, following conventional commits.
- Never include Claude/AI attribution (no "Generated with Claude Code", no Co-Authored-By, no session URL).
