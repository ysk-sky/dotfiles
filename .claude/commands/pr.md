---
allowed-tools: Bash(gh:*), Bash(git:*)
description: Generate PR description, get approval, then create pull request on GitHub
---

## Context

- Default branch: !`git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || gh repo view --json defaultBranchRef -q '"origin/" + .defaultBranchRef.name' 2>/dev/null || echo origin/main`
- Current git status: !`git status`
- Changes in this PR: !`git diff $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)...HEAD`
- Commits in this PR: !`git log --oneline $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo origin/main)..HEAD`
- PR template: !`cat .github/pull_request_template.md 2>/dev/null || echo "(テンプレートなし: 概要 / 変更内容 / 動作確認 の構成で記述すること)"`

## Your task

Based on the provided option, perform one of the following actions:

### Options:

- **No option or default**: Generate PR title/description, get approval, then create the pull request
- **-p**: Same as default, and always push the current branch first (after approval)
- **-u**: Update existing pull request description only (after approval)

Every option follows the same rule: **show the full PR title and body first and wait for the user's explicit approval before running any outward-facing command** (`git push`, `gh pr create`, `gh pr edit`). Approval of the draft is not approval of the push; ask for both in the same message.

### Default behavior (no option):

1. Create a PR title and description following the **exact format** of the PR template in Japanese
2. **Add a Mermaid diagram** that visualizes the changes made in this PR
3. Show the full title and body to the user and wait for approval
4. If the current branch has no upstream, push it with `git push -u origin <current-branch>`
5. Execute `gh pr create --draft` with the approved title and description

### With -p option:

1. Create a PR title and description following the **exact format** of the PR template in Japanese
2. **Add a Mermaid diagram** that visualizes the changes made in this PR
3. Show the full title and body to the user and wait for approval
4. Push the current branch using `git push -u origin <current-branch>`
5. Execute `gh pr create --draft` with the approved title and description

### With -u option:

1. Create a PR description following the **exact format** of the PR template in Japanese
2. **Add a Mermaid diagram** that visualizes the changes made in this PR
3. Show the full body to the user and wait for approval
4. Update existing pull request description using `gh pr edit --body <description>`

### Requirements:

1. Follow the template structure exactly (if no template exists, use 概要 / 変更内容 / 動作確認)
2. Use Japanese for all content
3. Include specific implementation details
4. List concrete testing steps
5. Always include a Mermaid diagram that shows:
   - Architecture changes (if any)
   - Data flow modifications
   - Component relationships
   - Process flows affected by the changes
6. Be comprehensive but concise
7. **Never include Claude/AI attribution** (no "🤖 Generated with Claude Code", no Co-Authored-By footer)

### Mermaid Diagram Guidelines:

- Use appropriate diagram types (flowchart, sequence, class, etc.)
- Show before/after states if applicable
- Highlight new or modified components
- Use consistent styling and colors
- Add the diagram in a dedicated section of the PR description

**Generate the PR description, present it for approval, and only then create the pull request.**
